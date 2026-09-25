import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/gen/app_localizations.dart';
import 'state/app_controller.dart';
import 'state/app_scope.dart';
import 'ui/format.dart';
import 'ui/home/home_screen.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'ui/theme.dart';
import 'ui/welcome_screen.dart';

class ErstmalApp extends StatelessWidget {
  const ErstmalApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          locale: localeFor(controller.state.settings.language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const _Root(),
        ),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    return switch (controller.status) {
      AppStatus.loading => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AppStatus.datasetError => const _DatasetErrorScreen(),
      AppStatus.ready when controller.needsDisclaimer => const WelcomeScreen(),
      AppStatus.ready when controller.needsOnboarding =>
        const OnboardingScreen(),
      AppStatus.ready => const HomeScreen(),
    };
  }
}

class _DatasetErrorScreen extends StatelessWidget {
  const _DatasetErrorScreen();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l.datasetErrorTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(l.datasetErrorBody),
          ],
        ),
      ),
    );
  }
}
