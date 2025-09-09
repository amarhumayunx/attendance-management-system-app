import 'package:intl/intl.dart';
class AttendanceMonthUtils {
  static List<DateTime> daysInMonth(DateTime month) {
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    final last = nextMonth.subtract(const Duration(days: 1));
    final days = <DateTime>[];
    for (int d = 0; d < last.day; d++) {
      days.add(DateTime(month.year, month.month, d + 1));
    }
    return days.reversed.toList();
  }
  static String dateKey(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
  static bool isWeekend(DateTime d) {
    return d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;
  }
  static String weekdayShort(DateTime d) {
    return DateFormat('E').format(d);
  }
  static String timeOrDash(String? ts) {
    if (ts == null || ts.isEmpty || ts == 'Not checked in') return '-';
    try {
      final dt = DateFormat('dd-MM-yyyy HH:mm:ss').parse(ts);
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return '-';
    }
  }
  static String durationOrDash(Map<String, dynamic> data) {
    final stored = data['duration'];
    if (stored != null && stored is String && stored.isNotEmpty) return stored;
    final ci = data['checkInTime'] as String?;
    final co = data['checkOutTime'] as String?;
    if (ci == null || co == null || ci == 'Not checked in') return '-';
    try {
      final ciDt = DateFormat('dd-MM-yyyy HH:mm:ss').parse(ci);
      final coDt = DateFormat('dd-MM-yyyy HH:mm:ss').parse(co);
      final diff = coDt.difference(ciDt);
      if (diff.isNegative) return '-';
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      if (h > 0) return '${h}h ${m}m';
      return '${m}m';
    } catch (_) {
      return '-';
    }
  }

  static bool hasAttendanceInMonth(DateTime month, Map<String, dynamic> history) {
    final daysInMonth = AttendanceMonthUtils.daysInMonth(month);
    for (final day in daysInMonth) {
      if (isWeekend(day)) continue;
      final key = dateKey(day);
      final data = history[key] as Map<String, dynamic>?;
      if (data != null && 
          data['checkInTime'] != null && 
          data['checkInTime'] != 'Not checked in') {
        return true;
      }
    }
    return false;
  }
}
