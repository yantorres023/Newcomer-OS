import 'local_date.dart';
import 'profile.dart';

/// Records that the user marked a task done, and against which rule version.
class CompletionRecord {
  const CompletionRecord({
    required this.ruleId,
    required this.ruleVersion,
    required this.completedOn,
  });

  final String ruleId;
  final int ruleVersion;
  final LocalDate completedOn;

  Map<String, Object?> toJson() => {
    'rule_id': ruleId,
    'rule_version': ruleVersion,
    'completed_on': completedOn.toString(),
  };

  factory CompletionRecord.fromJson(Map<String, Object?> json) =>
      CompletionRecord(
        ruleId: json['rule_id'] as String,
        ruleVersion: json['rule_version'] as int,
        completedOn: LocalDate.parse(json['completed_on'] as String),
      );
}

/// A user-chosen reminder for one task. Scheduled as a local notification.
class Reminder {
  const Reminder({
    required this.ruleId,
    required this.date,
    required this.notificationId,
  });

  final String ruleId;
  final LocalDate date;
  final int notificationId;

  Map<String, Object?> toJson() => {
    'rule_id': ruleId,
    'date': date.toString(),
    'notification_id': notificationId,
  };

  factory Reminder.fromJson(Map<String, Object?> json) => Reminder(
    ruleId: json['rule_id'] as String,
    date: LocalDate.parse(json['date'] as String),
    notificationId: json['notification_id'] as int,
  );
}

enum LanguagePreference { system, en, de }

class AppSettings {
  const AppSettings({
    this.language = LanguagePreference.system,
    this.showTaskNamesInNotifications = false,
    this.disclaimerAcceptedVersion,
  });

  final LanguagePreference language;

  /// Off by default: a lock-screen notification naming a residence-permit
  /// task reveals immigration status to anyone who sees the phone.
  final bool showTaskNamesInNotifications;

  final int? disclaimerAcceptedVersion;

  AppSettings copyWith({
    LanguagePreference? language,
    bool? showTaskNamesInNotifications,
    int? disclaimerAcceptedVersion,
  }) => AppSettings(
    language: language ?? this.language,
    showTaskNamesInNotifications:
        showTaskNamesInNotifications ?? this.showTaskNamesInNotifications,
    disclaimerAcceptedVersion:
        disclaimerAcceptedVersion ?? this.disclaimerAcceptedVersion,
  );

  Map<String, Object?> toJson() => {
    'language': language.name,
    'show_task_names_in_notifications': showTaskNamesInNotifications,
    'disclaimer_accepted_version': disclaimerAcceptedVersion,
  };

  factory AppSettings.fromJson(Map<String, Object?> json) => AppSettings(
    language:
        LanguagePreference.values.asNameMap()[json['language']] ??
        LanguagePreference.system,
    showTaskNamesInNotifications:
        json['show_task_names_in_notifications'] as bool? ?? false,
    disclaimerAcceptedVersion: json['disclaimer_accepted_version'] as int?,
  );
}

/// Everything the user has entered or done. Stored locally only; kept
/// separate from rule definitions so dataset updates never overwrite it.
class UserState {
  const UserState({
    this.profile,
    this.completions = const {},
    this.notes = const {},
    this.reminders = const {},
    this.settings = const AppSettings(),
  });

  final UserProfile? profile;
  final Map<String, CompletionRecord> completions;
  final Map<String, String> notes;
  final Map<String, Reminder> reminders;
  final AppSettings settings;

  static const schemaVersion = 2;

  UserState copyWith({
    UserProfile? Function()? profile,
    Map<String, CompletionRecord>? completions,
    Map<String, String>? notes,
    Map<String, Reminder>? reminders,
    AppSettings? settings,
  }) => UserState(
    profile: profile != null ? profile() : this.profile,
    completions: completions ?? this.completions,
    notes: notes ?? this.notes,
    reminders: reminders ?? this.reminders,
    settings: settings ?? this.settings,
  );

  Map<String, Object?> toJson() => {
    'schema_version': schemaVersion,
    'profile': profile?.toJson(),
    'completions': {for (final c in completions.values) c.ruleId: c.toJson()},
    'notes': notes,
    'reminders': {for (final r in reminders.values) r.ruleId: r.toJson()},
    'settings': settings.toJson(),
  };

  factory UserState.fromJson(Map<String, Object?> json) {
    final profileJson = json['profile'];
    Map<String, Object?> map(Object? v) =>
        v == null ? const {} : Map<String, Object?>.from(v as Map);
    return UserState(
      profile: profileJson == null
          ? null
          : UserProfile.fromJson(map(profileJson)),
      completions: {
        for (final e in map(json['completions']).entries)
          e.key: CompletionRecord.fromJson(map(e.value)),
      },
      notes: Map<String, String>.from(map(json['notes'])),
      reminders: {
        for (final e in map(json['reminders']).entries)
          e.key: Reminder.fromJson(map(e.value)),
      },
      settings: AppSettings.fromJson(map(json['settings'])),
    );
  }
}
