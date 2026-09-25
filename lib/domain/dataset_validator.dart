import 'dataset.dart';
import 'local_date.dart';
import 'profile.dart';

class ValidationReport {
  ValidationReport(this.errors, this.warnings);
  final List<String> errors;
  final List<String> warnings;
  bool get isValid => errors.isEmpty;

  @override
  String toString() =>
      'errors:\n  ${errors.join('\n  ')}\nwarnings:\n  ${warnings.join('\n  ')}';
}

/// Integrity checks for a roadmap dataset. Treat content like code: the app
/// refuses to show a dataset that fails these checks, and CI runs them.
class DatasetValidator {
  DatasetValidator({this.maxSourceAgeDays = 180});

  /// Sources older than this (relative to the release date) are warnings.
  final int maxSourceAgeDays;

  ValidationReport validate(RoadmapDataset ds) {
    final errors = <String>[];
    final warnings = <String>[];

    if (!ds.languages.contains(ds.defaultLanguage)) {
      errors.add('default_language ${ds.defaultLanguage} not in languages');
    }

    final ids = <String>{};
    for (final rule in ds.rules) {
      if (!ids.add(rule.id)) errors.add('Duplicate rule id ${rule.id}');
    }

    for (final entry in ds.documents.entries) {
      for (final lang in ds.languages) {
        if ((entry.value[lang] ?? '').isEmpty) {
          errors.add('Document ${entry.key} missing "$lang" name');
        }
      }
    }

    for (final source in ds.sources.values) {
      final uri = Uri.tryParse(source.url);
      if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
        errors.add('Source ${source.id} URL must be absolute https');
      }
      if (source.lastVerifiedAt.isAfter(ds.releasedAt)) {
        errors.add('Source ${source.id} verified after release date');
      }
      if (source.lastVerifiedAt.daysUntil(ds.releasedAt) > maxSourceAgeDays) {
        warnings.add('Source ${source.id} is stale (> $maxSourceAgeDays days)');
      }
      if (source.verificationMethod != VerificationMethod.directFetch &&
          source.verificationMethod != VerificationMethod.manual) {
        warnings.add('Source ${source.id} not verified by direct reading');
      }
    }

    for (final rule in ds.rules) {
      _validateRule(ds, rule, ids, errors, warnings);
    }

    _checkCycles(ds, errors);
    _checkSourceCoverage(ds, errors);

    for (final h in ds.ruleHistory) {
      final current = ds.ruleById(h.id);
      if (current == null) {
        errors.add('History entry ${h.id} v${h.version} has no current rule');
      } else if (h.version >= current.version) {
        errors.add(
          'History entry ${h.id} v${h.version} not older than '
          'current v${current.version}',
        );
      }
      if (h.status == RuleStatus.superseded && h.effectiveUntil == null) {
        errors.add('Superseded ${h.id} v${h.version} needs effective_until');
      }
      if (current != null &&
          h.effectiveUntil != null &&
          current.effectiveFrom != null &&
          !h.effectiveUntil!.isBefore(current.effectiveFrom!)) {
        errors.add('History ${h.id} v${h.version} overlaps current version');
      }
    }

    return ValidationReport(errors, warnings);
  }

  void _validateRule(
    RoadmapDataset ds,
    RuleDefinition rule,
    Set<String> ids,
    List<String> errors,
    List<String> warnings,
  ) {
    final p = 'Rule ${rule.id}';
    if (!RegExp(r'^[a-z]{2}\.[a-z0-9_]+\.[a-z0-9_]+$').hasMatch(rule.id)) {
      errors.add('$p: id must look like "de.category.name"');
    }
    if (rule.version < 1) errors.add('$p: version must be >= 1');

    if (rule.status == RuleStatus.active && rule.sources.isEmpty) {
      errors.add('$p: active rule without source');
    }
    for (final ref in rule.sources) {
      final source = ds.sources[ref.sourceId];
      if (source == null) {
        errors.add('$p: unknown source ${ref.sourceId}');
      } else if (source.authority.trim().isEmpty) {
        errors.add('$p: source ${ref.sourceId} has no authority');
      }
      for (final f in ref.when?.referencedFields ?? const <String>[]) {
        if (!UserProfile.conditionFieldNames.contains(f)) {
          errors.add('$p: source condition uses unknown field $f');
        }
      }
    }
    if (rule.isOfficial &&
        !rule.sources.any(
          (r) => ds.sources[r.sourceId]?.isGovernment ?? false,
        ) &&
        !rule.sources.any(
          (r) =>
              ds.sources[r.sourceId]?.authorityType == AuthorityType.publicBody,
        )) {
      errors.add('$p: official rule needs a government or public-body source');
    }

    for (final f in rule.appliesTo.referencedFields) {
      if (!UserProfile.conditionFieldNames.contains(f)) {
        errors.add('$p: applies_to uses unknown field $f');
      }
    }

    if (rule.lastVerifiedAt.isAfter(ds.releasedAt)) {
      errors.add('$p: last_verified_at after release date');
    }
    if (rule.effectiveFrom != null &&
        rule.effectiveUntil != null &&
        rule.effectiveUntil!.isBefore(rule.effectiveFrom!)) {
      errors.add('$p: effective_until before effective_from');
    }
    if (rule.status == RuleStatus.active &&
        rule.effectiveUntil != null &&
        rule.effectiveUntil!.isBefore(ds.releasedAt)) {
      errors.add('$p: active rule already expired at release');
    }

    for (final lang in ds.languages) {
      final c = rule.content[lang];
      if (c == null) {
        errors.add('$p: missing "$lang" content');
      } else if (c.steps.isEmpty) {
        errors.add('$p: "$lang" content has no steps');
      }
      if (rule.professionalHelp.isNotEmpty &&
          (rule.professionalHelp[lang] ?? '').isEmpty) {
        errors.add('$p: professional_help missing "$lang"');
      }
    }
    final stepCounts = rule.content.values.map((c) => c.steps.length).toSet();
    if (stepCounts.length > 1) {
      warnings.add('$p: languages have different step counts');
    }

    for (final doc in rule.requiredDocuments) {
      if (!ds.documents.containsKey(doc.documentId)) {
        errors.add('$p: unknown document ${doc.documentId}');
      }
    }

    for (final dep in rule.dependsOn) {
      if (dep.ruleId == rule.id) errors.add('$p: depends on itself');
      if (!ids.contains(dep.ruleId)) {
        errors.add('$p: dependency ${dep.ruleId} does not exist');
      }
      if (dep.type == DependencyType.requires) {
        if (dep.evidenceSourceId == null) {
          errors.add('$p: hard dependency ${dep.ruleId} needs evidence');
        } else if (!ds.sources.containsKey(dep.evidenceSourceId)) {
          errors.add('$p: evidence ${dep.evidenceSourceId} unknown');
        }
      }
    }

    final t = rule.timing;
    if (t.anchor != null) {
      final anchor = t.anchor!;
      if (anchor.startsWith(Timing.completedPrefix)) {
        final target = anchor.substring(Timing.completedPrefix.length);
        if (!ids.contains(target)) {
          errors.add('$p: timing anchor rule $target does not exist');
        }
      } else if (!UserProfile.dateFieldNames.contains(anchor)) {
        errors.add('$p: timing anchor $anchor is not a profile date');
      }
    }
    if (t.type == TimingType.beforeAnchor && t.offsetDays > 0) {
      errors.add('$p: before_anchor offset must be <= 0');
    }
    if (t.basis == TimingBasis.legal &&
        !rule.sources.any(
          (r) =>
              ds.sources[r.sourceId]?.authorityType ==
                  AuthorityType.federalLaw ||
              ds.sources[r.sourceId]?.authorityType == AuthorityType.city,
        )) {
      errors.add('$p: legal deadline needs a statute or city source');
    }

    if (rule.supersedes != null && ids.contains(rule.supersedes)) {
      errors.add('$p: supersedes ${rule.supersedes} which is still listed');
    }
    if (rule.reviewRequired) {
      warnings.add('$p: pending human review');
    }
  }

  void _checkCycles(RoadmapDataset ds, List<String> errors) {
    final visiting = <String>{};
    final done = <String>{};
    bool visit(String id) {
      if (done.contains(id)) return true;
      if (!visiting.add(id)) return false;
      final rule = ds.ruleById(id);
      for (final dep in rule?.dependsOn ?? const <Dependency>[]) {
        if (!visit(dep.ruleId)) return false;
      }
      visiting.remove(id);
      done.add(id);
      return true;
    }

    for (final rule in ds.rules) {
      if (!visit(rule.id)) {
        errors.add('Dependency cycle involving ${rule.id}');
        return;
      }
    }
  }

  /// Every applicable active rule must resolve at least one source for every
  /// combination of categorical profile answers.
  void _checkSourceCoverage(RoadmapDataset ds, List<String> errors) {
    final reported = <String>{};
    for (final profile in allProfileCombinations(LocalDate(2026, 1, 1))) {
      final fields = profile.conditionFields;
      for (final rule in ds.rules) {
        if (rule.status != RuleStatus.active) continue;
        if (!rule.appliesTo.evaluate(fields)) continue;
        final hasSource = rule.sources.any(
          (r) => r.when == null || r.when!.evaluate(fields),
        );
        if (!hasSource && reported.add(rule.id)) {
          errors.add('Rule ${rule.id}: no source for profile $fields');
        }
      }
    }
  }
}

/// Every combination of categorical/boolean answers, with dates filled in.
/// Used for exhaustive dataset checks and tests.
Iterable<UserProfile> allProfileCombinations(LocalDate arrival) sync* {
  for (final entry in EntryType.values) {
    for (final stage in StudyStage.values) {
      for (final city in City.values) {
        for (var bits = 0; bits < 8; bits++) {
          yield UserProfile(
            entryType: entry,
            studyStage: stage,
            city: city,
            arrivalDate: arrival,
            moveInDate: arrival.addDays(3),
            visaExpiryDate: entry == EntryType.nationalVisa
                ? arrival.addDays(80)
                : null,
            permitExpiryDate: arrival.addDays(800),
            age30Plus: bits & 1 != 0,
            plansToWork: bits & 2 != 0,
            familyJoining: bits & 4 != 0,
          );
        }
      }
    }
  }
}
