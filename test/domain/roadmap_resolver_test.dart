import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/domain/dataset.dart';
import 'package:newcomer_os/domain/dataset_validator.dart';
import 'package:newcomer_os/domain/local_date.dart';
import 'package:newcomer_os/domain/profile.dart';
import 'package:newcomer_os/domain/roadmap_resolver.dart';
import 'package:newcomer_os/domain/user_state.dart';

import '../support/fixtures.dart';

void main() {
  late RoadmapDataset ds;
  setUpAll(() => ds = loadRealDataset());
  const resolver = RoadmapResolver();

  Roadmap resolve(
    UserProfile p, {
    UserState state = const UserState(),
    LocalDate? today,
    String language = 'en',
    RoadmapDataset? dataset,
  }) => resolver.resolve(
    dataset: dataset ?? ds,
    profile: p,
    state: state,
    today: today ?? arrival,
    language: language,
  );

  Set<String> ids(Roadmap r) => r.tasks.map((t) => t.id).toSet();

  UserState completed(Map<String, (int, LocalDate)> items) => UserState(
    completions: {
      for (final e in items.entries)
        e.key: CompletionRecord(
          ruleId: e.key,
          ruleVersion: e.value.$1,
          completedOn: e.value.$2,
        ),
    },
  );

  group('applicability', () {
    test('national-visa student gets permit + fictional certificate', () {
      final r = resolve(profile());
      expect(
        ids(r),
        containsAll([
          'de.registration.anmeldung',
          'de.residence.permit_application',
          'de.residence.fiktionsbescheinigung',
          'de.insurance.health_insurance',
          'de.broadcast.rundfunkbeitrag',
        ]),
      );
      expect(
        ids(r),
        isNot(contains('de.residence.permit_application_visa_free')),
      );
      expect(ids(r), isNot(contains('de.work.limits')));
    });

    test('visa-free entrant gets the three-month rule instead', () {
      final r = resolve(profile(entry: EntryType.visaFree));
      expect(ids(r), contains('de.residence.permit_application_visa_free'));
      expect(ids(r), isNot(contains('de.residence.permit_application')));
      expect(ids(r), isNot(contains('de.residence.fiktionsbescheinigung')));
    });

    test('EU citizen gets no residence-permit or insurance tasks', () {
      final r = resolve(profile(entry: EntryType.euEeaCh, work: true));
      expect(ids(r).where((id) => id.startsWith('de.residence.')), isEmpty);
      expect(ids(r), isNot(contains('de.insurance.health_insurance')));
      expect(ids(r), isNot(contains('de.work.limits')));
      expect(ids(r), contains('de.work.social_insurance_number'));
      expect(ids(r), contains('de.registration.anmeldung'));
    });

    test('optional answers add specific tasks', () {
      final base = ids(resolve(profile()));
      final all = ids(resolve(profile(age30: true, work: true, family: true)));
      expect(all.difference(base), {
        'de.insurance.over_30',
        'de.work.limits',
        'de.work.social_insurance_number',
        'de.family.dependants',
      });
    });

    test('find-authority task only for cities without a pack', () {
      expect(
        ids(resolve(profile(city: City.other))),
        contains('de.residence.find_authority'),
      );
      expect(
        ids(resolve(profile(city: City.munich))),
        isNot(contains('de.residence.find_authority')),
      );
    });

    test('every profile combination resolves with sources for every task', () {
      for (final p in allProfileCombinations(arrival)) {
        final r = resolve(p);
        expect(r.tasks, isNotEmpty);
        for (final t in r.tasks) {
          expect(t.sources, isNotEmpty, reason: '${t.id} ${p.toJson()}');
        }
        // Deterministic: same input, same output.
        expect(resolve(p).tasks.map((t) => t.id), r.tasks.map((t) => t.id));
      }
    });
  });

  group('city-specific sources', () {
    String firstSource(UserProfile p, String ruleId) =>
        resolve(p).byId(ruleId)!.sources.first.id;

    test('Berlin, Munich degree, Munich prep, other', () {
      const id = 'de.residence.permit_application';
      expect(
        firstSource(profile(city: City.berlin), id),
        'src.berlin.study_permit',
      );
      expect(
        firstSource(profile(city: City.munich), id),
        'src.muenchen.study_permit',
      );
      expect(
        firstSource(
          profile(city: City.munich, stage: StudyStage.preparatory),
          id,
        ),
        'src.muenchen.prep_permit',
      );
      expect(firstSource(profile(city: City.other), id), 'src.bamf.navi');
    });

    test('federal statute always included for registration', () {
      for (final city in City.values) {
        final srcs = resolve(profile(city: city))
            .byId('de.registration.anmeldung')!
            .sources
            .map((s) => s.id);
        expect(srcs, contains('src.bmg.17'));
      }
    });
  });

  group('deadlines', () {
    test('registration: two weeks after moving in', () {
      final r = resolve(profile(moveIn: LocalDate(2026, 10, 5)));
      final t = r.byId('de.registration.anmeldung')!;
      expect(t.dueDate, LocalDate(2026, 10, 19));
      expect(t.rule.timing.basis, TimingBasis.legal);
      expect(t.bucket, TaskBucket.upcoming); // blocked by landlord confirmation
    });

    test('missing move-in date asks for it instead of inventing a date', () {
      final t = resolve(profile()).byId('de.registration.anmeldung')!;
      expect(t.dueDate, isNull);
      expect(t.missingAnchor, 'move_in_date');
      final landlord = resolve(profile())
          .byId('de.housing.landlord_confirmation')!;
      expect(landlord.bucket, TaskBucket.today);
    });

    test('residence permit: day before visa ends, start 8 weeks earlier', () {
      final r = resolve(profile(visaExpiry: LocalDate(2026, 12, 31)));
      final t = r.byId('de.residence.permit_application')!;
      expect(t.dueDate, LocalDate(2026, 12, 30));
      expect(t.suggestedStart, LocalDate(2026, 11, 4));
    });

    test('visa-free: three calendar months after arrival', () {
      final r = resolve(
        profile(
          entry: EntryType.visaFree,
          arrivalDate: LocalDate(2026, 11, 30),
        ),
      );
      expect(
        r.byId('de.residence.permit_application_visa_free')!.dueDate,
        LocalDate(2027, 2, 28),
      );
    });

    test('changing arrival/move-in date moves the deadline', () {
      final a = resolve(profile(moveIn: LocalDate(2026, 10, 1)));
      final b = resolve(profile(moveIn: LocalDate(2026, 10, 20)));
      expect(
        a.byId('de.registration.anmeldung')!.dueDate,
        LocalDate(2026, 10, 15),
      );
      expect(
        b.byId('de.registration.anmeldung')!.dueDate,
        LocalDate(2026, 11, 3),
      );
    });

    test('tax-id follow-up counts from registration completion', () {
      final state = completed({
        'de.housing.landlord_confirmation': (1, LocalDate(2026, 10, 2)),
        'de.registration.anmeldung': (1, LocalDate(2026, 10, 6)),
      });
      final t = resolve(profile(), state: state).byId('de.tax.tax_id_letter')!;
      expect(t.dueDate, LocalDate(2027, 1, 4));
      expect(t.blockedBy, isEmpty);
      expect(t.missingAnchor, isNull);
    });

    test('overdue is flagged and sorted first', () {
      final r = resolve(
        profile(moveIn: LocalDate(2026, 10, 1)),
        state: completed({
          'de.housing.landlord_confirmation': (1, LocalDate(2026, 10, 1)),
        }),
        today: LocalDate(2026, 10, 20),
      );
      final t = r.byId('de.registration.anmeldung')!;
      expect(t.urgency, Urgency.overdue);
      expect(t.bucket, TaskBucket.today);
      expect(r.bucket(TaskBucket.today).first.id, t.id);
    });

    test('due within 14 days goes to Today; later goes to Upcoming', () {
      final soon = resolve(
        profile(visaExpiry: LocalDate(2026, 10, 10)),
        state: completed({'de.insurance.health_insurance': (1, arrival)}),
      ).byId('de.residence.permit_application')!;
      expect(soon.bucket, TaskBucket.today);
      final later = resolve(
        profile(visaExpiry: LocalDate(2027, 6, 1)),
        state: completed({'de.insurance.health_insurance': (1, arrival)}),
      ).byId('de.residence.permit_application')!;
      expect(later.bucket, TaskBucket.upcoming);
    });

    test('renewal deadline appears once card expiry is known', () {
      final without = resolve(profile()).byId('de.residence.permit_renewal')!;
      expect(without.missingAnchor, 'permit_expiry_date');
      final withDate = resolve(profile(permitExpiry: LocalDate(2028, 10, 1)))
          .byId('de.residence.permit_renewal')!;
      expect(withDate.dueDate, LocalDate(2028, 9, 30));
    });
  });

  group('dependencies', () {
    test('hard dependency blocks until done, then unblocks', () {
      final before = resolve(profile()).byId('de.university.enrolment')!;
      expect(before.blockedBy.map((r) => r.id), [
        'de.insurance.health_insurance',
      ]);
      expect(before.bucket, TaskBucket.upcoming);
      final after = resolve(
        profile(),
        state: completed({'de.insurance.health_insurance': (1, arrival)}),
      ).byId('de.university.enrolment')!;
      expect(after.blockedBy, isEmpty);
      expect(after.bucket, TaskBucket.today);
    });

    test('soft ordering never blocks', () {
      final t = resolve(
        profile(),
        state: completed({'de.insurance.health_insurance': (1, arrival)}),
      ).byId('de.residence.permit_application')!;
      expect(t.blockedBy, isEmpty);
      expect(
        t.recommendedAfter.map((r) => r.id),
        contains('de.registration.anmeldung'),
      );
    });

    test('dependencies on rules that do not apply are ignored', () {
      // collect_card depends on both permit variants; only one applies.
      final state = completed({
        'de.insurance.health_insurance': (1, arrival),
        'de.residence.permit_application': (1, arrival),
      });
      final t = resolve(
        profile(),
        state: state,
      ).byId('de.residence.collect_card')!;
      expect(t.blockedBy, isEmpty);
    });
  });

  group('state edge cases', () {
    test('profile no longer qualifies: completed task stays in Done', () {
      final state = completed({'de.work.limits': (2, arrival)});
      final r = resolve(profile(work: false), state: state);
      final t = r.byId('de.work.limits')!;
      expect(t.stillApplies, isFalse);
      expect(t.bucket, TaskBucket.done);
      expect(r.totalCount, resolve(profile(work: false)).totalCount);
    });

    test('non-applicable uncompleted tasks disappear', () {
      expect(resolve(profile(work: false)).byId('de.work.limits'), isNull);
    });

    test('task completed before rule update is flagged', () {
      final state = completed({'de.work.limits': (1, arrival)});
      final t = resolve(
        profile(work: true),
        state: state,
      ).byId('de.work.limits')!;
      expect(t.isCompleted, isTrue);
      expect(t.updatedSinceCompletion, isTrue);
    });

    test('superseding rule inherits completion and is flagged', () {
      final rules = clone(readJson(rulesPath));
      final rule = ruleIn(rules, 'de.tax.tax_id_letter');
      rule['id'] = 'de.tax.tax_id_letter_v2';
      rule['supersedes'] = 'de.tax.tax_id_letter';
      final dataset = datasetFrom(rules);
      expect(DatasetValidator().validate(dataset).errors, isEmpty);
      final state = completed({'de.tax.tax_id_letter': (1, arrival)});
      final t = resolve(
        profile(),
        state: state,
        dataset: dataset,
      ).byId('de.tax.tax_id_letter_v2')!;
      expect(t.isCompleted, isTrue);
      expect(t.updatedSinceCompletion, isTrue);
    });

    test('completion of a rule no longer in the dataset is ignored', () {
      final state = completed({'de.removed.rule': (1, arrival)});
      expect(resolve(profile(), state: state).byId('de.removed.rule'), isNull);
    });

    test('rules outside their effective window are excluded', () {
      final rules = clone(readJson(rulesPath));
      ruleIn(rules, 'de.tax.tax_id_letter')['effective_from'] = '2027-01-01';
      final r = resolve(profile(), dataset: datasetFrom(rules));
      expect(r.byId('de.tax.tax_id_letter'), isNull);
      final later = resolve(
        profile(),
        dataset: datasetFrom(rules),
        today: LocalDate(2027, 1, 1),
      );
      expect(later.byId('de.tax.tax_id_letter'), isNotNull);
    });

    test('draft and retired rules are never shown', () {
      final rules = clone(readJson(rulesPath));
      ruleIn(rules, 'de.tax.tax_id_letter')['status'] = 'draft';
      ruleIn(rules, 'de.broadcast.rundfunkbeitrag')['status'] = 'retired';
      final r = resolve(profile(), dataset: datasetFrom(rules));
      expect(r.byId('de.tax.tax_id_letter'), isNull);
      expect(r.byId('de.broadcast.rundfunkbeitrag'), isNull);
    });
  });

  group('localization', () {
    test('German content is used when requested', () {
      final t = resolve(
        profile(),
        language: 'de',
      ).byId('de.registration.anmeldung')!;
      expect(t.content.title, 'Wohnsitz anmelden (Anmeldung)');
      expect(t.usedFallbackLanguage, isFalse);
    });

    test('missing translation falls back to English and says so', () {
      final rules = clone(readJson(rulesPath));
      (ruleIn(rules, 'de.tax.tax_id_letter')['content'] as Map).remove('de');
      final t = resolve(
        profile(),
        language: 'de',
        dataset: datasetFrom(rules),
      ).byId('de.tax.tax_id_letter')!;
      expect(t.usedFallbackLanguage, isTrue);
      expect(t.content.title, 'Watch for your tax ID letter');
    });

    test('unsupported language falls back to English', () {
      final t = resolve(
        profile(),
        language: 'hi',
      ).byId('de.registration.anmeldung')!;
      expect(t.contentLanguage, 'en');
    });
  });

  test('progress excludes event tasks and counts completions', () {
    final r = resolve(
      profile(),
      state: completed({'de.insurance.health_insurance': (1, arrival)}),
    );
    expect(r.completedCount, 1);
    expect(
      r.totalCount,
      r.tasks.where((t) => t.rule.timing.type != TimingType.event).length,
    );
    expect(r.bucket(TaskBucket.whenItHappens).map((t) => t.id).toSet(), {
      'de.registration.re_register_on_move',
      'de.registration.deregister_on_leaving',
    });
  });
}
