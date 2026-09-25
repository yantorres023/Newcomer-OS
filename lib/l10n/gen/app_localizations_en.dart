// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Erstmal';

  @override
  String get welcomeTitle => 'Your first 90 days in Germany, step by step';

  @override
  String get welcomeBody =>
      'For international students: a personal checklist of what to do after arriving, in which order, by when — with the official source for every step.';

  @override
  String get welcomeNotGovernment =>
      'Erstmal is an independent app. It is not a government service and is not affiliated with any authority or university.';

  @override
  String get welcomePrivacy => 'No account. Your answers stay on this phone.';

  @override
  String get disclaimerTitle => 'Before you start';

  @override
  String get disclaimerBody =>
      'Erstmal organises and explains public information to help you plan. It is not legal advice and does not decide what applies to you. Rules and procedures can change: always check the linked official source before acting on anything important. If your situation is unusual or something has gone wrong (for example a refused application or an expired visa), contact the authority or a qualified advisor.';

  @override
  String get acceptAndStart => 'I understand — start';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get whyWeAsk => 'Why we ask';

  @override
  String stepOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get qEntryTitle => 'How did you enter Germany?';

  @override
  String get qEntryWhy => 'This decides which residence-permit steps you see.';

  @override
  String get entryNationalVisa =>
      'With a national visa for studies (\"D\" visa)';

  @override
  String get entryVisaFree =>
      'Without a visa (e.g. citizens of the USA, Canada, Japan)';

  @override
  String get entryEu => 'I am an EU, EEA or Swiss citizen';

  @override
  String get entryHelp =>
      'Not sure? Look at the visa sticker in your passport. A national visa shows the letter \"D\".';

  @override
  String get qStageTitle => 'What are you starting?';

  @override
  String get qStageWhy =>
      'Some cities have different official pages for degree studies and preparatory courses.';

  @override
  String get stageDegree => 'A degree programme (Bachelor, Master, PhD)';

  @override
  String get stagePrep =>
      'A preparatory course (Studienkolleg or a course before studies)';

  @override
  String get qCityTitle => 'Where will you live?';

  @override
  String get qCityWhy =>
      'Offices and procedures are local. We link the official pages for your city.';

  @override
  String get cityBerlin => 'Berlin';

  @override
  String get cityMunich => 'Munich';

  @override
  String get cityOther => 'Another city or town';

  @override
  String get cityOtherHelp =>
      'You will get the federal rules plus official tools to find your local offices.';

  @override
  String get qArrivalTitle => 'When did (or will) you arrive in Germany?';

  @override
  String get qArrivalWhy => 'Some time limits count from your arrival.';

  @override
  String get qMoveInTitle =>
      'When did (or will) you move into your long-term home?';

  @override
  String get qMoveInWhy =>
      'Moving in starts the two-week deadline to register your address.';

  @override
  String get moveInUnknown => 'I don\'t have a long-term home yet';

  @override
  String get qVisaTitle => 'When does your visa end?';

  @override
  String get qVisaWhy =>
      'You must apply for your residence permit before this date.';

  @override
  String get visaHelp =>
      'It is printed on the visa in your passport (field \"until\" / \"bis\").';

  @override
  String get visaUnknown => 'I\'ll add it later';

  @override
  String get qMoreTitle => 'A few more questions';

  @override
  String get qMoreWhy =>
      'Each answer adds or removes specific tasks. We don\'t ask for your name, nationality or documents.';

  @override
  String get age30Plus => 'I am 30 or older';

  @override
  String get age30PlusHelp =>
      'Health insurance rules for students change at 30.';

  @override
  String get plansToWork => 'I plan to work while studying';

  @override
  String get familyJoining => 'My spouse or children are coming with me';

  @override
  String get pickDate => 'Choose date';

  @override
  String get changeDate => 'Change date';

  @override
  String get summaryTitle => 'Your checklist is ready';

  @override
  String summaryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks selected for your situation.',
      one: '1 task selected for your situation.',
    );
    return '$_temp0';
  }

  @override
  String get seeChecklist => 'See my checklist';

  @override
  String get saveAnswers => 'Save answers';

  @override
  String get tabToday => 'Today';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabDone => 'Done';

  @override
  String progress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String nextDeadline(String date) {
    return 'Next deadline: $date';
  }

  @override
  String get emptyToday =>
      'Nothing urgent right now. Look at Upcoming to see what comes next.';

  @override
  String get emptyUpcoming => 'Nothing scheduled later.';

  @override
  String get emptyDone => 'Tasks you mark as done appear here.';

  @override
  String get whenItHappens => 'When it happens';

  @override
  String get settings => 'Settings';

  @override
  String dueOn(String date) {
    return 'Due $date';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Due in $days days',
      one: 'Due tomorrow',
    );
    return '$_temp0';
  }

  @override
  String overdueSince(String date) {
    return 'Overdue since $date';
  }

  @override
  String followUpOn(String date) {
    return 'Follow up on $date';
  }

  @override
  String suggestedBy(String date) {
    return 'Suggested by $date';
  }

  @override
  String startFrom(String date) {
    return 'Start from $date';
  }

  @override
  String get asSoonAsPossible => 'As soon as possible';

  @override
  String addDateForDeadline(String field) {
    return 'Add your $field to see the deadline';
  }

  @override
  String get fieldMoveIn => 'move-in date';

  @override
  String get fieldVisaExpiry => 'visa end date';

  @override
  String get fieldPermitExpiry => 'residence card expiry date';

  @override
  String get fieldArrival => 'arrival date';

  @override
  String firstDo(String title) {
    return 'First: $title';
  }

  @override
  String get noLongerApplies => 'No longer applies to your answers';

  @override
  String get updatedSinceCompletion =>
      'Information updated since you completed this';

  @override
  String get overdueLabel => 'Overdue';

  @override
  String completedOn(String date) {
    return 'Done on $date';
  }

  @override
  String get sectionWhy => 'Why this matters';

  @override
  String get sectionWho => 'Why you see this';

  @override
  String get whoAlways =>
      'This applies to everyone who moves to Germany in this situation.';

  @override
  String whoBased(String fields) {
    return 'Selected from your answers about: $fields.';
  }

  @override
  String get answerEntry => 'how you entered';

  @override
  String get answerStage => 'what you study';

  @override
  String get answerCity => 'your city';

  @override
  String get answerAge => 'age';

  @override
  String get answerWork => 'work plans';

  @override
  String get answerFamily => 'family';

  @override
  String get answerDates => 'your dates';

  @override
  String get sectionWhen => 'When';

  @override
  String get basisLegal => 'Legal deadline (from the law or the authority)';

  @override
  String get basisGuidance =>
      'Follow-up date based on official guidance — not a deadline for you';

  @override
  String get basisSuggestion => 'Our suggestion — not a legal deadline';

  @override
  String suggestedStartNote(String date) {
    return 'We suggest starting by $date because appointments can take weeks.';
  }

  @override
  String get timingNone => 'No fixed date.';

  @override
  String get timingAsap =>
      'No fixed legal date — do it as soon as you reasonably can.';

  @override
  String get timingEvent => 'Only relevant when this happens.';

  @override
  String get editDates => 'Edit my dates';

  @override
  String get sectionDocs => 'What you need';

  @override
  String get docOfficial => 'Named by an official source';

  @override
  String get docCommon => 'Commonly requested — check the official list';

  @override
  String get sectionSteps => 'Steps';

  @override
  String get sectionSources => 'Official source';

  @override
  String lastChecked(String date) {
    return 'Last checked by us: $date';
  }

  @override
  String get pendingReview => 'Pending editorial re-check';

  @override
  String get openSource => 'Open official page';

  @override
  String get copyLink => 'Copy link';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get openFailed =>
      'Couldn\'t open the page. Copy the link and open it in your browser. If the page has moved, search the authority\'s website for its title.';

  @override
  String get needsInternet => 'Opens in your browser — needs internet.';

  @override
  String get publicBodyLabel =>
      'Publicly funded organisation (not a government authority)';

  @override
  String get governmentLabel => 'Government / official authority';

  @override
  String get explanationLabel =>
      'Our plain-language explanation. If it differs from the official source, the official source is correct.';

  @override
  String get officialTerms => 'Words you will see';

  @override
  String get sectionNotes => 'Good to know';

  @override
  String get myNotes => 'My notes';

  @override
  String get notesHint =>
      'Private note — stays on this phone. Don\'t store passport or ID numbers.';

  @override
  String get noteSaved => 'Note saved';

  @override
  String get markComplete => 'Mark as done';

  @override
  String get markIncomplete => 'Mark as not done';

  @override
  String get reconfirm => 'I\'ve checked the update';

  @override
  String get reminder => 'Reminder';

  @override
  String get setReminder => 'Set a reminder';

  @override
  String reminderOn(String date) {
    return 'Reminder on $date';
  }

  @override
  String get removeReminder => 'Remove reminder';

  @override
  String get remindWeekBefore => '1 week before the date';

  @override
  String get remindDayBefore => '1 day before the date';

  @override
  String get remindTomorrow => 'Tomorrow';

  @override
  String get remindPick => 'Pick a date';

  @override
  String get reminderPermissionDenied =>
      'Notifications are turned off for Erstmal. You can allow them in your phone settings.';

  @override
  String get reminderSaved => 'Reminder set';

  @override
  String get professionalHelp => 'When to get individual help';

  @override
  String get dependencies => 'Do this first';

  @override
  String get recommendedAfter => 'Usually easier after';

  @override
  String get fallbackLanguage =>
      'Not yet available in your language — showing English.';

  @override
  String get kindPractical => 'Practical tip — not a legal requirement';

  @override
  String get kindInformation => 'Good to know';

  @override
  String get kindOfficial => 'Official requirement';

  @override
  String get kindProcess => 'Official process';

  @override
  String get reportProblem => 'Report outdated or wrong information';

  @override
  String get reportCopied =>
      'A report was copied to your clipboard. Paste it into an email or message to the Erstmal team. It contains only the task and source, no personal data.';

  @override
  String get yourSituation => 'Your situation';

  @override
  String get editAnswers => 'Edit answers';

  @override
  String get permitExpiryLabel => 'Residence card expires on';

  @override
  String get notSet => 'Not set';

  @override
  String get notifications => 'Notifications';

  @override
  String get showTaskNames => 'Show task names in reminders';

  @override
  String get showTaskNamesHelp =>
      'Off: reminders only say you have a task coming up, so people who see your lock screen learn nothing about your situation.';

  @override
  String get about => 'About';

  @override
  String dataVersion(String version, String date) {
    return 'Checklist data $version, released $date';
  }

  @override
  String get sourcesTitle => 'All official sources';

  @override
  String get sourcesIntro =>
      'Every task links to where the rule comes from. We checked each page on the date shown. Pages can change after that.';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacySummary =>
      'Your answers, progress, notes and reminders are stored only on this phone. There is no account, no server and no tracking. Deleting the app or using \"Delete all my data\" removes everything.';

  @override
  String get exportData => 'Copy my data';

  @override
  String get exportCopied =>
      'Your data was copied to the clipboard (JSON). Be careful where you paste it.';

  @override
  String get deleteData => 'Delete all my data';

  @override
  String get deleteConfirmTitle => 'Delete everything?';

  @override
  String get deleteConfirmBody =>
      'Your answers, progress, notes and reminders will be removed from this phone. This cannot be undone.';

  @override
  String get datasetErrorTitle => 'The checklist could not be loaded';

  @override
  String get datasetErrorBody =>
      'The built-in checklist data failed its safety checks, so we are not showing possibly wrong information. Please update the app. Until then, use the official websites of your city and your university\'s international office.';

  @override
  String get saveFailed =>
      'Your last change could not be saved on this phone. Check free storage and try again.';

  @override
  String get recoveredNotice =>
      'We could not read your saved data and started fresh. A copy of the old file was kept on this phone.';

  @override
  String get euNotice =>
      'As an EU, EEA or Swiss citizen you do not need a residence permit for studies. Your checklist covers registration and other everyday steps.';

  @override
  String get reminderGenericTitle => 'Erstmal';

  @override
  String get reminderGenericBody => 'You have a checklist task coming up.';

  @override
  String get openTask => 'Open task';

  @override
  String get dismiss => 'OK';
}
