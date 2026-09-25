import 'package:flutter/material.dart';

import '../../domain/user_state.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/app_scope.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final controller = AppScope.of(context);
    return SegmentedButton<LanguagePreference>(
      segments: [
        ButtonSegment(
          value: LanguagePreference.system,
          label: Text(l.languageSystem),
        ),
        ButtonSegment(
          value: LanguagePreference.en,
          label: Text(l.languageEnglish),
        ),
        ButtonSegment(
          value: LanguagePreference.de,
          label: Text(l.languageGerman),
        ),
      ],
      selected: {controller.state.settings.language},
      showSelectedIcon: false,
      onSelectionChanged: (s) => controller.setLanguage(s.first),
    );
  }
}
