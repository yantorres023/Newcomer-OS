// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Erstmal';

  @override
  String get welcomeTitle =>
      'Ihre ersten 90 Tage in Deutschland, Schritt für Schritt';

  @override
  String get welcomeBody =>
      'Für internationale Studierende: eine persönliche Checkliste, was nach der Ankunft zu tun ist, in welcher Reihenfolge und bis wann – mit der offiziellen Quelle für jeden Schritt.';

  @override
  String get welcomeNotGovernment =>
      'Erstmal ist eine unabhängige App. Sie ist kein behördlicher Dienst und mit keiner Behörde oder Hochschule verbunden.';

  @override
  String get welcomePrivacy =>
      'Kein Konto. Ihre Antworten bleiben auf diesem Telefon.';

  @override
  String get disclaimerTitle => 'Bevor Sie beginnen';

  @override
  String get disclaimerBody =>
      'Erstmal ordnet und erklärt öffentliche Informationen, damit Sie planen können. Es ist keine Rechtsberatung und entscheidet nicht, was für Sie gilt. Regeln und Verfahren können sich ändern: Prüfen Sie vor wichtigen Schritten immer die verlinkte offizielle Quelle. Wenn Ihre Situation ungewöhnlich ist oder etwas schiefgelaufen ist (z. B. ein abgelehnter Antrag oder ein abgelaufenes Visum), wenden Sie sich an die Behörde oder eine qualifizierte Beratung.';

  @override
  String get acceptAndStart => 'Verstanden – starten';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageSystem => 'Gerätesprache';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get next => 'Weiter';

  @override
  String get back => 'Zurück';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get whyWeAsk => 'Warum wir fragen';

  @override
  String stepOf(int current, int total) {
    return 'Frage $current von $total';
  }

  @override
  String get qEntryTitle => 'Wie sind Sie nach Deutschland eingereist?';

  @override
  String get qEntryWhy =>
      'Davon hängt ab, welche Schritte zum Aufenthaltstitel Sie sehen.';

  @override
  String get entryNationalVisa =>
      'Mit einem nationalen Visum zum Studium („D“-Visum)';

  @override
  String get entryVisaFree =>
      'Ohne Visum (z. B. Staatsangehörige der USA, Kanadas, Japans)';

  @override
  String get entryEu => 'Ich bin EU-, EWR- oder Schweizer Staatsangehörige/r';

  @override
  String get entryHelp =>
      'Unsicher? Sehen Sie auf das Visum in Ihrem Pass. Ein nationales Visum zeigt den Buchstaben „D“.';

  @override
  String get qStageTitle => 'Was beginnen Sie?';

  @override
  String get qStageWhy =>
      'Manche Städte haben unterschiedliche offizielle Seiten für Studium und Studienvorbereitung.';

  @override
  String get stageDegree => 'Ein Studium (Bachelor, Master, Promotion)';

  @override
  String get stagePrep =>
      'Eine Studienvorbereitung (Studienkolleg oder Kurs vor dem Studium)';

  @override
  String get qCityTitle => 'Wo werden Sie wohnen?';

  @override
  String get qCityWhy =>
      'Behörden und Verfahren sind lokal. Wir verlinken die offiziellen Seiten Ihrer Stadt.';

  @override
  String get cityBerlin => 'Berlin';

  @override
  String get cityMunich => 'München';

  @override
  String get cityOther => 'Eine andere Stadt oder Gemeinde';

  @override
  String get cityOtherHelp =>
      'Sie erhalten die bundesweiten Regeln und offizielle Werkzeuge, um Ihre örtlichen Behörden zu finden.';

  @override
  String get qArrivalTitle =>
      'Wann sind (oder werden) Sie in Deutschland angekommen?';

  @override
  String get qArrivalWhy => 'Manche Fristen zählen ab der Einreise.';

  @override
  String get qMoveInTitle =>
      'Wann sind (oder werden) Sie in Ihre dauerhafte Wohnung eingezogen?';

  @override
  String get qMoveInWhy =>
      'Mit dem Einzug beginnt die Zwei-Wochen-Frist für die Anmeldung.';

  @override
  String get moveInUnknown => 'Ich habe noch keine dauerhafte Wohnung';

  @override
  String get qVisaTitle => 'Wann läuft Ihr Visum ab?';

  @override
  String get qVisaWhy =>
      'Vor diesem Datum müssen Sie Ihre Aufenthaltserlaubnis beantragen.';

  @override
  String get visaHelp => 'Es steht auf dem Visum in Ihrem Pass (Feld „bis“).';

  @override
  String get visaUnknown => 'Ich trage es später ein';

  @override
  String get qMoreTitle => 'Noch ein paar Fragen';

  @override
  String get qMoreWhy =>
      'Jede Antwort fügt bestimmte Aufgaben hinzu oder entfernt sie. Wir fragen nicht nach Name, Staatsangehörigkeit oder Dokumenten.';

  @override
  String get age30Plus => 'Ich bin 30 Jahre oder älter';

  @override
  String get age30PlusHelp =>
      'Die Krankenversicherungsregeln für Studierende ändern sich ab 30.';

  @override
  String get plansToWork => 'Ich möchte neben dem Studium arbeiten';

  @override
  String get familyJoining => 'Ehepartner oder Kinder kommen mit';

  @override
  String get pickDate => 'Datum wählen';

  @override
  String get changeDate => 'Datum ändern';

  @override
  String get summaryTitle => 'Ihre Checkliste ist fertig';

  @override
  String summaryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben für Ihre Situation ausgewählt.',
      one: '1 Aufgabe für Ihre Situation ausgewählt.',
    );
    return '$_temp0';
  }

  @override
  String get seeChecklist => 'Zur Checkliste';

  @override
  String get saveAnswers => 'Antworten speichern';

  @override
  String get tabToday => 'Heute';

  @override
  String get tabUpcoming => 'Demnächst';

  @override
  String get tabDone => 'Erledigt';

  @override
  String progress(int done, int total) {
    return '$done von $total erledigt';
  }

  @override
  String nextDeadline(String date) {
    return 'Nächste Frist: $date';
  }

  @override
  String get emptyToday =>
      'Gerade nichts Dringendes. Unter „Demnächst“ sehen Sie, was als Nächstes kommt.';

  @override
  String get emptyUpcoming => 'Später ist nichts geplant.';

  @override
  String get emptyDone => 'Erledigte Aufgaben erscheinen hier.';

  @override
  String get whenItHappens => 'Wenn es so weit ist';

  @override
  String get settings => 'Einstellungen';

  @override
  String dueOn(String date) {
    return 'Fällig am $date';
  }

  @override
  String get dueToday => 'Heute fällig';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Fällig in $days Tagen',
      one: 'Morgen fällig',
    );
    return '$_temp0';
  }

  @override
  String overdueSince(String date) {
    return 'Überfällig seit $date';
  }

  @override
  String followUpOn(String date) {
    return 'Nachfragen am $date';
  }

  @override
  String suggestedBy(String date) {
    return 'Empfohlen bis $date';
  }

  @override
  String startFrom(String date) {
    return 'Beginnen ab $date';
  }

  @override
  String get asSoonAsPossible => 'So bald wie möglich';

  @override
  String addDateForDeadline(String field) {
    return 'Tragen Sie $field ein, um die Frist zu sehen';
  }

  @override
  String get fieldMoveIn => 'Ihr Einzugsdatum';

  @override
  String get fieldVisaExpiry => 'das Ablaufdatum Ihres Visums';

  @override
  String get fieldPermitExpiry => 'das Ablaufdatum Ihrer Aufenthaltskarte';

  @override
  String get fieldArrival => 'Ihr Ankunftsdatum';

  @override
  String firstDo(String title) {
    return 'Zuerst: $title';
  }

  @override
  String get noLongerApplies => 'Gilt nach Ihren Antworten nicht mehr';

  @override
  String get updatedSinceCompletion =>
      'Informationen seit Erledigung aktualisiert';

  @override
  String get overdueLabel => 'Überfällig';

  @override
  String completedOn(String date) {
    return 'Erledigt am $date';
  }

  @override
  String get sectionWhy => 'Warum das wichtig ist';

  @override
  String get sectionWho => 'Warum Sie das sehen';

  @override
  String get whoAlways =>
      'Das gilt für alle, die in dieser Situation nach Deutschland ziehen.';

  @override
  String whoBased(String fields) {
    return 'Ausgewählt anhand Ihrer Antworten zu: $fields.';
  }

  @override
  String get answerEntry => 'Einreise';

  @override
  String get answerStage => 'Studium';

  @override
  String get answerCity => 'Stadt';

  @override
  String get answerAge => 'Alter';

  @override
  String get answerWork => 'Arbeitspläne';

  @override
  String get answerFamily => 'Familie';

  @override
  String get answerDates => 'Ihre Daten';

  @override
  String get sectionWhen => 'Wann';

  @override
  String get basisLegal => 'Gesetzliche Frist (aus Gesetz oder Behörde)';

  @override
  String get basisGuidance =>
      'Nachfragedatum nach offizieller Auskunft – keine Frist für Sie';

  @override
  String get basisSuggestion => 'Unsere Empfehlung – keine gesetzliche Frist';

  @override
  String suggestedStartNote(String date) {
    return 'Wir empfehlen, bis $date zu beginnen, da Termine Wochen dauern können.';
  }

  @override
  String get timingNone => 'Kein festes Datum.';

  @override
  String get timingAsap =>
      'Kein festes gesetzliches Datum – so bald wie möglich erledigen.';

  @override
  String get timingEvent => 'Nur relevant, wenn es so weit ist.';

  @override
  String get editDates => 'Meine Daten bearbeiten';

  @override
  String get sectionDocs => 'Was Sie brauchen';

  @override
  String get docOfficial => 'Von einer offiziellen Quelle genannt';

  @override
  String get docCommon => 'Häufig verlangt – offizielle Liste prüfen';

  @override
  String get sectionSteps => 'Schritte';

  @override
  String get sectionSources => 'Offizielle Quelle';

  @override
  String lastChecked(String date) {
    return 'Zuletzt von uns geprüft: $date';
  }

  @override
  String get pendingReview => 'Redaktionelle Nachprüfung ausstehend';

  @override
  String get openSource => 'Offizielle Seite öffnen';

  @override
  String get copyLink => 'Link kopieren';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String get openFailed =>
      'Die Seite konnte nicht geöffnet werden. Kopieren Sie den Link und öffnen Sie ihn im Browser. Wenn die Seite umgezogen ist, suchen Sie auf der Website der Behörde nach dem Titel.';

  @override
  String get needsInternet => 'Öffnet im Browser – Internet nötig.';

  @override
  String get publicBodyLabel =>
      'Öffentlich finanzierte Organisation (keine Behörde)';

  @override
  String get governmentLabel => 'Behörde / amtliche Stelle';

  @override
  String get explanationLabel =>
      'Unsere Erklärung in einfacher Sprache. Bei Abweichungen gilt die offizielle Quelle.';

  @override
  String get officialTerms => 'Begriffe, die Sie sehen werden';

  @override
  String get sectionNotes => 'Gut zu wissen';

  @override
  String get myNotes => 'Meine Notizen';

  @override
  String get notesHint =>
      'Private Notiz – bleibt auf diesem Telefon. Keine Pass- oder Ausweisnummern speichern.';

  @override
  String get noteSaved => 'Notiz gespeichert';

  @override
  String get markComplete => 'Als erledigt markieren';

  @override
  String get markIncomplete => 'Als nicht erledigt markieren';

  @override
  String get reconfirm => 'Aktualisierung geprüft';

  @override
  String get reminder => 'Erinnerung';

  @override
  String get setReminder => 'Erinnerung setzen';

  @override
  String reminderOn(String date) {
    return 'Erinnerung am $date';
  }

  @override
  String get removeReminder => 'Erinnerung entfernen';

  @override
  String get remindWeekBefore => '1 Woche vor dem Datum';

  @override
  String get remindDayBefore => '1 Tag vor dem Datum';

  @override
  String get remindTomorrow => 'Morgen';

  @override
  String get remindPick => 'Datum wählen';

  @override
  String get reminderPermissionDenied =>
      'Benachrichtigungen für Erstmal sind aus. Sie können sie in den Telefoneinstellungen erlauben.';

  @override
  String get reminderSaved => 'Erinnerung gesetzt';

  @override
  String get professionalHelp => 'Wann individuelle Hilfe sinnvoll ist';

  @override
  String get dependencies => 'Zuerst erledigen';

  @override
  String get recommendedAfter => 'Meist einfacher nach';

  @override
  String get fallbackLanguage =>
      'Noch nicht in Ihrer Sprache verfügbar – Anzeige auf Englisch.';

  @override
  String get kindPractical => 'Praktischer Tipp – keine gesetzliche Pflicht';

  @override
  String get kindInformation => 'Gut zu wissen';

  @override
  String get kindOfficial => 'Amtliche Pflicht';

  @override
  String get kindProcess => 'Amtliches Verfahren';

  @override
  String get reportProblem => 'Veraltete oder falsche Angaben melden';

  @override
  String get reportCopied =>
      'Eine Meldung wurde in die Zwischenablage kopiert. Fügen Sie sie in eine E-Mail oder Nachricht an das Erstmal-Team ein. Sie enthält nur Aufgabe und Quelle, keine persönlichen Daten.';

  @override
  String get yourSituation => 'Ihre Situation';

  @override
  String get editAnswers => 'Antworten bearbeiten';

  @override
  String get permitExpiryLabel => 'Aufenthaltskarte gültig bis';

  @override
  String get notSet => 'Nicht eingetragen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get showTaskNames => 'Aufgabennamen in Erinnerungen anzeigen';

  @override
  String get showTaskNamesHelp =>
      'Aus: Erinnerungen sagen nur, dass eine Aufgabe ansteht – wer Ihren Sperrbildschirm sieht, erfährt nichts über Ihre Situation.';

  @override
  String get about => 'Über';

  @override
  String dataVersion(String version, String date) {
    return 'Checklisten-Daten $version, veröffentlicht am $date';
  }

  @override
  String get sourcesTitle => 'Alle offiziellen Quellen';

  @override
  String get sourcesIntro =>
      'Jede Aufgabe verlinkt, woher die Regel stammt. Wir haben jede Seite am angegebenen Datum geprüft. Seiten können sich danach ändern.';

  @override
  String get disclaimer => 'Hinweis';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacySummary =>
      'Ihre Antworten, Fortschritte, Notizen und Erinnerungen werden nur auf diesem Telefon gespeichert. Es gibt kein Konto, keinen Server und kein Tracking. Beim Löschen der App oder über „Alle meine Daten löschen“ wird alles entfernt.';

  @override
  String get exportData => 'Meine Daten kopieren';

  @override
  String get exportCopied =>
      'Ihre Daten wurden in die Zwischenablage kopiert (JSON). Achten Sie darauf, wo Sie sie einfügen.';

  @override
  String get deleteData => 'Alle meine Daten löschen';

  @override
  String get deleteConfirmTitle => 'Alles löschen?';

  @override
  String get deleteConfirmBody =>
      'Ihre Antworten, Fortschritte, Notizen und Erinnerungen werden von diesem Telefon entfernt. Das kann nicht rückgängig gemacht werden.';

  @override
  String get datasetErrorTitle => 'Die Checkliste konnte nicht geladen werden';

  @override
  String get datasetErrorBody =>
      'Die integrierten Checklisten-Daten haben die Sicherheitsprüfung nicht bestanden. Daher zeigen wir keine möglicherweise falschen Informationen. Bitte aktualisieren Sie die App. Nutzen Sie bis dahin die offiziellen Websites Ihrer Stadt und das International Office Ihrer Hochschule.';

  @override
  String get saveFailed =>
      'Ihre letzte Änderung konnte nicht gespeichert werden. Prüfen Sie den freien Speicher und versuchen Sie es erneut.';

  @override
  String get recoveredNotice =>
      'Ihre gespeicherten Daten waren nicht lesbar; wir haben neu begonnen. Eine Kopie der alten Datei wurde auf dem Telefon behalten.';

  @override
  String get euNotice =>
      'Als EU-, EWR- oder Schweizer Staatsangehörige/r brauchen Sie keine Aufenthaltserlaubnis zum Studium. Ihre Checkliste enthält die Anmeldung und weitere Alltagsschritte.';

  @override
  String get reminderGenericTitle => 'Erstmal';

  @override
  String get reminderGenericBody =>
      'Eine Aufgabe auf Ihrer Checkliste steht an.';

  @override
  String get openTask => 'Aufgabe öffnen';

  @override
  String get dismiss => 'OK';
}
