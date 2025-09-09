import 'package:intl/intl.dart';
class AttendanceUtils {

  static bool isWeekend(DateTime d) {
    return d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;
  }
  static String weekdayShort(DateTime d) {
    return DateFormat('E').format(d);
  }
  static String dateKey(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty || timeString == 'Not checked in') {
      return '-';
    }
    try {
      final dt = DateFormat('dd-MM-yyyy HH:mm:ss').parse(timeString);
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return '-';
    }
  }

  static String formatDuration(Map<String, dynamic> data) {
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
      if (m > 0) return '${m}m';
      return '${diff.inSeconds}s';
    } catch (_) {
      return '-';
    }
  }
  static bool isFutureMonth(DateTime month) {
    final currentDate = DateTime.now();
    final currentMonth = DateTime(currentDate.year, currentDate.month, 1);
    final selectedMonth = DateTime(month.year, month.month, 1);
    return selectedMonth.isAfter(currentMonth);
  }

  static bool isBeforeJoiningMonth(DateTime month, Map<String, dynamic> profile) {
    final joiningDate = profile['dateOfJoining'] as String?;
    if (joiningDate == null || joiningDate.isEmpty) return false;
    try {

      final parts = joiningDate.split('-');
      if (parts.length >= 2) {
        final joiningYear = int.parse(parts[0]);
        final joiningMonth = int.parse(parts[1]);
        final userJoiningDate = DateTime(joiningYear, joiningMonth, 1);
        final selectedMonth = DateTime(month.year, month.month, 1);
        return selectedMonth.isBefore(userJoiningDate);
      } else {
        print('⚠️ Invalid joining date format in isBeforeJoiningMonth: $joiningDate (expected YYYY-MM-DD)');
        return false;
      }
    } catch (_) {
      print('⚠️ Could not parse joining date in isBeforeJoiningMonth: $joiningDate');
      return false;
    }
  }
  static String formatJoiningDate(String? joiningDateString) {
    if (joiningDateString == null || joiningDateString.isEmpty) return 'N/A';
    try {

      final parts = joiningDateString.split('-');
      if (parts.length >= 2) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final joiningDate = DateTime(year, month, 1);
        return DateFormat('MMM yyyy').format(joiningDate);
      } else {
        return joiningDateString;
      }
    } catch (e) {
      print('Error formatting joining date: $e');
      return joiningDateString;
    }
  }
  static List<DateTime> daysInMonth(DateTime month, Map<String, dynamic> profile) {
    final days = <DateTime>[];
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 1).subtract(const Duration(days: 1));

    final joiningDate = profile['dateOfJoining'] as String?;
    DateTime? userJoiningDate;
    if (joiningDate != null && joiningDate.isNotEmpty) {
      try {

        final parts = joiningDate.split('-');
        if (parts.length >= 2) {
          final joiningYear = int.parse(parts[0]);
          final joiningMonth = int.parse(parts[1]);
          userJoiningDate = DateTime(joiningYear, joiningMonth, 1);
          print('📅 User joining date (parsed): ${DateFormat('yyyy-MM-dd').format(userJoiningDate)}');
        } else {
          print('⚠️ Invalid joining date format: $joiningDate (expected YYYY-MM-DD)');
        }
      } catch (_) {
        print('⚠️ Could not parse joining date in daysInMonth: $joiningDate');
      }
    } else {
      print('⚠️ No joining date found in profile');
    }

    final currentDate = DateTime.now();
    final today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    for (int i = 0; i <= lastDay.difference(firstDay).inDays; i++) {
      final day = firstDay.add(Duration(days: i));

      if (userJoiningDate != null && day.isBefore(userJoiningDate)) {
        continue;
      }

      if (day.isAfter(today)) {
        continue;
      }
      days.add(day);
    }

    days.sort((a, b) => b.compareTo(a));
    return days;
  }

  static String titleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : word
    ).join(' ');
  }
  static String formatDateLabel(String dateKey) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateKey);
      return DateFormat('MMM dd').format(date);
    } catch (_) {
      return dateKey;
    }
  }
  static String getAttendanceStatus(String? timeString, Map<String, dynamic> history, String dateKey) {
    if (timeString == null || timeString.isEmpty || timeString == 'Not checked in') {
      return '-';
    }
    return formatTime(timeString);
  }
  static Map<String, int> getOnTimeStats(Map<String, dynamic> history) {
    int total = 0;
    int onTime = 0;
    int late = 0;
    history.forEach((dateKey, data) {
      final checkInTime = data['checkInTime'] as String?;
      if (checkInTime != null && checkInTime != 'Not checked in') {
        total++;
        try {
          final checkIn = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkInTime);
          final checkInTimeOnly = DateTime(2000, 1, 1, checkIn.hour, checkIn.minute);
          final onTimeThreshold = DateTime(2000, 1, 1, 10, 15);
          if (checkInTimeOnly.isBefore(onTimeThreshold) || checkInTimeOnly.isAtSameMomentAs(onTimeThreshold)) {
            onTime++;
          } else {
            late++;
          }
        } catch (_) {

          late++;
        }
      }
    });
    return {'total': total, 'onTime': onTime, 'late': late};
  }
  static String calculateOnTimePercentage(Map<String, dynamic> history) {
    final stats = getOnTimeStats(history);
    final total = stats['total'] ?? 0;
    if (total == 0) return '0%';
    final onTime = stats['onTime'] ?? 0;
    final percentage = (onTime / total * 100).round();
    return '$percentage%';
  }
  static String getWorkingHoursInfo() {
    return 'Working hours: 9:00 AM - 6:00 PM';
  }
}
