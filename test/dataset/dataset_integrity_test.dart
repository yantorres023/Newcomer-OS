import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/domain/dataset.dart';
import 'package:newcomer_os/domain/dataset_validator.dart';

import '../support/fixtures.dart';

/// Content integrity is treated like code integrity: these run in CI.
void main() {
  final validator = DatasetValidator();

  group('bundled dataset', () {
    late RoadmapDataset ds;
    setUpAll(() => ds = loadRealDataset());

    test('passes all validation checks', () {
      final report = validator.validate(ds);
      expect(report.errors, isEmpty, reason: report.toString());
    });

    test('manifest points to this dataset and version', () {
      final manifest = readJson('assets/roadmaps/manifest.json');
      final entry = (manifest['datasets'] as List)
          .cast<Map<String, Object?>>()
          .firstWhere((d) => d['id'] == manifest['active_dataset']);
      expect(entry['version'], ds.version);
      expect(File(entry['rules'] as String).existsSync(), isTrue);
      expect(File(entry['sources'] as String).existsSync(), isTrue);
    });

    test('every rule has an id, source, authority and verification date', () {
      for (final rule in ds.rules) {
        expect(rule.id, isNotEmpty);
        expect(rule.sources, isNotEmpty, reason: rule.id);
        for (final ref in rule.sources) {
          final src = ds.sources[ref.sourceId];
          expect(src, isNotNull, reason: '${rule.id} → ${ref.sourceId}');
          expect(src!.authority, isNotEmpty);
          expect(src.url, startsWith('https://'));
        }
        expect(rule.lastVerifiedAt.isAfter(ds.releasedAt), isFalse);
      }
    });

    test('no duplicate rule or source ids', () {
      final ids = ds.rules.map((r) => r.id).toList();
      expect(ids.toSet().length, ids.length);
      final rawSources = (readJson(sourcesPath)['sources'] as List)
          .map((s) => (s as Map)['id'])
          .toList();
      expect(rawSources.toSet().length, rawSources.length);
    });

    test('every source is used by at least one rule or dependency', () {
      final used = {
        for (final r in ds.rules) ...r.sources.map((s) => s.sourceId),
        for (final r in ds.rules)
          ...r.dependsOn.map((d) => d.evidenceSourceId).whereType<String>(),
      };
      expect(ds.sources.keys.toSet().difference(used), isEmpty);
    });

    test('all required languages present for every rule and document', () {
      for (final rule in ds.rules) {
        for (final lang in ds.languages) {
          final c = rule.content[lang];
          expect(c, isNotNull, reason: '${rule.id} $lang');
          expect(c!.title.trim(), isNotEmpty);
          expect(c.steps, isNotEmpty);
        }
      }
      for (final doc in ds.documents.entries) {
        for (final lang in ds.languages) {
          expect(doc.value[lang], isNotNull, reason: '${doc.key} $lang');
        }
      }
    });

    test('official titles are marked with their original language', () {
      for (final s in ds.sources.values) {
        expect(['de', 'en'], contains(s.titleLanguage), reason: s.id);
      }
    });

    test('store-copy guardrail: no forbidden claims in content', () {
      final text = File(rulesPath).readAsStringSync().toLowerCase();
      for (final phrase in [
        'guarantee',
        'garantiert',
        'official app',
        'government approved',
        'never miss',
      ]) {
        expect(text.contains(phrase), isFalse, reason: phrase);
      }
    });
  });

  group('validator rejects broken datasets', () {
    ValidationReport validateMutated(
      void Function(Map<String, Object?> rules) mutate, {
      void Function(Map<String, Object?> sources)? mutateSources,
    }) {
      final rules = clone(readJson(rulesPath));
      final sources = clone(readJson(sourcesPath));
      mutate(rules);
      mutateSources?.call(sources);
      return validator.validate(datasetFrom(rules, sources));
    }

    void expectError(ValidationReport r, String fragment) => expect(
      r.errors.any((e) => e.contains(fragment)),
      isTrue,
      reason: 'expected "$fragment" in ${r.errors}',
    );

    test('duplicate rule id', () {
      final r = validateMutated((j) {
        final list = j['rules'] as List;
        list.add(clone(list.first as Map<String, Object?>));
      });
      expectError(r, 'Duplicate rule id');
    });

    test('active rule without source', () {
      final r = validateMutated(
        (j) => ruleIn(j, 'de.tax.tax_id_letter')['sources'] = [],
      );
      expectError(r, 'active rule without source');
    });

    test('unknown source reference', () {
      final r = validateMutated(
        (j) => ruleIn(j, 'de.tax.tax_id_letter')['sources'] = [
          {'source_id': 'src.nope'},
        ],
      );
      expectError(r, 'unknown source src.nope');
    });

    test('dependency to missing rule', () {
      final r = validateMutated(
        (j) => ruleIn(j, 'de.tax.tax_id_letter')['depends_on'] = [
          {
            'rule_id': 'de.nope.nope',
            'type': 'requires',
            'evidence_source_id': 'src.bzst.idnr',
          },
        ],
      );
      expectError(r, 'does not exist');
    });

    test('hard dependency without evidence', () {
      final r = validateMutated(
        (j) => ruleIn(j, 'de.tax.tax_id_letter')['depends_on'] = [
          {'rule_id': 'de.registration.anmeldung', 'type': 'requires'},
        ],
      );
      expectError(r, 'needs evidence');
    });

    test('dependency cycle', () {
      final r = validateMutated(
        (j) => ruleIn(j, 'de.housing.landlord_confirmation')['depends_on'] = [
          {
            'rule_id': 'de.registration.anmeldung',
            'type': 'requires',
            'evidence_source_id': 'src.bmg.17',
          },
        ],
      );
      expectError(r, 'cycle');
    });

    test('missing translation', () {
      final r = validateMutated(
        (j) =>
            (ruleIn(j, 'de.tax.tax_id_letter')['content'] as Map).remove('de'),
      );
      expectError(r, 'missing "de" content');
    });

    test('effective dates in wrong order', () {
      final r = validateMutated((j) {
        final rule = ruleIn(j, 'de.tax.tax_id_letter');
        rule['effective_from'] = '2026-01-01';
        rule['effective_until'] = '2025-01-01';
      });
      expectError(r, 'effective_until before effective_from');
    });

    test(
      'verification date after release',
      () => expectError(
        validateMutated(
          (j) => ruleIn(j, 'de.tax.tax_id_letter')['last_verified_at'] =
              '2099-01-01',
        ),
        'after release',
      ),
    );

    test(
      'unknown profile field in condition',
      () => expectError(
        validateMutated(
          (j) => ruleIn(j, 'de.tax.tax_id_letter')['applies_to'] = {
            'field': 'nationality',
            'eq': 'IN',
          },
        ),
        'unknown field nationality',
      ),
    );

    test(
      'non-https source url',
      () => expectError(
        validateMutated(
          (_) {},
          mutateSources: (s) => ((s['sources'] as List).first as Map)['url'] =
              'http://example.com',
        ),
        'https',
      ),
    );

    test(
      'legal deadline without statute or city source',
      () => expectError(
        validateMutated(
          (j) => ruleIn(j, 'de.registration.anmeldung')['sources'] = [
            {'source_id': 'src.daad.enrolment'},
          ],
        ),
        'legal deadline',
      ),
    );

    test(
      'city-specific sources must still cover every profile',
      () => expectError(
        validateMutated(
          (j) => ruleIn(j, 'de.residence.permit_application')['sources'] = [
            {
              'source_id': 'src.berlin.study_permit',
              'when': {'field': 'city', 'eq': 'berlin'},
            },
          ],
        ),
        'no source for profile',
      ),
    );

    test(
      'unknown timing anchor',
      () => expectError(
        validateMutated(
          (j) =>
              (ruleIn(j, 'de.registration.anmeldung')['timing']
                      as Map)['anchor'] =
                  'birthday',
        ),
        'not a profile date',
      ),
    );

    test(
      'superseded history entry must end before current version',
      () => expectError(
        validateMutated(
          (j) => ((j['rule_history'] as List).first as Map)['effective_until'] =
              '2025-01-01',
        ),
        'overlaps',
      ),
    );
  });

  test('structurally invalid JSON is rejected with context', () {
    final rules = clone(readJson(rulesPath));
    ruleIn(rules, 'de.tax.tax_id_letter').remove('last_verified_at');
    expect(
      () => datasetFrom(rules),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('de.tax.tax_id_letter'),
        ),
      ),
    );
    expect(() => jsonDecode('{"rules": ['), throwsFormatException);
  });
}
