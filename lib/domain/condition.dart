/// Deterministic applicability conditions for roadmap rules.
///
/// Grammar (JSON):
/// - `{"always": true}`
/// - `{"field": "city", "eq": "berlin"}`
/// - `{"field": "entry_type", "in": ["national_visa", "visa_free"]}`
/// - `{"field": "visa_expiry_date", "exists": true}`
/// - `{"all": [cond, ...]}`, `{"any": [cond, ...]}`, `{"not": cond}`
///
/// No inference or model output decides whether a rule applies; only these
/// explicit conditions evaluated against the user's profile answers.
sealed class Condition {
  const Condition();

  bool evaluate(Map<String, Object?> fields);

  /// Every profile field referenced by this condition (for validation).
  Iterable<String> get referencedFields;

  static Condition parse(Object? json) {
    if (json is! Map<String, Object?>) {
      throw const FormatException('Condition must be an object');
    }
    if (json.containsKey('always')) {
      if (json['always'] != true) {
        throw const FormatException('"always" must be true');
      }
      return const AlwaysCondition();
    }
    if (json.containsKey('all')) {
      return AllCondition(_parseList(json['all']));
    }
    if (json.containsKey('any')) {
      return AnyCondition(_parseList(json['any']));
    }
    if (json.containsKey('not')) {
      return NotCondition(parse(json['not']));
    }
    final field = json['field'];
    if (field is! String || field.isEmpty) {
      throw FormatException('Condition without valid "field": $json');
    }
    if (json.containsKey('eq')) {
      return EqualsCondition(field, json['eq']);
    }
    if (json.containsKey('in')) {
      final values = json['in'];
      if (values is! List || values.isEmpty) {
        throw FormatException('"in" must be a non-empty list: $json');
      }
      return InCondition(field, List<Object?>.unmodifiable(values));
    }
    if (json.containsKey('exists')) {
      return ExistsCondition(field, json['exists'] == true);
    }
    throw FormatException('Unknown condition operator: $json');
  }

  static List<Condition> _parseList(Object? json) {
    if (json is! List || json.isEmpty) {
      throw const FormatException('Condition list must be non-empty');
    }
    return List.unmodifiable(json.map(parse));
  }
}

class AlwaysCondition extends Condition {
  const AlwaysCondition();
  @override
  bool evaluate(Map<String, Object?> fields) => true;
  @override
  Iterable<String> get referencedFields => const [];
}

class AllCondition extends Condition {
  const AllCondition(this.children);
  final List<Condition> children;
  @override
  bool evaluate(Map<String, Object?> fields) =>
      children.every((c) => c.evaluate(fields));
  @override
  Iterable<String> get referencedFields =>
      children.expand((c) => c.referencedFields);
}

class AnyCondition extends Condition {
  const AnyCondition(this.children);
  final List<Condition> children;
  @override
  bool evaluate(Map<String, Object?> fields) =>
      children.any((c) => c.evaluate(fields));
  @override
  Iterable<String> get referencedFields =>
      children.expand((c) => c.referencedFields);
}

class NotCondition extends Condition {
  const NotCondition(this.child);
  final Condition child;
  @override
  bool evaluate(Map<String, Object?> fields) => !child.evaluate(fields);
  @override
  Iterable<String> get referencedFields => child.referencedFields;
}

class EqualsCondition extends Condition {
  const EqualsCondition(this.field, this.value);
  final String field;
  final Object? value;
  @override
  bool evaluate(Map<String, Object?> fields) => fields[field] == value;
  @override
  Iterable<String> get referencedFields => [field];
}

class InCondition extends Condition {
  const InCondition(this.field, this.values);
  final String field;
  final List<Object?> values;
  @override
  bool evaluate(Map<String, Object?> fields) => values.contains(fields[field]);
  @override
  Iterable<String> get referencedFields => [field];
}

class ExistsCondition extends Condition {
  const ExistsCondition(this.field, this.shouldExist);
  final String field;
  final bool shouldExist;
  @override
  bool evaluate(Map<String, Object?> fields) =>
      (fields[field] != null) == shouldExist;
  @override
  Iterable<String> get referencedFields => [field];
}
