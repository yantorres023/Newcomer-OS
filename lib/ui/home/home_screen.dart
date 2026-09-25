import 'package:flutter/material.dart';

import '../../data/local_store.dart';
import '../../domain/profile.dart';
import '../../domain/roadmap_resolver.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/app_scope.dart';
import '../format.dart';
import '../settings/settings_screen.dart';
import '../sources/sources_screen.dart';
import 'task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _recoveryNoticeDismissed = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    final roadmap = controller.roadmap(contentLanguage(context))!;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.appTitle),
          actions: [
            IconButton(
              tooltip: l.sourcesTitle,
              icon: const Icon(Icons.menu_book_outlined),
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SourcesScreen())),
            ),
            IconButton(
              tooltip: l.settings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l.tabToday),
              Tab(text: l.tabUpcoming),
              Tab(text: l.tabDone),
            ],
          ),
        ),
        body: Column(
          children: [
            if (controller.saveFailed)
              _Banner(icon: Icons.save_outlined, text: l.saveFailed),
            if (controller.loadOutcome == LoadOutcome.recoveredFromCorruption &&
                !_recoveryNoticeDismissed)
              _Banner(
                icon: Icons.restore,
                text: l.recoveredNotice,
                onDismiss: () =>
                    setState(() => _recoveryNoticeDismissed = true),
              ),
            _ProgressHeader(roadmap: roadmap),
            Expanded(
              child: TabBarView(
                children: [
                  _TaskList(
                    tasks: roadmap.bucket(TaskBucket.today),
                    empty: l.emptyToday,
                    header: controller.profile?.entryType == EntryType.euEeaCh
                        ? _Banner(icon: Icons.info_outline, text: l.euNotice)
                        : null,
                  ),
                  _TaskList(
                    tasks: roadmap.bucket(TaskBucket.upcoming),
                    empty: l.emptyUpcoming,
                    trailingTitle: l.whenItHappens,
                    trailing: roadmap.bucket(TaskBucket.whenItHappens),
                  ),
                  _TaskList(
                    tasks: roadmap.bucket(TaskBucket.done),
                    empty: l.emptyDone,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.roadmap});
  final Roadmap roadmap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final total = roadmap.totalCount;
    final done = roadmap.completedCount;
    final next = roadmap.nextDeadline;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.progress(done, total), style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          Semantics(
            label: l.progress(done, total),
            child: ExcludeSemantics(
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 6),
            Text(
              '${l.nextDeadline(formatDate(context, next.dueDate!))} · '
              '${next.content.title}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.empty,
    this.header,
    this.trailingTitle,
    this.trailing = const [],
  });

  final List<TaskInstance> tasks;
  final String empty;
  final Widget? header;
  final String? trailingTitle;
  final List<TaskInstance> trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        ?header,
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              empty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        for (final task in tasks)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TaskCard(task: task),
          ),
        if (trailing.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
            child: Semantics(
              header: true,
              child: Text(trailingTitle!, style: theme.textTheme.titleMedium),
            ),
          ),
          for (final task in trailing)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TaskCard(task: task),
            ),
        ],
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.text, this.onDismiss});
  final IconData icon;
  final String text;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(icon, color: scheme.onSecondaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: scheme.onSecondaryContainer),
            ),
          ),
          if (onDismiss != null)
            TextButton(onPressed: onDismiss, child: Text(l.dismiss)),
        ],
      ),
    );
  }
}
