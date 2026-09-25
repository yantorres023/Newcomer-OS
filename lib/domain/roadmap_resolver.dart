import 'dataset.dart';
import 'local_date.dart';
import 'profile.dart';
import 'user_state.dart';

enum TaskBucket { today, upcoming, whenItHappens, done }

enum Urgency { overdue, dueSoon, normal }

/// One rule applied to one user: definition + computed dates + user progress.
class TaskInstance {
  const TaskInstance({
    required this.rule,
    required this.content,
    required this.contentLanguage,
    required this.usedFallbackLanguage,
    required this.sources,
    required this.dueDate,
    required this.suggestedStart,
    required this.missingAnchor,
    required this.blockedBy,
    required this.recommendedAfter,
    required this.completion,
    required this.updatedSinceCompletion,
    required this.stillApplies,
    required this.bucket,
    required this.urgency,
    required this.reminder,
    required this.note,
  });

  final RuleDefinition rule;
  final RuleContent content;
  final String contentLanguage;
  final bool usedFallbackLanguage;
  final List<Source> sources;
  final LocalDate? dueDate;
  final LocalDate? suggestedStart;

  /// Profile field (e.g. `move_in_date`) the deadline needs but is missing.
  final String? missingAnchor;
  final List<RuleDefinition> blockedBy;
  final List<RuleDefinition> recommendedAfter;
  final CompletionRecord? completion;

  /// Completed against an older rule version — the user should re-check.
  final bool updatedSinceCompletion;

  /// False when the task was completed but the profile no longer selects it.
  final bool stillApplies;
  final TaskBucket bucket;
  final Urgency urgency;
  final Reminder? reminder;
  final String? note;

  String get id => rule.id;
  bool get isCompleted => completion != null;
}

class Roadmap {
  const Roadmap({required this.tasks, required this.today});

  final List<TaskInstance> tasks;
  final LocalDate today;

  List<TaskInstance> bucket(TaskBucket b) =>
      tasks.where((t) => t.bucket == b).toList();

  TaskInstance? byId(String id) {
    for (final t in tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// Tasks that count towards progress (not event-triggered, still apply).
  Iterable<TaskInstance> get _trackable => tasks.where(
    (t) => t.stillApplies && t.rule.timing.type != TimingType.event,
  );

  int get totalCount => _trackable.length;
  int get completedCount => _trackable.where((t) => t.isCompleted).length;

  TaskInstance? get nextDeadline {
    final open =
        tasks
            .where((t) => !t.isCompleted && t.dueDate != null && t.stillApplies)
            .toList()
          ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return open.isEmpty ? null : open.first;
  }
}

/// Deterministic roadmap generation: profile + explicit rule conditions →
/// task list. No free-text or model output participates.
class RoadmapResolver {
  const RoadmapResolver({this.dueSoonDays = 14});

  /// Tasks due within this many days are shown under "Today".
  final int dueSoonDays;

  Roadmap resolve({
    required RoadmapDataset dataset,
    required UserProfile profile,
    required UserState state,
    required LocalDate today,
    required String language,
  }) {
    final fields = profile.conditionFields;
    final active = dataset.rules
        .where((r) => r.status == RuleStatus.active && r.isEffectiveOn(today))
        .toList();
    final applicableIds = {
      for (final r in active)
        if (r.appliesTo.evaluate(fields)) r.id,
    };

    CompletionRecord? completionFor(RuleDefinition rule) =>
        state.completions[rule.id] ??
        (rule.supersedes == null ? null : state.completions[rule.supersedes]);

    final tasks = <TaskInstance>[];
    for (final rule in active) {
      final applies = applicableIds.contains(rule.id);
      final completion = completionFor(rule);
      if (!applies && completion == null) continue;

      final lang = rule.content.containsKey(language)
          ? language
          : dataset.defaultLanguage;
      final content = rule.content[lang] ?? rule.content.values.first;

      final sources = [
        for (final ref in rule.sources)
          if (ref.when == null || ref.when!.evaluate(fields))
            ?dataset.sources[ref.sourceId],
      ];

      List<RuleDefinition> openDeps(DependencyType type) => [
        for (final dep in rule.dependsOn)
          if (dep.type == type &&
              applicableIds.contains(dep.ruleId) &&
              state.completions[dep.ruleId] == null)
            ?dataset.ruleById(dep.ruleId),
      ];
      final blockedBy = openDeps(DependencyType.requires);
      final recommendedAfter = openDeps(DependencyType.recommendedAfter);

      final (due, missing) = _dueDate(rule.timing, profile, state);
      final suggested =
          due != null && rule.timing.suggestedStartDaysBefore != null
          ? due.addDays(-rule.timing.suggestedStartDaysBefore!)
          : null;

      // Only legal deadlines can be "overdue". A missed suggestion or
      // follow-up date stays prominent without alarming wording.
      final urgency = completion != null || due == null
          ? Urgency.normal
          : due.isBefore(today)
          ? (rule.timing.basis == TimingBasis.legal
                ? Urgency.overdue
                : Urgency.dueSoon)
          : today.daysUntil(due) <= dueSoonDays
          ? Urgency.dueSoon
          : Urgency.normal;

      tasks.add(
        TaskInstance(
          rule: rule,
          content: content,
          contentLanguage: lang,
          usedFallbackLanguage: lang != language,
          sources: sources,
          dueDate: due,
          suggestedStart: suggested,
          missingAnchor: missing,
          blockedBy: blockedBy,
          recommendedAfter: recommendedAfter,
          completion: completion,
          updatedSinceCompletion:
              completion != null &&
              (completion.ruleVersion < rule.version ||
                  completion.ruleId != rule.id),
          stillApplies: applies,
          bucket: _bucket(
            rule,
            completion,
            blockedBy,
            due,
            suggested,
            missing,
            urgency,
            today,
          ),
          urgency: urgency,
          reminder: state.reminders[rule.id],
          note: state.notes[rule.id],
        ),
      );
    }

    tasks.sort(_compare);
    return Roadmap(tasks: List.unmodifiable(tasks), today: today);
  }

  (LocalDate?, String?) _dueDate(
    Timing timing,
    UserProfile profile,
    UserState state,
  ) {
    if (timing.type != TimingType.afterAnchor &&
        timing.type != TimingType.beforeAnchor) {
      return (null, null);
    }
    final anchorName = timing.anchor!;
    LocalDate? anchor;
    if (anchorName.startsWith(Timing.completedPrefix)) {
      final ruleId = anchorName.substring(Timing.completedPrefix.length);
      anchor = state.completions[ruleId]?.completedOn;
      // Waiting on another task is expressed through dependencies, not as a
      // missing profile answer.
      if (anchor == null) return (null, null);
    } else {
      anchor = profile.conditionFields[anchorName] as LocalDate?;
      if (anchor == null) return (null, anchorName);
    }
    final shifted = anchor.addMonths(timing.offsetMonths);
    return (shifted.addDays(timing.offsetDays), null);
  }

  TaskBucket _bucket(
    RuleDefinition rule,
    CompletionRecord? completion,
    List<RuleDefinition> blockedBy,
    LocalDate? due,
    LocalDate? suggestedStart,
    String? missingAnchor,
    Urgency urgency,
    LocalDate today,
  ) {
    if (completion != null) return TaskBucket.done;
    if (rule.timing.type == TimingType.event) return TaskBucket.whenItHappens;
    if (blockedBy.isNotEmpty) return TaskBucket.upcoming;
    if (urgency != Urgency.normal) return TaskBucket.today;
    if (suggestedStart != null && !today.isBefore(suggestedStart)) {
      return TaskBucket.today;
    }
    if (due != null) return TaskBucket.upcoming;
    if (missingAnchor != null) return TaskBucket.today;
    if (rule.timing.type == TimingType.asap) return TaskBucket.today;
    return TaskBucket.upcoming;
  }

  static int _compare(TaskInstance a, TaskInstance b) {
    int rank(Urgency u) => switch (u) {
      Urgency.overdue => 0,
      Urgency.dueSoon => 1,
      Urgency.normal => 2,
    };
    final byUrgency = rank(a.urgency).compareTo(rank(b.urgency));
    if (byUrgency != 0) return byUrgency;
    if (a.dueDate != null && b.dueDate != null) {
      final byDate = a.dueDate!.compareTo(b.dueDate!);
      if (byDate != 0) return byDate;
    }
    return a.rule.order.compareTo(b.rule.order);
  }
}
