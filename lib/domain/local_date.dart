/// A calendar date without time or timezone.
///
/// Administrative deadlines in this app are calendar days (for example
/// "within two weeks of moving in"). Using [DateTime] with a time component
/// would make them shift across timezones and daylight-saving changes, so all
/// deadline arithmetic happens on [LocalDate] and is converted to UTC-midnight
/// internally.
class LocalDate implements Comparable<LocalDate> {
  LocalDate(this.year, this.month, this.day) {
    final check = DateTime.utc(year, month, day);
    if (check.year != year || check.month != month || check.day != day) {
      throw FormatException('Invalid date $year-$month-$day');
    }
  }

  factory LocalDate.fromDateTime(DateTime dateTime) =>
      LocalDate(dateTime.year, dateTime.month, dateTime.day);

  /// Parses `YYYY-MM-DD`. Throws [FormatException] on anything else.
  factory LocalDate.parse(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
    if (match == null) {
      throw FormatException('Expected YYYY-MM-DD, got "$value"');
    }
    return LocalDate(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }

  static LocalDate? tryParse(String? value) {
    if (value == null) return null;
    try {
      return LocalDate.parse(value);
    } on FormatException {
      return null;
    }
  }

  final int year;
  final int month;
  final int day;

  DateTime get _utc => DateTime.utc(year, month, day);

  LocalDate addDays(int days) =>
      LocalDate.fromDateTime(_utc.add(Duration(days: days)));

  /// Adds calendar months. If the target month is shorter, the result is the
  /// last day of that month (31 Jan + 1 month = 28/29 Feb), which matches how
  /// German law counts month-based periods (§ 188(3) BGB).
  LocalDate addMonths(int months) {
    final totalMonths = year * 12 + (month - 1) + months;
    final newYear = totalMonths ~/ 12;
    final newMonth = totalMonths % 12 + 1;
    final lastDay = DateTime.utc(newYear, newMonth + 1, 0).day;
    return LocalDate(newYear, newMonth, day > lastDay ? lastDay : day);
  }

  /// Whole days from this date to [other] (positive if [other] is later).
  int daysUntil(LocalDate other) => other._utc.difference(_utc).inDays;

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  /// Local-time [DateTime] on this date at [hour]:[minute].
  DateTime atTime(int hour, [int minute = 0]) =>
      DateTime(year, month, day, hour, minute);

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
