import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../domain/local_date.dart';
import '../domain/user_state.dart';
import '../l10n/gen/app_localizations.dart';

/// Language code ("en" or "de") used for dataset content.
String contentLanguage(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  return code == 'de' ? 'de' : 'en';
}

Locale? localeFor(LanguagePreference pref) => switch (pref) {
  LanguagePreference.system => null,
  LanguagePreference.en => const Locale('en'),
  LanguagePreference.de => const Locale('de'),
};

String formatDate(BuildContext context, LocalDate date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).format(date.atTime(12));
}

String fieldLabel(AppLocalizations l, String field) => switch (field) {
  'move_in_date' => l.fieldMoveIn,
  'visa_expiry_date' => l.fieldVisaExpiry,
  'permit_expiry_date' => l.fieldPermitExpiry,
  _ => l.fieldArrival,
};
