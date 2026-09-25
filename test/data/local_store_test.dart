import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/data/local_store.dart';
import 'package:newcomer_os/domain/local_date.dart';
import 'package:newcomer_os/domain/user_state.dart';

import '../support/fixtures.dart';

void main() {
  UserState sample() => UserState(
    profile: profile(moveIn: LocalDate(2026, 10, 3), work: true),
    completions: {
      'de.registration.anmeldung': CompletionRecord(
        ruleId: 'de.registration.anmeldung',
        ruleVersion: 1,
        completedOn: LocalDate(2026, 10, 7),
      ),
    },
    notes: {'de.registration.anmeldung': 'Bürgeramt Mitte, 9:30'},
    reminders: {
      'de.residence.permit_application': Reminder(
        ruleId: 'de.residence.permit_application',
        date: LocalDate(2026, 11, 1),
        notificationId: 42,
      ),
    },
    settings: const AppSettings(
      language: LanguagePreference.de,
      disclaimerAcceptedVersion: 1,
    ),
  );

  test('fresh install loads empty state', () async {
    final result = await LocalStore(MemoryStoreBackend()).load();
    expect(result.outcome, LoadOutcome.fresh);
    expect(result.state.profile, isNull);
  });

  test('round-trips every field', () async {
    final backend = MemoryStoreBackend();
    final store = LocalStore(backend);
    await store.save(sample());
    final result = await store.load();
    expect(result.outcome, LoadOutcome.loaded);
    expect(jsonEncode(result.state.toJson()), jsonEncode(sample().toJson()));
  });

  test('migrates pre-release v1 documents', () async {
    final v1 = {
      'schema_version': 1,
      'profile': profile().toJson(),
      'completed': ['de.registration.anmeldung'],
      'notes': {'de.registration.anmeldung': 'x'},
    };
    final backend = MemoryStoreBackend(jsonEncode(v1));
    final result = await LocalStore(backend).load();
    expect(result.outcome, LoadOutcome.migrated);
    final c = result.state.completions['de.registration.anmeldung']!;
    expect(c.ruleVersion, 0, reason: 'flags re-check after migration');
    expect(c.completedOn, arrival);
    expect(result.state.notes['de.registration.anmeldung'], 'x');
    // Migrated document is persisted in the new format.
    final saved = jsonDecode(backend.contents!) as Map<String, Object?>;
    expect(saved['schema_version'], UserState.schemaVersion);
    expect(saved.containsKey('completed'), isFalse);
  });

  test('corrupt document is quarantined, not silently lost', () async {
    final backend = MemoryStoreBackend('{not json');
    final result = await LocalStore(backend).load();
    expect(result.outcome, LoadOutcome.recoveredFromCorruption);
    expect(backend.quarantined, '{not json');
  });

  test('document from a newer app version is not misread', () async {
    final backend = MemoryStoreBackend(jsonEncode({'schema_version': 99}));
    final result = await LocalStore(backend).load();
    expect(result.outcome, LoadOutcome.recoveredFromCorruption);
  });

  test('export contains data and timestamp; delete removes it', () async {
    final backend = MemoryStoreBackend();
    final store = LocalStore(
      backend,
      clock: () => DateTime.utc(2026, 10, 1, 12),
    );
    await store.save(sample());
    final exported = jsonDecode(store.export(sample())) as Map;
    expect(exported['exported_at'], '2026-10-01T12:00:00.000Z');
    expect(exported['notes'], isNotEmpty);
    await store.deleteAll();
    expect((await store.load()).outcome, LoadOutcome.fresh);
  });

  test('file backend writes atomically and deletes all files', () async {
    final dir = await Directory.systemTemp.createTemp('erstmal_test');
    addTearDown(() => dir.delete(recursive: true));
    final backend = FileStoreBackend(dir);
    final store = LocalStore(backend);
    await store.save(sample());
    expect(File('${dir.path}/user_state.json').existsSync(), isTrue);
    expect(File('${dir.path}/user_state.json.tmp').existsSync(), isFalse);
    expect((await store.load()).state.profile!.plansToWork, isTrue);
    await backend.quarantine('bad');
    await store.deleteAll();
    expect(dir.listSync(), isEmpty);
  });
}
