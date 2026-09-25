import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/dataset.dart';
import '../../domain/local_date.dart';
import '../../domain/roadmap_resolver.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/link_service.dart';
import '../../services/reminder_service.dart';
import '../../state/app_scope.dart';
import '../format.dart';
import '../onboarding/onboarding_screen.dart';
import '../widgets/task_status.dart';

/// Answers: what to do, why, when, what you need, where the official source
/// is, and what comes next.
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.ruleId});

  final String ruleId;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final TextEditingController _notes;
  bool _tracked = false;

  @override
  void initState() {
    super.initState();
    _notes = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_tracked) {
      _tracked = true;
      final controller = AppScope.read(context);
      _notes.text = controller.state.notes[widget.ruleId] ?? '';
      controller.trackTaskViewed(widget.ruleId);
    }
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    final lang = contentLanguage(context);
    final task = controller.roadmap(lang)?.byId(widget.ruleId);
    if (task == null) {
      // The task disappeared (e.g. profile changed while this was open).
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l.noLongerApplies)),
      );
    }
    final theme = Theme.of(context);
    final c = task.content;
    final rule = task.rule;

    return Scaffold(
      appBar: AppBar(title: Text(c.title, maxLines: 2)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Semantics(
              header: true,
              child: Text(c.title, style: theme.textTheme.headlineSmall),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                StatusChip(
                  icon: _kindIcon(rule.kind),
                  label: _kindLabel(l, rule.kind),
                ),
                if (task.urgency == Urgency.overdue)
                  StatusChip(
                    icon: Icons.warning_amber,
                    label: l.overdueLabel,
                    tone: ChipTone.danger,
                  ),
                if (task.updatedSinceCompletion)
                  StatusChip(
                    icon: Icons.update,
                    label: l.updatedSinceCompletion,
                    tone: ChipTone.attention,
                  ),
                if (!task.stillApplies)
                  StatusChip(
                    icon: Icons.remove_circle_outline,
                    label: l.noLongerApplies,
                  ),
              ],
            ),
            if (task.usedFallbackLanguage) ...[
              const SizedBox(height: 8),
              Text(l.fallbackLanguage, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            Text(c.summary, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              l.explanationLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            _Section(
              title: l.sectionWhen,
              children: [_WhenBlock(task: task)],
            ),
            if (task.blockedBy.isNotEmpty || task.recommendedAfter.isNotEmpty)
              _Section(
                title: l.dependencies,
                children: [
                  for (final dep in task.blockedBy)
                    _DependencyTile(rule: dep, lang: lang, hard: true),
                  for (final dep in task.recommendedAfter)
                    _DependencyTile(rule: dep, lang: lang, hard: false),
                ],
              ),
            _Section(title: l.sectionWhy, children: [Text(c.why)]),
            _Section(
              title: l.sectionSteps,
              children: [
                for (final (i, step) in c.steps.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '${i + 1}.',
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        Expanded(child: Text(step)),
                      ],
                    ),
                  ),
              ],
            ),
            if (rule.requiredDocuments.isNotEmpty)
              _Section(
                title: l.sectionDocs,
                children: [
                  for (final doc in rule.requiredDocuments)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ExcludeSemantics(
                        child: Icon(
                          doc.basis == DocumentBasis.official
                              ? Icons.verified_outlined
                              : Icons.help_outline,
                        ),
                      ),
                      title: Text(
                        controller.dataset.documents[doc.documentId]?[lang] ??
                            controller.dataset.documents[doc
                                .documentId]?['en'] ??
                            doc.documentId,
                      ),
                      subtitle: Text(
                        doc.basis == DocumentBasis.official
                            ? l.docOfficial
                            : l.docCommon,
                      ),
                    ),
                ],
              ),
            _Section(
              title: l.sectionSources,
              children: [
                for (final source in task.sources)
                  _SourceCard(ruleId: rule.id, source: source),
              ],
            ),
            if (rule.officialTerms.isNotEmpty)
              _Section(
                title: l.officialTerms,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final term in rule.officialTerms)
                        Chip(label: Text(term)),
                    ],
                  ),
                ],
              ),
            if (c.notes.isNotEmpty)
              _Section(title: l.sectionNotes, children: [Text(c.notes)]),
            if (rule.professionalHelp.isNotEmpty)
              _Section(
                title: l.professionalHelp,
                children: [
                  Text(
                    rule.professionalHelp[lang] ?? rule.professionalHelp['en']!,
                  ),
                ],
              ),
            _Section(title: l.sectionWho, children: [Text(_whoText(l, rule))]),
            _Section(
              title: l.reminder,
              children: [_ReminderBlock(task: task)],
            ),
            _Section(
              title: l.myNotes,
              children: [
                TextField(
                  controller: _notes,
                  minLines: 2,
                  maxLines: 6,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    hintText: l.notesHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await controller.setNote(rule.id, _notes.text);
                      messenger.showSnackBar(
                        SnackBar(content: Text(l.noteSaved)),
                      );
                    },
                    child: Text(l.save),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (task.updatedSinceCompletion)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton.icon(
                  onPressed: () => controller.reconfirm(rule.id),
                  icon: const Icon(Icons.fact_check_outlined),
                  label: Text(l.reconfirm),
                ),
              ),
            FilledButton.icon(
              onPressed: () =>
                  controller.setCompleted(rule.id, !task.isCompleted),
              icon: Icon(task.isCompleted ? Icons.undo : Icons.check),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  task.isCompleted ? l.markIncomplete : l.markComplete,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _copyReport(context, task),
              icon: const Icon(Icons.flag_outlined),
              label: Text(l.reportProblem),
            ),
          ],
        ),
      ),
    );
  }

  String _whoText(AppLocalizations l, RuleDefinition rule) {
    final fields = rule.appliesTo.referencedFields.toSet();
    if (fields.isEmpty) return l.whoAlways;
    final labels = <String>{
      for (final f in fields)
        switch (f) {
          'entry_type' => l.answerEntry,
          'study_stage' => l.answerStage,
          'city' => l.answerCity,
          'age_30_plus' => l.answerAge,
          'plans_to_work' => l.answerWork,
          'family_joining' => l.answerFamily,
          _ => l.answerDates,
        },
    };
    return l.whoBased(labels.join(', '));
  }

  Future<void> _copyReport(BuildContext context, TaskInstance task) async {
    final l = AppLocalizations.of(context);
    final controller = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    // Deliberately contains no profile data.
    final report = [
      'Erstmal – information report',
      'Dataset: ${controller.dataset.datasetId} ${controller.dataset.version}',
      'Task: ${task.rule.id} (v${task.rule.version})',
      for (final s in task.sources) 'Source: ${s.url}',
      'What is wrong or outdated:',
      '',
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: report));
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.reportCopied),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  static IconData _kindIcon(RuleKind kind) => switch (kind) {
    RuleKind.officialRequirement => Icons.gavel_outlined,
    RuleKind.officialProcess => Icons.account_balance_outlined,
    RuleKind.practical => Icons.lightbulb_outline,
    RuleKind.information => Icons.info_outline,
  };

  static String _kindLabel(AppLocalizations l, RuleKind kind) => switch (kind) {
    RuleKind.officialRequirement => l.kindOfficial,
    RuleKind.officialProcess => l.kindProcess,
    RuleKind.practical => l.kindPractical,
    RuleKind.information => l.kindInformation,
  };
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    ),
  );
}

class _WhenBlock extends StatelessWidget {
  const _WhenBlock({required this.task});
  final TaskInstance task;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    final theme = Theme.of(context);
    final timing = task.rule.timing;
    final basis = switch (timing.basis) {
      TimingBasis.legal => l.basisLegal,
      TimingBasis.officialGuidance => l.basisGuidance,
      TimingBasis.appSuggestion => l.basisSuggestion,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timingText(context, task, controller.today),
          style: theme.textTheme.titleSmall?.copyWith(
            color: task.urgency == Urgency.overdue
                ? theme.colorScheme.error
                : null,
          ),
        ),
        if (task.dueDate != null) ...[
          const SizedBox(height: 4),
          Text(basis, style: theme.textTheme.bodySmall),
        ],
        if (task.suggestedStart != null && !task.isCompleted) ...[
          const SizedBox(height: 4),
          Text(
            l.suggestedStartNote(formatDate(context, task.suggestedStart!)),
            style: theme.textTheme.bodySmall,
          ),
        ],
        if (timing.type == TimingType.asap && task.dueDate == null)
          Text(l.timingAsap, style: theme.textTheme.bodySmall),
        if (task.missingAnchor != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OnboardingScreen(initial: controller.profile),
                ),
              ),
              icon: const Icon(Icons.edit_calendar_outlined),
              label: Text(l.editDates),
            ),
          ),
      ],
    );
  }
}

class _DependencyTile extends StatelessWidget {
  const _DependencyTile({
    required this.rule,
    required this.lang,
    required this.hard,
  });
  final RuleDefinition rule;
  final String lang;
  final bool hard;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ExcludeSemantics(
        child: Icon(hard ? Icons.lock_clock : Icons.low_priority),
      ),
      title: Text(rule.localized(lang).title),
      subtitle: Text(hard ? l.dependencies : l.recommendedAfter),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TaskDetailScreen(ruleId: rule.id)),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.ruleId, required this.source});
  final String ruleId;
  final Source source;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = AppScope.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(source.title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(source.authority, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              source.isGovernment ? l.governmentLabel : l.publicBodyLabel,
              style: theme.textTheme.bodySmall,
            ),
            Text(
              l.lastChecked(formatDate(context, source.lastVerifiedAt)),
              style: theme.textTheme.bodySmall,
            ),
            if (source.verificationMethod != VerificationMethod.directFetch)
              Text(l.pendingReview, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final result = await controller.openSource(ruleId, source);
                    if (result != LinkOpenResult.opened) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l.openFailed),
                          duration: const Duration(seconds: 8),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l.openSource),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: source.url));
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.linkCopied)),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: Text(l.copyLink),
                ),
              ],
            ),
            Text(l.needsInternet, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ReminderBlock extends StatelessWidget {
  const _ReminderBlock({required this.task});
  final TaskInstance task;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    final reminder = task.reminder;
    if (task.isCompleted) return const SizedBox.shrink();
    if (reminder != null) {
      return Row(
        children: [
          const ExcludeSemantics(
            child: Icon(Icons.notifications_active_outlined),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(l.reminderOn(formatDate(context, reminder.date))),
          ),
          TextButton(
            onPressed: () => controller.clearReminder(task.id),
            child: Text(l.removeReminder),
          ),
        ],
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () => _chooseReminder(context),
        icon: const Icon(Icons.notification_add_outlined),
        label: Text(l.setReminder),
      ),
    );
  }

  Future<void> _chooseReminder(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final controller = AppScope.read(context);
    final today = controller.today;
    final due = task.dueDate;
    final options = <String, LocalDate>{
      if (due != null && today.daysUntil(due) > 7)
        l.remindWeekBefore: due.addDays(-7),
      if (due != null && today.daysUntil(due) > 1)
        l.remindDayBefore: due.addDays(-1),
      l.remindTomorrow: today.addDays(1),
    };
    final choice = await showModalBottomSheet<Object>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in options.entries)
              ListTile(
                title: Text(e.key),
                subtitle: Text(formatDate(context, e.value)),
                onTap: () => Navigator.pop(sheetContext, e.value),
              ),
            ListTile(
              title: Text(l.remindPick),
              leading: const Icon(Icons.calendar_today),
              onTap: () => Navigator.pop(sheetContext, 'pick'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || choice == null) return;
    LocalDate? date = choice is LocalDate ? choice : null;
    if (choice == 'pick') {
      final picked = await showDatePicker(
        context: context,
        initialDate: today.addDays(1).atTime(12),
        firstDate: today.addDays(1).atTime(0),
        lastDate: today.addDays(3 * 365).atTime(0),
      );
      if (picked != null) date = LocalDate.fromDateTime(picked);
    }
    if (date == null || !context.mounted) return;
    final content = controller.state.settings.showTaskNamesInNotifications
        ? ReminderContent(title: l.appTitle, body: task.content.title)
        : ReminderContent(
            title: l.reminderGenericTitle,
            body: l.reminderGenericBody,
          );
    final messenger = ScaffoldMessenger.of(context);
    final ok = await controller.setReminder(task.id, date, content);
    messenger.showSnackBar(
      SnackBar(
        content: Text(ok ? l.reminderSaved : l.reminderPermissionDenied),
      ),
    );
  }
}
