import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/dataset.dart';
import '../domain/dataset_validator.dart';

class DatasetLoadException implements Exception {
  DatasetLoadException(this.message);
  final String message;
  @override
  String toString() => 'DatasetLoadException: $message';
}

/// Loads the active roadmap dataset bundled with the app (works offline).
///
/// A dataset that fails validation is rejected rather than shown partially:
/// incorrect administrative guidance is worse than an explicit error.
class DatasetLoader {
  DatasetLoader({AssetBundle? bundle, DatasetValidator? validator})
    : _bundle = bundle ?? rootBundle,
      _validator = validator ?? DatasetValidator();

  final AssetBundle _bundle;
  final DatasetValidator _validator;

  static const manifestPath = 'assets/roadmaps/manifest.json';

  Future<RoadmapDataset> load() async {
    try {
      final manifest = await _json(manifestPath);
      final activeId = manifest['active_dataset'] as String;
      final entry = (manifest['datasets'] as List)
          .cast<Map<String, Object?>>()
          .firstWhere((d) => d['id'] == activeId);
      final dataset = RoadmapDataset.fromJson(
        rulesJson: await _json(entry['rules'] as String),
        sourcesJson: await _json(entry['sources'] as String),
      );
      if (dataset.version != entry['version']) {
        throw DatasetLoadException(
          'Manifest version ${entry['version']} != ${dataset.version}',
        );
      }
      final report = _validator.validate(dataset);
      if (!report.isValid) {
        throw DatasetLoadException(report.errors.join('; '));
      }
      return dataset;
    } on DatasetLoadException {
      rethrow;
    } on Object catch (e) {
      throw DatasetLoadException(e.toString());
    }
  }

  Future<Map<String, Object?>> _json(String path) async =>
      jsonDecode(await _bundle.loadString(path)) as Map<String, Object?>;
}
