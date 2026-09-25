import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/domain/condition.dart';

void main() {
  final fields = {'city': 'berlin', 'plans_to_work': true, 'visa': null};

  test('leaf operators', () {
    expect(Condition.parse({'always': true}).evaluate(fields), isTrue);
    expect(
      Condition.parse({'field': 'city', 'eq': 'berlin'}).evaluate(fields),
      isTrue,
    );
    expect(
      Condition.parse({
        'field': 'city',
        'in': ['munich', 'other'],
      }).evaluate(fields),
      isFalse,
    );
    expect(
      Condition.parse({'field': 'visa', 'exists': true}).evaluate(fields),
      isFalse,
    );
    expect(
      Condition.parse({'field': 'visa', 'exists': false}).evaluate(fields),
      isTrue,
    );
  });

  test('combinators', () {
    final c = Condition.parse({
      'all': [
        {'field': 'plans_to_work', 'eq': true},
        {
          'any': [
            {'field': 'city', 'eq': 'munich'},
            {
              'not': {'field': 'city', 'eq': 'other'},
            },
          ],
        },
      ],
    });
    expect(c.evaluate(fields), isTrue);
    expect(c.referencedFields.toSet(), {'plans_to_work', 'city'});
  });

  test('missing field never matches eq', () {
    expect(
      Condition.parse({'field': 'nope', 'eq': 'x'}).evaluate(fields),
      isFalse,
    );
  });

  test('rejects malformed conditions', () {
    for (final bad in [
      'string',
      {'always': false},
      {'all': []},
      {'field': 'city'},
      {'field': '', 'eq': 1},
      {'field': 'city', 'in': []},
      {'weird': 1},
    ]) {
      expect(() => Condition.parse(bad), throwsFormatException, reason: '$bad');
    }
  });
}
