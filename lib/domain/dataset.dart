import 'condition.dart';
import 'local_date.dart';

/// A bundled, versioned roadmap release: sources + rules for one corridor.
///
/// Rule definitions live here and are never mutated by user actions; user
/// progress is stored separately (see `UserState`).
class RoadmapDataset {
  const RoadmapDataset({
    required this.datasetId,
    required this.version,
    required this.releasedAt,
    required this.jurisdiction,
    required this.languages,
    required this.defaultLanguage,
    required this.documents,
    required this.sources,
    required this.rules,
    required this.ruleHistory,
  });

  final String datasetId;
  final String version;
  final LocalDate releasedAt;
  final String jurisdiction;
  final List<String> languages;
  final String defaultLanguage;
  final Map<String, Map<String, String>> documents;
  final Map<String, Source> sources;
  final List<RuleDefinition> rules;
  final List<RuleHistoryEntry> ruleHistory;

  RuleDefinition? ruleById(String id) {
    for (final rule in rules) {
      if (rule.id == id) return rule;
    }
    return null;
  }

  /// Parses the `rules.json` and `sources.json` documents.
  /// Throws [FormatException] with context on structural problems.
  factory RoadmapDataset.fromJson({
    required Map<String, Object?> rulesJson,
    required Map<String, Object?> sourcesJson,
  }) {
    final sourceList = _list(sourcesJson, 'sources');
    final sources = <String, Source>{};
    for (final raw in sourceList) {
      final source = Source.fromJson(_asMap(raw, 'source'));
      if (sources.containsKey(source.id)) {
        throw FormatException('Duplicate source id "${source.id}"');
      }
      sources[source.id] = source;
    }
    final documents = <String, Map<String, String>>{};
    final rawDocs = _asMap(rulesJson['documents'] ?? {}, 'documents');
    rawDocs.forEach((key, value) {
      documents[key] = Map<String, String>.from(_asMap(value, 'document $key'));
    });
    return RoadmapDataset(
      datasetId: _str(rulesJson, 'dataset_id'),
      version: _str(rulesJson, 'version'),
      releasedAt: LocalDate.parse(_str(rulesJson, 'released_at')),
      jurisdiction: _str(rulesJson, 'jurisdiction'),
      languages: List.unmodifiable(
        _list(rulesJson, 'languages').cast<String>(),
      ),
      defaultLanguage: _str(rulesJson, 'default_language'),
      documents: Map.unmodifiable(documents),
      sources: Map.unmodifiable(sources),
      rules: List.unmodifiable(
        _list(rulesJson, 'rules').map((raw) {
          final map = _asMap(raw, 'rule');
          try {
            return RuleDefinition.fromJson(map);
          } on FormatException catch (e) {
            throw FormatException('Rule "${map['id']}": ${e.message}');
          }
        }),
      ),
      ruleHistory: List.unmodifiable(
        ((rulesJson['rule_history'] as List?) ?? const []).map(
          (raw) => RuleHistoryEntry.fromJson(_asMap(raw, 'history')),
        ),
      ),
    );
  }
}

enum RuleStatus { active, draft, superseded, retired }

enum RuleKind { officialRequirement, officialProcess, practical, information }

enum Confidence { high, medium, low }

class RuleDefinition {
  const RuleDefinition({
    required this.id,
    required this.version,
    required this.status,
    required this.kind,
    required this.category,
    required this.order,
    required this.jurisdiction,
    required this.appliesTo,
    required this.timing,
    required this.dependsOn,
    required this.requiredDocuments,
    required this.sources,
    required this.effectiveFrom,
    required this.effectiveUntil,
    required this.lastVerifiedAt,
    required this.reviewRequired,
    required this.confidence,
    required this.officialTerms,
    required this.content,
    required this.professionalHelp,
    this.supersedes,
  });

  final String id;
  final int version;
  final RuleStatus status;
  final RuleKind kind;
  final String category;
  final int order;
  final String jurisdiction;
  final Condition appliesTo;
  final Timing timing;
  final List<Dependency> dependsOn;
  final List<RequiredDocument> requiredDocuments;
  final List<SourceRef> sources;
  final LocalDate? effectiveFrom;
  final LocalDate? effectiveUntil;
  final LocalDate lastVerifiedAt;
  final bool reviewRequired;
  final Confidence confidence;
  final List<String> officialTerms;
  final Map<String, RuleContent> content;
  final Map<String, String> professionalHelp;

  /// Id of a different rule this one replaces (completion carries over).
  final String? supersedes;

  /// Content in [language], falling back to English, then any language.
  RuleContent localized(String language) =>
      content[language] ?? content['en'] ?? content.values.first;

  bool get isOfficial =>
      kind == RuleKind.officialRequirement || kind == RuleKind.officialProcess;

  bool isEffectiveOn(LocalDate date) =>
      (effectiveFrom == null || !date.isBefore(effectiveFrom!)) &&
      (effectiveUntil == null || !date.isAfter(effectiveUntil!));

  factory RuleDefinition.fromJson(Map<String, Object?> json) {
    final contentJson = _asMap(json['content'], 'content');
    return RuleDefinition(
      id: _str(json, 'id'),
      version:
          json['version'] as int? ??
          (throw const FormatException('missing "version"')),
      status: _enumByCode(RuleStatus.values, _str(json, 'status')),
      kind: _enumByCode(RuleKind.values, _str(json, 'kind')),
      category: _str(json, 'category'),
      order: json['order'] as int? ?? 0,
      jurisdiction: _str(json, 'jurisdiction'),
      appliesTo: Condition.parse(json['applies_to']),
      timing: Timing.fromJson(_asMap(json['timing'], 'timing')),
      dependsOn: List.unmodifiable(
        ((json['depends_on'] as List?) ?? const []).map(
          (d) => Dependency.fromJson(_asMap(d, 'dependency')),
        ),
      ),
      requiredDocuments: List.unmodifiable(
        ((json['required_documents'] as List?) ?? const []).map(
          (d) => RequiredDocument.fromJson(_asMap(d, 'document')),
        ),
      ),
      sources: List.unmodifiable(
        ((json['sources'] as List?) ?? const []).map(
          (s) => SourceRef.fromJson(_asMap(s, 'source ref')),
        ),
      ),
      effectiveFrom: LocalDate.tryParse(json['effective_from'] as String?),
      effectiveUntil: LocalDate.tryParse(json['effective_until'] as String?),
      lastVerifiedAt: LocalDate.parse(_str(json, 'last_verified_at')),
      reviewRequired: json['review_required'] as bool? ?? true,
      confidence: _enumByCode(Confidence.values, _str(json, 'confidence')),
      officialTerms: List.unmodifiable(
        ((json['official_terms'] as List?) ?? const []).cast<String>(),
      ),
      content: Map.unmodifiable(
        contentJson.map(
          (lang, value) => MapEntry(
            lang,
            RuleContent.fromJson(_asMap(value, 'content.$lang')),
          ),
        ),
      ),
      professionalHelp: Map.unmodifiable(
        Map<String, String>.from(
          (json['professional_help'] as Map?) ?? const {},
        ),
      ),
      supersedes: json['supersedes'] as String?,
    );
  }
}

class RuleContent {
  const RuleContent({
    required this.title,
    required this.summary,
    required this.why,
    required this.steps,
    required this.notes,
  });

  final String title;
  final String summary;
  final String why;
  final List<String> steps;
  final String notes;

  factory RuleContent.fromJson(Map<String, Object?> json) => RuleContent(
    title: _str(json, 'title'),
    summary: _str(json, 'summary'),
    why: _str(json, 'why'),
    steps: List.unmodifiable(_list(json, 'steps').cast<String>()),
    notes: json['notes'] as String? ?? '',
  );
}

enum TimingType { afterAnchor, beforeAnchor, asap, event, none }

/// Where a date comes from: legal text, official guidance, or our suggestion.
enum TimingBasis { legal, officialGuidance, appSuggestion }

class Timing {
  const Timing({
    required this.type,
    this.anchor,
    this.offsetDays = 0,
    this.offsetMonths = 0,
    this.basis = TimingBasis.appSuggestion,
    this.suggestedStartDaysBefore,
    this.event,
  });

  final TimingType type;

  /// A profile date field (e.g. `move_in_date`) or `completed:<rule_id>`.
  final String? anchor;
  final int offsetDays;
  final int offsetMonths;
  final TimingBasis basis;
  final int? suggestedStartDaysBefore;
  final String? event;

  static const completedPrefix = 'completed:';

  factory Timing.fromJson(Map<String, Object?> json) {
    final type = _enumByCode(TimingType.values, _str(json, 'type'));
    final timing = Timing(
      type: type,
      anchor: json['anchor'] as String?,
      offsetDays: json['offset_days'] as int? ?? 0,
      offsetMonths: json['offset_months'] as int? ?? 0,
      basis: json['basis'] == null
          ? TimingBasis.appSuggestion
          : _enumByCode(TimingBasis.values, json['basis'] as String),
      suggestedStartDaysBefore: json['suggested_start_days_before'] as int?,
      event: json['event'] as String?,
    );
    if ((type == TimingType.afterAnchor || type == TimingType.beforeAnchor) &&
        timing.anchor == null) {
      throw const FormatException('anchored timing needs "anchor"');
    }
    if (type == TimingType.event && timing.event == null) {
      throw const FormatException('event timing needs "event"');
    }
    return timing;
  }
}

enum DependencyType { requires, recommendedAfter }

class Dependency {
  const Dependency({
    required this.ruleId,
    required this.type,
    this.evidenceSourceId,
  });

  final String ruleId;
  final DependencyType type;

  /// Official source that establishes a hard dependency. Soft
  /// "recommended_after" orderings are app guidance and carry none.
  final String? evidenceSourceId;

  factory Dependency.fromJson(Map<String, Object?> json) => Dependency(
    ruleId: _str(json, 'rule_id'),
    type: _enumByCode(DependencyType.values, _str(json, 'type')),
    evidenceSourceId: json['evidence_source_id'] as String?,
  );
}

/// `official`: named by an official source. `commonly_requested`: typical
/// but the authority's own list is definitive.
enum DocumentBasis { official, commonlyRequested }

class RequiredDocument {
  const RequiredDocument({required this.documentId, required this.basis});
  final String documentId;
  final DocumentBasis basis;

  factory RequiredDocument.fromJson(Map<String, Object?> json) =>
      RequiredDocument(
        documentId: _str(json, 'doc'),
        basis: _enumByCode(DocumentBasis.values, _str(json, 'basis')),
      );
}

class SourceRef {
  const SourceRef({required this.sourceId, this.when});
  final String sourceId;

  /// Optional condition selecting this source (e.g. city-specific pages).
  final Condition? when;

  factory SourceRef.fromJson(Map<String, Object?> json) => SourceRef(
    sourceId: _str(json, 'source_id'),
    when: json['when'] == null ? null : Condition.parse(json['when']),
  );
}

enum AuthorityType {
  federalLaw,
  federalMinistry,
  federalAgency,
  federalPortal,
  city,
  publicBody,
  university,
}

enum VerificationMethod { directFetch, searchIndex, manual }

class Source {
  const Source({
    required this.id,
    required this.title,
    required this.titleLanguage,
    required this.authority,
    required this.authorityType,
    required this.url,
    required this.lastVerifiedAt,
    required this.verificationMethod,
    required this.verifiedClaims,
  });

  final String id;
  final String title;
  final String titleLanguage;
  final String authority;
  final AuthorityType authorityType;
  final String url;
  final LocalDate lastVerifiedAt;
  final VerificationMethod verificationMethod;
  final List<String> verifiedClaims;

  /// True for government bodies; false for publicly funded organisations
  /// such as DAAD or the broadcasting-fee service, which the UI labels
  /// differently.
  bool get isGovernment => switch (authorityType) {
    AuthorityType.federalLaw ||
    AuthorityType.federalMinistry ||
    AuthorityType.federalAgency ||
    AuthorityType.federalPortal ||
    AuthorityType.city => true,
    AuthorityType.publicBody || AuthorityType.university => false,
  };

  factory Source.fromJson(Map<String, Object?> json) => Source(
    id: _str(json, 'id'),
    title: _str(json, 'title'),
    titleLanguage: _str(json, 'title_language'),
    authority: _str(json, 'authority'),
    authorityType: _enumByCode(
      AuthorityType.values,
      _str(json, 'authority_type'),
    ),
    url: _str(json, 'url'),
    lastVerifiedAt: LocalDate.parse(_str(json, 'last_verified_at')),
    verificationMethod: _enumByCode(
      VerificationMethod.values,
      _str(json, 'verification_method'),
    ),
    verifiedClaims: List.unmodifiable(
      ((json['verified_claims'] as List?) ?? const []).cast<String>(),
    ),
  );
}

class RuleHistoryEntry {
  const RuleHistoryEntry({
    required this.id,
    required this.version,
    required this.status,
    required this.supersededByVersion,
    required this.effectiveUntil,
    required this.summary,
  });

  final String id;
  final int version;
  final RuleStatus status;
  final int? supersededByVersion;
  final LocalDate? effectiveUntil;
  final String summary;

  factory RuleHistoryEntry.fromJson(Map<String, Object?> json) =>
      RuleHistoryEntry(
        id: _str(json, 'id'),
        version: json['version'] as int,
        status: _enumByCode(RuleStatus.values, _str(json, 'status')),
        supersededByVersion: json['superseded_by_version'] as int?,
        effectiveUntil: LocalDate.tryParse(json['effective_until'] as String?),
        summary: json['summary_en'] as String? ?? '',
      );
}

// ---- JSON helpers ----------------------------------------------------------

String _str(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('missing or empty "$key"');
  }
  return value;
}

List<Object?> _list(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! List) throw FormatException('"$key" must be a list');
  return value;
}

Map<String, Object?> _asMap(Object? value, String what) {
  if (value is Map<String, Object?>) return value;
  if (value is Map) return Map<String, Object?>.from(value);
  throw FormatException('$what must be an object');
}

/// Maps snake_case JSON codes (`official_requirement`) to camelCase enums.
T _enumByCode<T extends Enum>(List<T> values, String code) {
  final camel = code.replaceAllMapped(
    RegExp(r'_([a-z])'),
    (m) => m.group(1)!.toUpperCase(),
  );
  for (final value in values) {
    if (value.name == camel) return value;
  }
  throw FormatException('Unknown value "$code"');
}
