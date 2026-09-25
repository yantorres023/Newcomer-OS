import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../../services/link_service.dart';
import '../../state/app_scope.dart';
import '../format.dart';

/// Transparency page: every source the dataset relies on.
class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    final theme = Theme.of(context);
    final sources = controller.dataset.sources.values.toList()
      ..sort((a, b) => a.authority.compareTo(b.authority));
    return Scaffold(
      appBar: AppBar(title: Text(l.sourcesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.sourcesIntro),
          const SizedBox(height: 16),
          for (final source in sources)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(source.title),
              subtitle: Text(
                '${source.authority}\n'
                '${source.isGovernment ? l.governmentLabel : l.publicBodyLabel}\n'
                '${l.lastChecked(formatDate(context, source.lastVerifiedAt))}',
                style: theme.textTheme.bodySmall,
              ),
              isThreeLine: true,
              trailing: IconButton(
                tooltip: l.openSource,
                icon: const Icon(Icons.open_in_new),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await controller.links.open(source.url);
                  if (result != LinkOpenResult.opened) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.openFailed)),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
