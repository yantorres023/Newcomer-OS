import 'local_date.dart';

/// How the user entered Germany. Selects the residence-permit rules.
enum EntryType { nationalVisa, visaFree, euEeaCh }

/// Degree programme vs. preparatory course (Studienkolleg / language course
/// before studies). Selects city-specific official pages.
enum StudyStage { degree, preparatory }

/// Cities with a dedicated source pack. Everything else is [other].
enum City { berlin, munich, other }

/// Only the answers needed to select roadmap rules. No names, passport
/// numbers, nationality or document images are collected.
class UserProfile {
  const UserProfile({
    required this.entryType,
    required this.studyStage,
    required this.city,
    required this.arrivalDate,
    this.moveInDate,
    this.visaExpiryDate,
    this.permitExpiryDate,
    this.age30Plus = false,
    this.plansToWork = false,
    this.familyJoining = false,
  });

  final EntryType entryType;
  final StudyStage studyStage;
  final City city;
  final LocalDate arrivalDate;
  final LocalDate? moveInDate;
  final LocalDate? visaExpiryDate;
  final LocalDate? permitExpiryDate;
  final bool age30Plus;
  final bool plansToWork;
  final bool familyJoining;

  /// Values as seen by rule conditions. Keys match the dataset's field names.
  Map<String, Object?> get conditionFields => {
    'entry_type': _entryTypeCode(entryType),
    'study_stage': studyStage.name,
    'city': city.name,
    'arrival_date': arrivalDate,
    'move_in_date': moveInDate,
    'visa_expiry_date': visaExpiryDate,
    'permit_expiry_date': permitExpiryDate,
    'age_30_plus': age30Plus,
    'plans_to_work': plansToWork,
    'family_joining': familyJoining,
  };

  static const conditionFieldNames = {
    'entry_type',
    'study_stage',
    'city',
    'arrival_date',
    'move_in_date',
    'visa_expiry_date',
    'permit_expiry_date',
    'age_30_plus',
    'plans_to_work',
    'family_joining',
  };

  static const dateFieldNames = {
    'arrival_date',
    'move_in_date',
    'visa_expiry_date',
    'permit_expiry_date',
  };

  static String _entryTypeCode(EntryType type) => switch (type) {
    EntryType.nationalVisa => 'national_visa',
    EntryType.visaFree => 'visa_free',
    EntryType.euEeaCh => 'eu_eea_ch',
  };

  static EntryType _entryTypeFromCode(String code) => switch (code) {
    'national_visa' => EntryType.nationalVisa,
    'visa_free' => EntryType.visaFree,
    'eu_eea_ch' => EntryType.euEeaCh,
    _ => throw FormatException('Unknown entry type "$code"'),
  };

  UserProfile copyWith({
    EntryType? entryType,
    StudyStage? studyStage,
    City? city,
    LocalDate? arrivalDate,
    LocalDate? Function()? moveInDate,
    LocalDate? Function()? visaExpiryDate,
    LocalDate? Function()? permitExpiryDate,
    bool? age30Plus,
    bool? plansToWork,
    bool? familyJoining,
  }) => UserProfile(
    entryType: entryType ?? this.entryType,
    studyStage: studyStage ?? this.studyStage,
    city: city ?? this.city,
    arrivalDate: arrivalDate ?? this.arrivalDate,
    moveInDate: moveInDate != null ? moveInDate() : this.moveInDate,
    visaExpiryDate: visaExpiryDate != null
        ? visaExpiryDate()
        : this.visaExpiryDate,
    permitExpiryDate: permitExpiryDate != null
        ? permitExpiryDate()
        : this.permitExpiryDate,
    age30Plus: age30Plus ?? this.age30Plus,
    plansToWork: plansToWork ?? this.plansToWork,
    familyJoining: familyJoining ?? this.familyJoining,
  );

  Map<String, Object?> toJson() => {
    'entry_type': _entryTypeCode(entryType),
    'study_stage': studyStage.name,
    'city': city.name,
    'arrival_date': arrivalDate.toString(),
    'move_in_date': moveInDate?.toString(),
    'visa_expiry_date': visaExpiryDate?.toString(),
    'permit_expiry_date': permitExpiryDate?.toString(),
    'age_30_plus': age30Plus,
    'plans_to_work': plansToWork,
    'family_joining': familyJoining,
  };

  factory UserProfile.fromJson(Map<String, Object?> json) => UserProfile(
    entryType: _entryTypeFromCode(json['entry_type'] as String),
    studyStage: StudyStage.values.byName(json['study_stage'] as String),
    city: City.values.byName(json['city'] as String),
    arrivalDate: LocalDate.parse(json['arrival_date'] as String),
    moveInDate: LocalDate.tryParse(json['move_in_date'] as String?),
    visaExpiryDate: LocalDate.tryParse(json['visa_expiry_date'] as String?),
    permitExpiryDate: LocalDate.tryParse(json['permit_expiry_date'] as String?),
    age30Plus: json['age_30_plus'] as bool? ?? false,
    plansToWork: json['plans_to_work'] as bool? ?? false,
    familyJoining: json['family_joining'] as bool? ?? false,
  );
}
