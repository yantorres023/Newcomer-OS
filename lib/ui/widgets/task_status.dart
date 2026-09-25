import 'package:flutter/material.dart';

import '../../domain/dataset.dart';
import '../../domain/local_date.dart';
import '../../domain/roadmap_resolver.dart';
import '../../l10n/gen/app_localizations.dart';
import '../format.dart';

/// One-line, plain-language timing status for a task.
String timingText(BuildContext context, TaskInstance task, LocalDate today) {
  final l = AppLocalizations.of(context);
  if (task.completion != null) {
    return l.completedOn(formatDate(context, task.completion!.completedOn));
  }
  final due = task.dueDate;
  if (due != null) {
    final date = formatDate(context, due);
    if (task.rule.timing.basis == TimingBasis.officialGuidance) {
      return l.followUpOn(date);
    }
    if (due.isBefore(today) && task.rule.timing.basis == TimingBasis.legal) {
      return l.overdueSince(date);
    }
    final days = today.daysUntil(due);
    final prefix = task.rule.timing.basis == TimingBasis.appSuggestion
        ? l.suggestedBy(date)
        : days == 0
        ? l.dueToday
        : days <= 14
        ? l.dueInDays(days)
        : l.dueOn(date);
    return prefix;
  }
  if (task.missingAnchor != null) {
    return l.addDateForDeadline(fieldLabel(l, task.missingAnchor!));
  }
  return switch (task.rule.timing.type) {
    TimingType.asap => l.asSoonAsPossible,
    TimingType.event => l.timingEvent,
    _ => l.timingNone,
  };
}

/// Icon + text label so meaning never depends on colour alone.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.icon,
    required this.label,
    this.tone = ChipTone.neutral,
  });

  final IconData icon;
  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (tone) {
      ChipTone.danger => (scheme.errorContainer, scheme.onErrorContainer),
      ChipTone.attention => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      ChipTone.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(child: Icon(icon, size: 16, color: fg)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

enum ChipTone { neutral, attention, danger }
