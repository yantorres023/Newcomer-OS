import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/data/dataset_loader.dart';
import 'package:newcomer_os/data/local_store.dart';
import 'package:newcomer_os/domain/local_date.dart';
import 'package:newcomer_os/domain/roadmap_resolver.dart';
import 'package:newcomer_os/services/analytics.dart';
import 'package:newcomer_os/services/reminder_service.dart';
import 'package:newcomer_os/state/app_controller.dart';

import '../support/controller.dart';
import '../support/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads bundled dataset offline and starts at disclaimer', () async {
    final h = Harness();
    await h.controller.init();
    expect(h.controller.status, AppStatus.ready);
    expect(h.controller.needsDisclaimer, isTrue);
    expect(h.controller.needsOnboarding, isTrue);
    expect(h.controller.roadmap('en'), isNull);
  });

  test('onboarding → roadmap → completion is persisted', () async {
    final h = Harness();
    await h.controller.init();
    await h.controller.acceptDisclaimer();
    await h.controller.completeOnboarding(profile());
    final r = h.controller.roadmap('en')!;
    expect(r.tasks, isNotEmpty);
    await h.controller.setCompleted('de.insurance.health_insurance', true);
    expect(
      h.controller.roadmap('en')!.byId('de.insurance.health_insurance')!.bucket,
      TaskBucket.done,
    );

    // Reload from the same storage: state survives restart.
    final again = Harness(backend: h.backend);
    await again.controller.init();
    expect(again.controller.needsDisclaimer, isFalse);
    expect(
      again.controller.state.completions.keys,
      contains('de.insurance.health_insurance'),
    );
    expect(
      h.analytics.events.map((e) => e.$1),
      containsAllInOrder([
        AnalyticsEvent.onboardingCompleted,
        AnalyticsEvent.roadmapGenerated,
        AnalyticsEvent.taskCompleted,
      ]),
    );
  });

  test('analytics never receive profile answers or dates', () async {
    final h = Harness();
    await h.controller.init();
    await h.controller.completeOnboarding(
      profile(moveIn: LocalDate(2026, 10, 2), age30: true, family: true),
    );
    await h.controller.setCompleted('de.registration.anmeldung', true);
    final text = h.analytics.events.map((e) => e.$2.toString()).join();
    for (final forbidden in ['2026', 'berlin', 'national_visa', 'age']) {
      expect(text.contains(forbidden), isFalse, reason: forbidden);
    }
  });

  test('reminders: schedule, clear on completion, permission denied', () async {
    final h = Harness();
    await h.controller.init();
    await h.controller.completeOnboarding(profile());
    const content = ReminderContent(title: 't', body: 'b');
    final ok = await h.controller.setReminder(
      'de.registration.anmeldung',
      LocalDate(2026, 10, 5),
      content,
    );
    expect(ok, isTrue);
    final id = notificationIdFor('de.registration.anmeldung');
    expect(h.reminders.scheduled[id]!.$1, LocalDate(2026, 10, 5));

    await h.controller.setCompleted('de.registration.anmeldung', true);
    expect(h.reminders.scheduled, isEmpty);
    expect(h.controller.state.reminders, isEmpty);

    h.reminders.permissionGranted = false;
    final denied = await h.controller.setReminder(
      'de.insurance.health_insurance',
      LocalDate(2026, 10, 5),
      content,
    );
    expect(denied, isFalse);
    expect(h.controller.state.reminders, isEmpty);
  });

  test(
    'profile change cancels reminders of tasks that no longer apply',
    () async {
      final h = Harness();
      await h.controller.init();
      await h.controller.completeOnboarding(profile(work: true));
      await h.controller.setReminder(
        'de.work.limits',
        LocalDate(2026, 10, 9),
        const ReminderContent(title: 't', body: 'b'),
      );
      expect(h.reminders.scheduled, hasLength(1));
      await h.controller.completeOnboarding(profile(work: false));
      expect(h.reminders.scheduled, isEmpty);
      expect(h.controller.roadmap('en')!.byId('de.work.limits'), isNull);
    },
  );

  test('notes are trimmed and removed when empty', () async {
    final h = Harness();
    await h.controller.init();
    await h.controller.completeOnboarding(profile());
    await h.controller.setNote('de.registration.anmeldung', '  hello ');
    expect(h.controller.state.notes['de.registration.anmeldung'], 'hello');
    await h.controller.setNote('de.registration.anmeldung', '   ');
    expect(h.controller.state.notes, isEmpty);
  });

  test('opening sources only works for dataset links and is tracked', () async {
    final h = Harness();
    await h.controller.init();
    await h.controller.completeOnboarding(profile());
    final task = h.controller.roadmap('en')!.byId('de.registration.anmeldung')!;
    await h.controller.openSource(task.id, task.sources.first);
    expect(h.opened.single.toString(), task.sources.first.url);
    expect(h.analytics.events.last.$1, AnalyticsEvent.officialSourceOpened);
  });

  test('delete all data wipes storage and reminders', () async {
    final h = Harness();
    await h.controller.init();
    await h.controller.completeOnboarding(profile());
    await h.controller.setReminder(
      'de.registration.anmeldung',
      LocalDate(2026, 10, 5),
      const ReminderContent(title: 't', body: 'b'),
    );
    await h.controller.deleteAllData();
    expect(h.backend.contents, isNull);
    expect(h.reminders.scheduled, isEmpty);
    expect(h.controller.needsOnboarding, isTrue);
  });

  test('export is valid JSON with the profile', () async {
    final h = Harness();
    await h.controller.init();
    await h.controller.completeOnboarding(profile());
    final json = jsonDecode(h.controller.exportData()) as Map;
    expect((json['profile'] as Map)['city'], 'berlin');
  });

  test('invalid bundled dataset shows an error instead of content', () async {
    final rules = clone(readJson(rulesPath));
    ruleIn(rules, 'de.tax.tax_id_letter')['sources'] = [];
    final bundle = _MapBundle({
      DatasetLoader.manifestPath: readJsonRaw('assets/roadmaps/manifest.json'),
      rulesPath: jsonEncode(rules),
      sourcesPath: readJsonRaw(sourcesPath),
    });
    final controller = AppController(
      store: LocalStore(MemoryStoreBackend()),
      datasetLoader: DatasetLoader(bundle: bundle),
      reminders: FakeReminderScheduler(),
      analytics: RecordingAnalyticsSink(),
    );
    await controller.init();
    expect(controller.status, AppStatus.datasetError);
    expect(controller.datasetError, contains('without source'));
  });

  test('missing asset is reported as dataset error', () async {
    final controller = AppController(
      store: LocalStore(MemoryStoreBackend()),
      datasetLoader: DatasetLoader(bundle: _MapBundle({})),
      reminders: FakeReminderScheduler(),
      analytics: RecordingAnalyticsSink(),
    );
    await controller.init();
    expect(controller.status, AppStatus.datasetError);
  });

  test('corrupt storage recovers and reports it', () async {
    final h = Harness(backend: MemoryStoreBackend('{{{'));
    await h.controller.init();
    expect(h.controller.status, AppStatus.ready);
    expect(h.controller.loadOutcome, LoadOutcome.recoveredFromCorruption);
  });
}

class _MapBundle extends CachingAssetBundle {
  _MapBundle(this.files);
  final Map<String, String> files;

  @override
  Future<ByteData> load(String key) async {
    final s = files[key];
    if (s == null) throw FlutterError('missing $key');
    return ByteData.sublistView(utf8.encode(s));
  }
}
