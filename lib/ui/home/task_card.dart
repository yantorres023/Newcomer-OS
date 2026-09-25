import 'package:flutter/material.dart';

import '../../domain/dataset.dart';
import '../../domain/roadmap_resolver.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/app_scope.dart';
import '../task/task_detail_screen.dart';
import '../widgets/task_status.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final TaskInstance task;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    final theme = Theme.of(context);
    final status = timingText(context, task, controller.today);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TaskDetailScreen(ruleId: task.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: task.isCompleted,
                semanticLabel: task.isCompleted
                    ? l.markIncomplete
                    : l.markComplete,
                onChanged: (v) => controller.setCompleted(task.id, v ?? false),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      task.content.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: task.urgency == Urgency.overdue
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: task.urgency == Urgency.normal
                            ? null
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (task.urgency == Urgency.overdue)
                          StatusChip(
                            icon: Icons.warning_amber,
                            label: l.overdueLabel,
                            tone: ChipTone.danger,
                          ),
                        if (task.blockedBy.isNotEmpty)
                          StatusChip(
                            icon: Icons.lock_clock,
                            label: l.firstDo(
                              task.blockedBy.first
                                  .localized(task.contentLanguage)
                                  .title,
                            ),
                          ),
                        if (task.rule.kind == RuleKind.practical)
                          StatusChip(
                            icon: Icons.lightbulb_outline,
                            label: l.kindPractical,
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
                        if (task.reminder != null)
                          StatusChip(
                            icon: Icons.notifications_active_outlined,
                            label: l.reminder,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
