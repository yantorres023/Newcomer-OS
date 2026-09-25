import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../state/app_scope.dart';
import 'widgets/language_selector.dart';

/// First screen: what the app is (and is not), language, disclaimer.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: [
            Semantics(
              header: true,
              child: Text(
                l.appTitle,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(l.welcomeTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(l.welcomeBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.info_outline, text: l.welcomeNotGovernment),
            _InfoRow(icon: Icons.lock_outline, text: l.welcomePrivacy),
            const SizedBox(height: 16),
            Text(l.languageLabel, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            const LanguageSelector(),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l.disclaimerTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(l.disclaimerBody),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                final controller = AppScope.read(context);
                controller.trackOnboardingStarted();
                controller.acceptDisclaimer();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l.acceptAndStart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Icon(icon, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
