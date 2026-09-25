import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/profile.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/app_scope.dart';
import '../format.dart';
import '../onboarding/onboarding_screen.dart';
import '../sources/sources_screen.dart';
import '../widgets/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    final profile = controller.profile;
    final theme = Theme.of(context);

    String entryLabel(EntryType t) => switch (t) {
      EntryType.nationalVisa => l.entryNationalVisa,
      EntryType.visaFree => l.entryVisaFree,
      EntryType.euEeaCh => l.entryEu,
    };
    String cityLabel(City c) => switch (c) {
      City.berlin => l.cityBerlin,
      City.munich => l.cityMunich,
      City.other => l.cityOther,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _Header(l.yourSituation),
          if (profile != null) ...[
            ListTile(title: Text(entryLabel(profile.entryType))),
            ListTile(title: Text(cityLabel(profile.city))),
            ListTile(
              title: Text(l.qArrivalTitle),
              subtitle: Text(formatDate(context, profile.arrivalDate)),
            ),
            ListTile(
              title: Text(l.qMoveInTitle),
              subtitle: Text(
                profile.moveInDate == null
                    ? l.notSet
                    : formatDate(context, profile.moveInDate!),
              ),
            ),
            if (profile.entryType == EntryType.nationalVisa)
              ListTile(
                title: Text(l.qVisaTitle),
                subtitle: Text(
                  profile.visaExpiryDate == null
                      ? l.notSet
                      : formatDate(context, profile.visaExpiryDate!),
                ),
              ),
            if (profile.entryType != EntryType.euEeaCh)
              ListTile(
                title: Text(l.permitExpiryLabel),
                subtitle: Text(
                  profile.permitExpiryDate == null
                      ? l.notSet
                      : formatDate(context, profile.permitExpiryDate!),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OnboardingScreen(initial: profile),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: Text(l.editAnswers),
              ),
            ),
          ],
          _Header(l.languageLabel),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LanguageSelector(),
          ),
          _Header(l.notifications),
          SwitchListTile(
            value: controller.state.settings.showTaskNamesInNotifications,
            onChanged: controller.setShowTaskNamesInNotifications,
            title: Text(l.showTaskNames),
            subtitle: Text(l.showTaskNamesHelp),
          ),
          _Header(l.about),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(l.sourcesTitle),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SourcesScreen())),
          ),
          ExpansionTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.disclaimer),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Text(l.disclaimerBody),
              const SizedBox(height: 8),
              Text(l.welcomeNotGovernment),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.privacy),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [Text(l.privacySummary)],
          ),
          ListTile(
            title: Text(
              l.dataVersion(
                controller.dataset.version,
                formatDate(context, controller.dataset.releasedAt),
              ),
            ),
            textColor: theme.colorScheme.onSurfaceVariant,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.copy_all_outlined),
            title: Text(l.exportData),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              await Clipboard.setData(
                ClipboardData(text: controller.exportData()),
              );
              messenger.showSnackBar(SnackBar(content: Text(l.exportCopied)));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: theme.colorScheme.error,
            ),
            title: Text(
              l.deleteData,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final controller = AppScope.read(context);
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteConfirmTitle),
        content: Text(l.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await controller.deleteAllData();
      navigator.popUntil((route) => route.isFirst);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    ),
  );
}
