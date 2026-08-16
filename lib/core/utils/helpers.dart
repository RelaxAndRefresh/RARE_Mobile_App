/// Returns the current date in "WEEKDAY, DAY MONTH" format (e.g., "TUESDAY, 26 JULY")
String getFormattedDate() {
  final now = DateTime.now();

  final weekdays = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY'
  ];

  final months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];

  final weekday = weekdays[now.weekday - 1];
  final day = now.day;
  final month = months[now.month - 1];

  return '$weekday, $day $month';
}
