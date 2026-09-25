import 'dart:convert';
import 'dart:io';

import '../domain/user_state.dart';

/// Raw persistence for the user's state document.
abstract class StoreBackend {
  Future<String?> read();
  Future<void> write(String contents);
  Future<void> delete();

  /// Keeps an unreadable document aside instead of silently discarding it.
  Future<void> quarantine(String contents);
}

class MemoryStoreBackend implements StoreBackend {
  MemoryStoreBackend([this.contents]);
  String? contents;
  String? quarantined;

  @override
  Future<String?> read() async => contents;
  @override
  Future<void> write(String value) async => contents = value;
  @override
  Future<void> delete() async => contents = null;
  @override
  Future<void> quarantine(String value) async => quarantined = value;
}

/// Stores the state as one JSON file in the app's private support directory.
/// Writes go to a temp file first and are then renamed, so a crash during a
/// write never leaves a half-written document.
class FileStoreBackend implements StoreBackend {
  FileStoreBackend(this.directory);
  final Directory directory;

  File get _file => File('${directory.path}/user_state.json');

  @override
  Future<String?> read() async =>
      await _file.exists() ? _file.readAsString() : null;

  @override
  Future<void> write(String contents) async {
    await directory.create(recursive: true);
    final tmp = File('${_file.path}.tmp');
    await tmp.writeAsString(contents, flush: true);
    await tmp.rename(_file.path);
  }

  @override
  Future<void> delete() async {
    for (final f in [
      _file,
      File('${_file.path}.tmp'),
      File('${_file.path}.corrupt'),
    ]) {
      if (await f.exists()) await f.delete();
    }
  }

  @override
  Future<void> quarantine(String contents) =>
      File('${_file.path}.corrupt').writeAsString(contents, flush: true);
}

enum LoadOutcome { fresh, loaded, migrated, recoveredFromCorruption }

class LoadResult {
  const LoadResult(this.state, this.outcome);
  final UserState state;
  final LoadOutcome outcome;
}

typedef Migration = Map<String, Object?> Function(Map<String, Object?> json);

/// Versioned local store with forward migrations.
///
/// Schema history:
/// - v1 (pre-release development builds): `completed` was a plain list of
///   rule ids, with no rule version or date.
/// - v2: `completions` map with rule version and completion date.
class LocalStore {
  LocalStore(this.backend, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final StoreBackend backend;
  final DateTime Function() _clock;

  static final Map<int, Migration> migrations = {1: _migrateV1toV2};

  Future<LoadResult> load() async {
    final raw = await backend.read();
    if (raw == null) return const LoadResult(UserState(), LoadOutcome.fresh);
    try {
      var json = jsonDecode(raw) as Map<String, Object?>;
      var version = json['schema_version'] as int? ?? 1;
      if (version > UserState.schemaVersion) {
        throw FormatException('Document from newer app (v$version)');
      }
      final migrated = version < UserState.schemaVersion;
      while (version < UserState.schemaVersion) {
        json = migrations[version]!(json);
        version = json['schema_version'] as int;
      }
      final state = UserState.fromJson(json);
      if (migrated) await save(state);
      return LoadResult(
        state,
        migrated ? LoadOutcome.migrated : LoadOutcome.loaded,
      );
    } on Object {
      await backend.quarantine(raw);
      return const LoadResult(UserState(), LoadOutcome.recoveredFromCorruption);
    }
  }

  Future<void> save(UserState state) =>
      backend.write(jsonEncode(state.toJson()));

  Future<void> deleteAll() => backend.delete();

  /// Human-readable export of everything stored (for the user's own records).
  String export(UserState state) => const JsonEncoder.withIndent('  ')
      .convert({'exported_at': _clock().toIso8601String(), ...state.toJson()});

  static Map<String, Object?> _migrateV1toV2(Map<String, Object?> json) {
    final completed = (json['completed'] as List? ?? const []).cast<String>();
    // v1 did not record when or against which rule version a task was
    // completed. Version 0 makes the resolver flag these tasks as "updated
    // since you completed" so the user re-checks them. The arrival date is
    // used as completion date: the earliest plausible date, so follow-up
    // dates derived from it are never later than the real ones.
    final profile = json['profile'] as Map<String, Object?>?;
    final fallbackDate = (profile?['arrival_date'] as String?) ?? '2026-01-01';
    return {
      ...json..remove('completed'),
      'schema_version': 2,
      'completions': {
        for (final id in completed)
          id: {'rule_id': id, 'rule_version': 0, 'completed_on': fallbackDate},
      },
    };
  }
}
