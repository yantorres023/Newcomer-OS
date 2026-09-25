import 'dart:convert';
import 'dart:io';

import 'package:newcomer_os/domain/dataset.dart';
import 'package:newcomer_os/domain/local_date.dart';
import 'package:newcomer_os/domain/profile.dart';

const rulesPath = 'assets/roadmaps/de-students/rules.json';
const sourcesPath = 'assets/roadmaps/de-students/sources.json';

Map<String, Object?> readJson(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

/// Deep copy so tests can mutate freely.
Map<String, Object?> clone(Map<String, Object?> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, Object?>;

RoadmapDataset loadRealDataset() => RoadmapDataset.fromJson(
  rulesJson: readJson(rulesPath),
  sourcesJson: readJson(sourcesPath),
);

RoadmapDataset datasetFrom(
  Map<String, Object?> rules, [
  Map<String, Object?>? sources,
]) => RoadmapDataset.fromJson(
  rulesJson: rules,
  sourcesJson: sources ?? readJson(sourcesPath),
);

List<Map<String, Object?>> rulesOf(Map<String, Object?> json) =>
    (json['rules'] as List).cast<Map<String, Object?>>();

Map<String, Object?> ruleIn(Map<String, Object?> json, String id) =>
    rulesOf(json).firstWhere((r) => r['id'] == id);

final arrival = LocalDate(2026, 10, 1);

UserProfile profile({
  EntryType entry = EntryType.nationalVisa,
  StudyStage stage = StudyStage.degree,
  City city = City.berlin,
  LocalDate? arrivalDate,
  LocalDate? moveIn,
  LocalDate? visaExpiry,
  LocalDate? permitExpiry,
  bool age30 = false,
  bool work = false,
  bool family = false,
}) => UserProfile(
  entryType: entry,
  studyStage: stage,
  city: city,
  arrivalDate: arrivalDate ?? arrival,
  moveInDate: moveIn,
  visaExpiryDate: visaExpiry,
  permitExpiryDate: permitExpiry,
  age30Plus: age30,
  plansToWork: work,
  familyJoining: family,
);

String readJsonRaw(String path) => File(path).readAsStringSync();
