import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Erstmal'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first 90 days in Germany, step by step'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'For international students: a personal checklist of what to do after arriving, in which order, by when — with the official source for every step.'**
  String get welcomeBody;

  /// No description provided for @welcomeNotGovernment.
  ///
  /// In en, this message translates to:
  /// **'Erstmal is an independent app. It is not a government service and is not affiliated with any authority or university.'**
  String get welcomeNotGovernment;

  /// No description provided for @welcomePrivacy.
  ///
  /// In en, this message translates to:
  /// **'No account. Your answers stay on this phone.'**
  String get welcomePrivacy;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Erstmal organises and explains public information to help you plan. It is not legal advice and does not decide what applies to you. Rules and procedures can change: always check the linked official source before acting on anything important. If your situation is unusual or something has gone wrong (for example a refused application or an expired visa), contact the authority or a qualified advisor.'**
  String get disclaimerBody;

  /// No description provided for @acceptAndStart.
  ///
  /// In en, this message translates to:
  /// **'I understand — start'**
  String get acceptAndStart;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @whyWeAsk.
  ///
  /// In en, this message translates to:
  /// **'Why we ask'**
  String get whyWeAsk;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @qEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'How did you enter Germany?'**
  String get qEntryTitle;

  /// No description provided for @qEntryWhy.
  ///
  /// In en, this message translates to:
  /// **'This decides which residence-permit steps you see.'**
  String get qEntryWhy;

  /// No description provided for @entryNationalVisa.
  ///
  /// In en, this message translates to:
  /// **'With a national visa for studies (\"D\" visa)'**
  String get entryNationalVisa;

  /// No description provided for @entryVisaFree.
  ///
  /// In en, this message translates to:
  /// **'Without a visa (e.g. citizens of the USA, Canada, Japan)'**
  String get entryVisaFree;

  /// No description provided for @entryEu.
  ///
  /// In en, this message translates to:
  /// **'I am an EU, EEA or Swiss citizen'**
  String get entryEu;

  /// No description provided for @entryHelp.
  ///
  /// In en, this message translates to:
  /// **'Not sure? Look at the visa sticker in your passport. A national visa shows the letter \"D\".'**
  String get entryHelp;

  /// No description provided for @qStageTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you starting?'**
  String get qStageTitle;

  /// No description provided for @qStageWhy.
  ///
  /// In en, this message translates to:
  /// **'Some cities have different official pages for degree studies and preparatory courses.'**
  String get qStageWhy;

  /// No description provided for @stageDegree.
  ///
  /// In en, this message translates to:
  /// **'A degree programme (Bachelor, Master, PhD)'**
  String get stageDegree;

  /// No description provided for @stagePrep.
  ///
  /// In en, this message translates to:
  /// **'A preparatory course (Studienkolleg or a course before studies)'**
  String get stagePrep;

  /// No description provided for @qCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Where will you live?'**
  String get qCityTitle;

  /// No description provided for @qCityWhy.
  ///
  /// In en, this message translates to:
  /// **'Offices and procedures are local. We link the official pages for your city.'**
  String get qCityWhy;

  /// No description provided for @cityBerlin.
  ///
  /// In en, this message translates to:
  /// **'Berlin'**
  String get cityBerlin;

  /// No description provided for @cityMunich.
  ///
  /// In en, this message translates to:
  /// **'Munich'**
  String get cityMunich;

  /// No description provided for @cityOther.
  ///
  /// In en, this message translates to:
  /// **'Another city or town'**
  String get cityOther;

  /// No description provided for @cityOtherHelp.
  ///
  /// In en, this message translates to:
  /// **'You will get the federal rules plus official tools to find your local offices.'**
  String get cityOtherHelp;

  /// No description provided for @qArrivalTitle.
  ///
  /// In en, this message translates to:
  /// **'When did (or will) you arrive in Germany?'**
  String get qArrivalTitle;

  /// No description provided for @qArrivalWhy.
  ///
  /// In en, this message translates to:
  /// **'Some time limits count from your arrival.'**
  String get qArrivalWhy;

  /// No description provided for @qMoveInTitle.
  ///
  /// In en, this message translates to:
  /// **'When did (or will) you move into your long-term home?'**
  String get qMoveInTitle;

  /// No description provided for @qMoveInWhy.
  ///
  /// In en, this message translates to:
  /// **'Moving in starts the two-week deadline to register your address.'**
  String get qMoveInWhy;

  /// No description provided for @moveInUnknown.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have a long-term home yet'**
  String get moveInUnknown;

  /// No description provided for @qVisaTitle.
  ///
  /// In en, this message translates to:
  /// **'When does your visa end?'**
  String get qVisaTitle;

  /// No description provided for @qVisaWhy.
  ///
  /// In en, this message translates to:
  /// **'You must apply for your residence permit before this date.'**
  String get qVisaWhy;

  /// No description provided for @visaHelp.
  ///
  /// In en, this message translates to:
  /// **'It is printed on the visa in your passport (field \"until\" / \"bis\").'**
  String get visaHelp;

  /// No description provided for @visaUnknown.
  ///
  /// In en, this message translates to:
  /// **'I\'ll add it later'**
  String get visaUnknown;

  /// No description provided for @qMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'A few more questions'**
  String get qMoreTitle;

  /// No description provided for @qMoreWhy.
  ///
  /// In en, this message translates to:
  /// **'Each answer adds or removes specific tasks. We don\'t ask for your name, nationality or documents.'**
  String get qMoreWhy;

  /// No description provided for @age30Plus.
  ///
  /// In en, this message translates to:
  /// **'I am 30 or older'**
  String get age30Plus;

  /// No description provided for @age30PlusHelp.
  ///
  /// In en, this message translates to:
  /// **'Health insurance rules for students change at 30.'**
  String get age30PlusHelp;

  /// No description provided for @plansToWork.
  ///
  /// In en, this message translates to:
  /// **'I plan to work while studying'**
  String get plansToWork;

  /// No description provided for @familyJoining.
  ///
  /// In en, this message translates to:
  /// **'My spouse or children are coming with me'**
  String get familyJoining;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get pickDate;

  /// No description provided for @changeDate.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get changeDate;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your checklist is ready'**
  String get summaryTitle;

  /// No description provided for @summaryBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task selected for your situation.} other{{count} tasks selected for your situation.}}'**
  String summaryBody(int count);

  /// No description provided for @seeChecklist.
  ///
  /// In en, this message translates to:
  /// **'See my checklist'**
  String get seeChecklist;

  /// No description provided for @saveAnswers.
  ///
  /// In en, this message translates to:
  /// **'Save answers'**
  String get saveAnswers;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// No description provided for @tabDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tabDone;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String progress(int done, int total);

  /// No description provided for @nextDeadline.
  ///
  /// In en, this message translates to:
  /// **'Next deadline: {date}'**
  String nextDeadline(String date);

  /// No description provided for @emptyToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing urgent right now. Look at Upcoming to see what comes next.'**
  String get emptyToday;

  /// No description provided for @emptyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled later.'**
  String get emptyUpcoming;

  /// No description provided for @emptyDone.
  ///
  /// In en, this message translates to:
  /// **'Tasks you mark as done appear here.'**
  String get emptyDone;

  /// No description provided for @whenItHappens.
  ///
  /// In en, this message translates to:
  /// **'When it happens'**
  String get whenItHappens;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueOn(String date);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Due tomorrow} other{Due in {days} days}}'**
  String dueInDays(int days);

  /// No description provided for @overdueSince.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {date}'**
  String overdueSince(String date);

  /// No description provided for @followUpOn.
  ///
  /// In en, this message translates to:
  /// **'Follow up on {date}'**
  String followUpOn(String date);

  /// No description provided for @suggestedBy.
  ///
  /// In en, this message translates to:
  /// **'Suggested by {date}'**
  String suggestedBy(String date);

  /// No description provided for @startFrom.
  ///
  /// In en, this message translates to:
  /// **'Start from {date}'**
  String startFrom(String date);

  /// No description provided for @asSoonAsPossible.
  ///
  /// In en, this message translates to:
  /// **'As soon as possible'**
  String get asSoonAsPossible;

  /// No description provided for @addDateForDeadline.
  ///
  /// In en, this message translates to:
  /// **'Add your {field} to see the deadline'**
  String addDateForDeadline(String field);

  /// No description provided for @fieldMoveIn.
  ///
  /// In en, this message translates to:
  /// **'move-in date'**
  String get fieldMoveIn;

  /// No description provided for @fieldVisaExpiry.
  ///
  /// In en, this message translates to:
  /// **'visa end date'**
  String get fieldVisaExpiry;

  /// No description provided for @fieldPermitExpiry.
  ///
  /// In en, this message translates to:
  /// **'residence card expiry date'**
  String get fieldPermitExpiry;

  /// No description provided for @fieldArrival.
  ///
  /// In en, this message translates to:
  /// **'arrival date'**
  String get fieldArrival;

  /// No description provided for @firstDo.
  ///
  /// In en, this message translates to:
  /// **'First: {title}'**
  String firstDo(String title);

  /// No description provided for @noLongerApplies.
  ///
  /// In en, this message translates to:
  /// **'No longer applies to your answers'**
  String get noLongerApplies;

  /// No description provided for @updatedSinceCompletion.
  ///
  /// In en, this message translates to:
  /// **'Information updated since you completed this'**
  String get updatedSinceCompletion;

  /// No description provided for @overdueLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdueLabel;

  /// No description provided for @completedOn.
  ///
  /// In en, this message translates to:
  /// **'Done on {date}'**
  String completedOn(String date);

  /// No description provided for @sectionWhy.
  ///
  /// In en, this message translates to:
  /// **'Why this matters'**
  String get sectionWhy;

  /// No description provided for @sectionWho.
  ///
  /// In en, this message translates to:
  /// **'Why you see this'**
  String get sectionWho;

  /// No description provided for @whoAlways.
  ///
  /// In en, this message translates to:
  /// **'This applies to everyone who moves to Germany in this situation.'**
  String get whoAlways;

  /// No description provided for @whoBased.
  ///
  /// In en, this message translates to:
  /// **'Selected from your answers about: {fields}.'**
  String whoBased(String fields);

  /// No description provided for @answerEntry.
  ///
  /// In en, this message translates to:
  /// **'how you entered'**
  String get answerEntry;

  /// No description provided for @answerStage.
  ///
  /// In en, this message translates to:
  /// **'what you study'**
  String get answerStage;

  /// No description provided for @answerCity.
  ///
  /// In en, this message translates to:
  /// **'your city'**
  String get answerCity;

  /// No description provided for @answerAge.
  ///
  /// In en, this message translates to:
  /// **'age'**
  String get answerAge;

  /// No description provided for @answerWork.
  ///
  /// In en, this message translates to:
  /// **'work plans'**
  String get answerWork;

  /// No description provided for @answerFamily.
  ///
  /// In en, this message translates to:
  /// **'family'**
  String get answerFamily;

  /// No description provided for @answerDates.
  ///
  /// In en, this message translates to:
  /// **'your dates'**
  String get answerDates;

  /// No description provided for @sectionWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get sectionWhen;

  /// No description provided for @basisLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal deadline (from the law or the authority)'**
  String get basisLegal;

  /// No description provided for @basisGuidance.
  ///
  /// In en, this message translates to:
  /// **'Follow-up date based on official guidance — not a deadline for you'**
  String get basisGuidance;

  /// No description provided for @basisSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Our suggestion — not a legal deadline'**
  String get basisSuggestion;

  /// No description provided for @suggestedStartNote.
  ///
  /// In en, this message translates to:
  /// **'We suggest starting by {date} because appointments can take weeks.'**
  String suggestedStartNote(String date);

  /// No description provided for @timingNone.
  ///
  /// In en, this message translates to:
  /// **'No fixed date.'**
  String get timingNone;

  /// No description provided for @timingAsap.
  ///
  /// In en, this message translates to:
  /// **'No fixed legal date — do it as soon as you reasonably can.'**
  String get timingAsap;

  /// No description provided for @timingEvent.
  ///
  /// In en, this message translates to:
  /// **'Only relevant when this happens.'**
  String get timingEvent;

  /// No description provided for @editDates.
  ///
  /// In en, this message translates to:
  /// **'Edit my dates'**
  String get editDates;

  /// No description provided for @sectionDocs.
  ///
  /// In en, this message translates to:
  /// **'What you need'**
  String get sectionDocs;

  /// No description provided for @docOfficial.
  ///
  /// In en, this message translates to:
  /// **'Named by an official source'**
  String get docOfficial;

  /// No description provided for @docCommon.
  ///
  /// In en, this message translates to:
  /// **'Commonly requested — check the official list'**
  String get docCommon;

  /// No description provided for @sectionSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get sectionSteps;

  /// No description provided for @sectionSources.
  ///
  /// In en, this message translates to:
  /// **'Official source'**
  String get sectionSources;

  /// No description provided for @lastChecked.
  ///
  /// In en, this message translates to:
  /// **'Last checked by us: {date}'**
  String lastChecked(String date);

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending editorial re-check'**
  String get pendingReview;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open official page'**
  String get openSource;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @openFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the page. Copy the link and open it in your browser. If the page has moved, search the authority\'s website for its title.'**
  String get openFailed;

  /// No description provided for @needsInternet.
  ///
  /// In en, this message translates to:
  /// **'Opens in your browser — needs internet.'**
  String get needsInternet;

  /// No description provided for @publicBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Publicly funded organisation (not a government authority)'**
  String get publicBodyLabel;

  /// No description provided for @governmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Government / official authority'**
  String get governmentLabel;

  /// No description provided for @explanationLabel.
  ///
  /// In en, this message translates to:
  /// **'Our plain-language explanation. If it differs from the official source, the official source is correct.'**
  String get explanationLabel;

  /// No description provided for @officialTerms.
  ///
  /// In en, this message translates to:
  /// **'Words you will see'**
  String get officialTerms;

  /// No description provided for @sectionNotes.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get sectionNotes;

  /// No description provided for @myNotes.
  ///
  /// In en, this message translates to:
  /// **'My notes'**
  String get myNotes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Private note — stays on this phone. Don\'t store passport or ID numbers.'**
  String get notesHint;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get noteSaved;

  /// No description provided for @markComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get markComplete;

  /// No description provided for @markIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done'**
  String get markIncomplete;

  /// No description provided for @reconfirm.
  ///
  /// In en, this message translates to:
  /// **'I\'ve checked the update'**
  String get reconfirm;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set a reminder'**
  String get setReminder;

  /// No description provided for @reminderOn.
  ///
  /// In en, this message translates to:
  /// **'Reminder on {date}'**
  String reminderOn(String date);

  /// No description provided for @removeReminder.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder'**
  String get removeReminder;

  /// No description provided for @remindWeekBefore.
  ///
  /// In en, this message translates to:
  /// **'1 week before the date'**
  String get remindWeekBefore;

  /// No description provided for @remindDayBefore.
  ///
  /// In en, this message translates to:
  /// **'1 day before the date'**
  String get remindDayBefore;

  /// No description provided for @remindTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get remindTomorrow;

  /// No description provided for @remindPick.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get remindPick;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Erstmal. You can allow them in your phone settings.'**
  String get reminderPermissionDenied;

  /// No description provided for @reminderSaved.
  ///
  /// In en, this message translates to:
  /// **'Reminder set'**
  String get reminderSaved;

  /// No description provided for @professionalHelp.
  ///
  /// In en, this message translates to:
  /// **'When to get individual help'**
  String get professionalHelp;

  /// No description provided for @dependencies.
  ///
  /// In en, this message translates to:
  /// **'Do this first'**
  String get dependencies;

  /// No description provided for @recommendedAfter.
  ///
  /// In en, this message translates to:
  /// **'Usually easier after'**
  String get recommendedAfter;

  /// No description provided for @fallbackLanguage.
  ///
  /// In en, this message translates to:
  /// **'Not yet available in your language — showing English.'**
  String get fallbackLanguage;

  /// No description provided for @kindPractical.
  ///
  /// In en, this message translates to:
  /// **'Practical tip — not a legal requirement'**
  String get kindPractical;

  /// No description provided for @kindInformation.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get kindInformation;

  /// No description provided for @kindOfficial.
  ///
  /// In en, this message translates to:
  /// **'Official requirement'**
  String get kindOfficial;

  /// No description provided for @kindProcess.
  ///
  /// In en, this message translates to:
  /// **'Official process'**
  String get kindProcess;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report outdated or wrong information'**
  String get reportProblem;

  /// No description provided for @reportCopied.
  ///
  /// In en, this message translates to:
  /// **'A report was copied to your clipboard. Paste it into an email or message to the Erstmal team. It contains only the task and source, no personal data.'**
  String get reportCopied;

  /// No description provided for @yourSituation.
  ///
  /// In en, this message translates to:
  /// **'Your situation'**
  String get yourSituation;

  /// No description provided for @editAnswers.
  ///
  /// In en, this message translates to:
  /// **'Edit answers'**
  String get editAnswers;

  /// No description provided for @permitExpiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Residence card expires on'**
  String get permitExpiryLabel;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @showTaskNames.
  ///
  /// In en, this message translates to:
  /// **'Show task names in reminders'**
  String get showTaskNames;

  /// No description provided for @showTaskNamesHelp.
  ///
  /// In en, this message translates to:
  /// **'Off: reminders only say you have a task coming up, so people who see your lock screen learn nothing about your situation.'**
  String get showTaskNamesHelp;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @dataVersion.
  ///
  /// In en, this message translates to:
  /// **'Checklist data {version}, released {date}'**
  String dataVersion(String version, String date);

  /// No description provided for @sourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'All official sources'**
  String get sourcesTitle;

  /// No description provided for @sourcesIntro.
  ///
  /// In en, this message translates to:
  /// **'Every task links to where the rule comes from. We checked each page on the date shown. Pages can change after that.'**
  String get sourcesIntro;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacySummary.
  ///
  /// In en, this message translates to:
  /// **'Your answers, progress, notes and reminders are stored only on this phone. There is no account, no server and no tracking. Deleting the app or using \"Delete all my data\" removes everything.'**
  String get privacySummary;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Copy my data'**
  String get exportData;

  /// No description provided for @exportCopied.
  ///
  /// In en, this message translates to:
  /// **'Your data was copied to the clipboard (JSON). Be careful where you paste it.'**
  String get exportCopied;

  /// No description provided for @deleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete all my data'**
  String get deleteData;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete everything?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your answers, progress, notes and reminders will be removed from this phone. This cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @datasetErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'The checklist could not be loaded'**
  String get datasetErrorTitle;

  /// No description provided for @datasetErrorBody.
  ///
  /// In en, this message translates to:
  /// **'The built-in checklist data failed its safety checks, so we are not showing possibly wrong information. Please update the app. Until then, use the official websites of your city and your university\'s international office.'**
  String get datasetErrorBody;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Your last change could not be saved on this phone. Check free storage and try again.'**
  String get saveFailed;

  /// No description provided for @recoveredNotice.
  ///
  /// In en, this message translates to:
  /// **'We could not read your saved data and started fresh. A copy of the old file was kept on this phone.'**
  String get recoveredNotice;

  /// No description provided for @euNotice.
  ///
  /// In en, this message translates to:
  /// **'As an EU, EEA or Swiss citizen you do not need a residence permit for studies. Your checklist covers registration and other everyday steps.'**
  String get euNotice;

  /// No description provided for @reminderGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Erstmal'**
  String get reminderGenericTitle;

  /// No description provided for @reminderGenericBody.
  ///
  /// In en, this message translates to:
  /// **'You have a checklist task coming up.'**
  String get reminderGenericBody;

  /// No description provided for @openTask.
  ///
  /// In en, this message translates to:
  /// **'Open task'**
  String get openTask;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dismiss;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
