import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/services/profile_service.dart';
class AttendanceManagementUtils {
  static String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty || timeString == 'Not checked in') {
      return '--:--';
    }
    try {
      final dt = DateFormat('dd-MM-yyyy HH:mm:ss').parse(timeString);
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return '--:--';
    }
  }
  static String formatDuration(String? checkIn, String? checkOut) {
    if (checkIn == null || checkOut == null || checkIn == 'Not checked in') {
      return '--:--';
    }
    try {
      final ci = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkIn);
      final co = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkOut);
      final diff = co.difference(ci);
      if (diff.isNegative) return '--:--';
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return '${h}h ${m}m';
    } catch (_) {
      return '--:--';
    }
  }
  static String getDepartmentDisplayName(Department department) {
    switch (department) {
      case Department.softwareDevelopment:
        return 'Software Development';
      case Department.mobileAppDevelopment:
        return 'Mobile App Development';
      case Department.uiUxDesign:
        return 'UI/UX Design';
      case Department.qualityAssurance:
        return 'Quality Assurance';
      case Department.devOps:
        return 'DevOps';
      case Department.projectManagement:
        return 'Project Management';
      case Department.businessDevelopment:
        return 'Business Development';
      case Department.humanResources:
        return 'Human Resources';
      case Department.financeAccounts:
        return 'Finance & Accounts';
    }
  }
  static Map<String, dynamic> calculateAverages(
    Map<String, Map<String, dynamic>> attendanceData,
    DateTime selectedDate,
  ) {
    List<DateTime> checkInTimes = [];
    List<DateTime> checkOutTimes = [];
    List<Duration> durations = [];
    final selectedMonth = selectedDate.month;
    final selectedYear = selectedDate.year;
    for (final userData in attendanceData.values) {
      for (final entry in userData.entries) {
        final dateKey = entry.key;
        final data = entry.value as Map<String, dynamic>;

        final parts = dateKey.split('-');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);

          if (year == selectedYear && month == selectedMonth) {
            final checkIn = data['checkInTime'] as String?;
            final checkOut = data['checkOutTime'] as String?;
            if (checkIn != null && checkIn != 'Not checked in') {
              try {
                final checkInTime = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkIn);
                checkInTimes.add(checkInTime);
              } catch (_) {}
            }
            if (checkOut != null) {
              try {
                final checkOutTime = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkOut);
                checkOutTimes.add(checkOutTime);
              } catch (_) {}
            }
            if (checkIn != null && checkOut != null) {
              try {
                final ci = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkIn);
                final co = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkOut);
                final duration = co.difference(ci);
                if (!duration.isNegative) {
                  durations.add(duration);
                }
              } catch (_) {}
            }
          }
        }
      }
    }

    return {
      'checkIn': calculateAverageTime(checkInTimes),
      'checkOut': calculateAverageTime(checkOutTimes),
      'duration': calculateAverageDuration(durations),
    };
  }
  static String calculateAverageTime(List<DateTime> times) {
    if (times.isEmpty) return '--:--';
    int totalMinutes = 0;
    for (final time in times) {
      totalMinutes += time.hour * 60 + time.minute;
    }
    final avgMinutes = (totalMinutes / times.length).round();
    final hours = avgMinutes ~/ 60;
    final minutes = avgMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  static String calculateAverageDuration(List<Duration> durations) {
    if (durations.isEmpty) return '--:--';
    int totalMinutes = 0;
    for (final duration in durations) {
      totalMinutes += duration.inMinutes;
    }
    final avgMinutes = (totalMinutes / durations.length).round();
    final hours = avgMinutes ~/ 60;
    final minutes = avgMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  static Future<bool> isCurrentUserTeamLeader() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      final profile = await ProfileService.getProfile(user);
      if (profile == null) return false;
      final designation = profile['designation'] as String?;
      return designation == 'teamLeader';
    } catch (e) {
      print('Error checking team leader status: $e');
      return false;
    }
  }

  static String formatLocation(double? lat, double? lng) {
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
      return 'Location not available';
    }
    return 'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
  }

  static bool hasValidLocation(double? lat, double? lng) {
    return lat != null && lng != null && (lat != 0.0 || lng != 0.0);
  }
}
