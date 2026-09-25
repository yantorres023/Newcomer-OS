import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/domain/local_date.dart';

void main() {
  test('parses and prints ISO dates', () {
    expect(LocalDate.parse('2026-03-05').toString(), '2026-03-05');
    expect(() => LocalDate.parse('2026-3-5'), throwsFormatException);
    expect(() => LocalDate.parse('2026-02-30'), throwsFormatException);
    expect(LocalDate.tryParse(null), isNull);
    expect(LocalDate.tryParse('garbage'), isNull);
  });

  test('addDays crosses month, year and DST boundaries exactly', () {
    // Germany switches to winter time on the last Sunday of October.
    expect(LocalDate(2026, 10, 20).addDays(14), LocalDate(2026, 11, 3));
    expect(LocalDate(2026, 3, 20).addDays(14), LocalDate(2026, 4, 3));
    expect(LocalDate(2026, 12, 25).addDays(14), LocalDate(2027, 1, 8));
    expect(LocalDate(2028, 2, 28).addDays(1), LocalDate(2028, 2, 29));
  });

  test('addMonths clamps to end of month (§ 188(3) BGB)', () {
    expect(LocalDate(2026, 11, 30).addMonths(3), LocalDate(2027, 2, 28));
    expect(LocalDate(2027, 11, 30).addMonths(3), LocalDate(2028, 2, 29));
    expect(LocalDate(2026, 10, 1).addMonths(3), LocalDate(2027, 1, 1));
    expect(LocalDate(2026, 1, 31).addMonths(-1), LocalDate(2025, 12, 31));
  });

  test('daysUntil ignores time of day and timezone', () {
    expect(LocalDate(2026, 10, 24).daysUntil(LocalDate(2026, 10, 26)), 2);
    expect(LocalDate(2026, 10, 26).daysUntil(LocalDate(2026, 10, 24)), -2);
  });

  test('fromDateTime uses the local calendar date', () {
    expect(
      LocalDate.fromDateTime(DateTime(2026, 10, 1, 23, 59)),
      LocalDate(2026, 10, 1),
    );
  });

  test('ordering and equality', () {
    final a = LocalDate(2026, 1, 1);
    final b = LocalDate(2026, 1, 2);
    expect(a.isBefore(b), isTrue);
    expect(b.isAfter(a), isTrue);
    expect(a, LocalDate(2026, 1, 1));
    expect({a, LocalDate(2026, 1, 1)}.length, 1);
  });
}
