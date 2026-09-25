import 'package:flutter/foundation.dart';

import '../data/dataset_loader.dart';
import '../data/local_store.dart';
import '../domain/dataset.dart';
import '../domain/local_date.dart';
import '../domain/profile.dart';
import '../domain/roadmap_resolver.dart';
import '../domain/user_state.dart';
import '../services/analytics.dart';
import '../services/link_service.dart';
import '../services/reminder_service.dart';

enum AppStatus { loading, ready, datasetError }

/// Current disclaimer text version; bump to ask users to re-read it.
const disclaimerVersion = 1;

/// Single source of truth for the UI. Holds the bundled dataset (read-only)
/// and the user's local state, and recomputes the roadmap on demand.
class AppController extends ChangeNotifier {
  AppController({
    required this.store,
    required this.datasetLoader,
    required this.reminders,
    required this.analytics,
    LocalDate Function()? today,
    this.linkLauncher,
  }) : _today = today ?? (() => LocalDate.fromDateTime(DateTime.now()));

  final LocalStore store;
  final DatasetLoader datasetLoader;
  final ReminderScheduler reminders;
  final AnalyticsSink analytics;
  final LocalDate Function() _today;
  final LinkLauncher? linkLauncher;

  AppStatus status = AppStatus.loading;
  String? datasetError;
  LoadOutcome? loadOutcome;
  bool saveFailed = false;

  RoadmapDataset? _dataset;
  UserState _state = const UserState();
  LinkService? _links;

  RoadmapDataset get dataset => _dataset!;
  UserState get state => _state;
  UserProfile? get profile => _state.profile;
  LinkService get links => _links!;
  LocalDate get today => _today();

  bool get needsDisclaimer =>
      (_state.settings.disclaimerAcceptedVersion ?? 0) < disclaimerVersion;
  bool get needsOnboarding => _state.profile == null;

  Future<void> init() async {
    try {
      _dataset = await datasetLoader.load();
      _links = LinkService.forDataset(_dataset!, launcher: linkLauncher);
    } on DatasetLoadException catch (e) {
      datasetError = e.message;
      status = AppStatus.datasetError;
      notifyListeners();
      return;
    }
    final result = await store.load();
    _state = result.state;
    loadOutcome = result.outcome;
    status = AppStatus.ready;
    notifyListeners();
  }

  /// Roadmap in [language] ("en"/"de"); null before onboarding.
  Roadmap? roadmap(String language) {
    final p = _state.profile;
    if (p == null || _dataset == null) return null;
    return const RoadmapResolver().resolve(
      dataset: _dataset!,
      profile: p,
      state: _state,
      today: today,
      language: language,
    );
  }

  Future<void> _commit(UserState next) async {
    _state = next;
    notifyListeners();
    try {
      await store.save(next);
      if (saveFailed) {
        saveFailed = false;
        notifyListeners();
      }
    } on Object {
      saveFailed = true;
      notifyListeners();
    }
  }

  Future<void> acceptDisclaimer() => _commit(
    _state.copyWith(
      settings: _state.settings.copyWith(
        disclaimerAcceptedVersion: disclaimerVersion,
      ),
    ),
  );

  Future<void> completeOnboarding(UserProfile profile) async {
    final isFirst = _state.profile == null;
    await _commit(_state.copyWith(profile: () => profile));
    await _cancelRemindersForInapplicableTasks();
    analytics.track(
      isFirst
          ? AnalyticsEvent.onboardingCompleted
          : AnalyticsEvent.profileUpdated,
    );
    if (isFirst) {
      analytics.track(AnalyticsEvent.roadmapGenerated, {
        'task_count': roadmap('en')?.totalCount ?? 0,
      });
    }
  }

  Future<void> setCompleted(String ruleId, bool completed) async {
    final rule = dataset.ruleById(ruleId);
    if (rule == null) return;
    final completions = Map.of(_state.completions);
    if (completed) {
      completions[ruleId] = CompletionRecord(
        ruleId: ruleId,
        ruleVersion: rule.version,
        completedOn: today,
      );
      if (rule.supersedes != null) completions.remove(rule.supersedes);
    } else {
      completions.remove(ruleId);
      if (rule.supersedes != null) completions.remove(rule.supersedes);
    }
    await _commit(_state.copyWith(completions: completions));
    if (completed) {
      await clearReminder(ruleId);
      final r = roadmap('en');
      analytics.track(AnalyticsEvent.taskCompleted, {
        'rule_id': ruleId,
        'completed': r?.completedCount ?? 0,
        'total': r?.totalCount ?? 0,
      });
    } else {
      analytics.track(AnalyticsEvent.taskReopened, {'rule_id': ruleId});
    }
  }

  /// Re-confirms a task completed against an older rule version.
  Future<void> reconfirm(String ruleId) => setCompleted(ruleId, true);

  Future<void> setNote(String ruleId, String note) async {
    final notes = Map.of(_state.notes);
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      notes.remove(ruleId);
    } else {
      notes[ruleId] = trimmed;
    }
    await _commit(_state.copyWith(notes: notes));
  }

  /// Returns false when notification permission is denied.
  Future<bool> setReminder(
    String ruleId,
    LocalDate date,
    ReminderContent content,
  ) async {
    final granted = await reminders.requestPermission();
    if (!granted) return false;
    final id = notificationIdFor(ruleId);
    await reminders.schedule(id: id, date: date, content: content);
    await _commit(
      _state.copyWith(
        reminders: {
          ..._state.reminders,
          ruleId: Reminder(ruleId: ruleId, date: date, notificationId: id),
        },
      ),
    );
    analytics.track(AnalyticsEvent.reminderCreated, {'rule_id': ruleId});
    return true;
  }

  Future<void> clearReminder(String ruleId) async {
    final existing = _state.reminders[ruleId];
    if (existing == null) return;
    await reminders.cancel(existing.notificationId);
    await _commit(
      _state.copyWith(reminders: Map.of(_state.reminders)..remove(ruleId)),
    );
  }

  Future<void> _cancelRemindersForInapplicableTasks() async {
    final r = roadmap('en');
    if (r == null) return;
    for (final ruleId in _state.reminders.keys.toList()) {
      final task = r.byId(ruleId);
      if (task == null || !task.stillApplies) await clearReminder(ruleId);
    }
  }

  Future<void> setLanguage(LanguagePreference language) async {
    await _commit(
      _state.copyWith(settings: _state.settings.copyWith(language: language)),
    );
    analytics.track(AnalyticsEvent.languageChanged, {
      'language': language.name,
    });
  }

  Future<void> setShowTaskNamesInNotifications(bool value) => _commit(
    _state.copyWith(
      settings: _state.settings.copyWith(showTaskNamesInNotifications: value),
    ),
  );

  Future<LinkOpenResult> openSource(String ruleId, Source source) async {
    final result = await links.open(source.url);
    if (result == LinkOpenResult.opened) {
      analytics.track(AnalyticsEvent.officialSourceOpened, {
        'rule_id': ruleId,
        'source_id': source.id,
      });
    }
    return result;
  }

  void trackTaskViewed(String ruleId) =>
      analytics.track(AnalyticsEvent.taskViewed, {'rule_id': ruleId});

  void trackOnboardingStarted() =>
      analytics.track(AnalyticsEvent.onboardingStarted);

  String exportData() => store.export(_state);

  Future<void> deleteAllData() async {
    await reminders.cancelAll();
    await store.deleteAll();
    _state = const UserState();
    analytics.track(AnalyticsEvent.dataDeleted);
    notifyListeners();
  }
}
