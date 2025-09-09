import 'package:intl/intl.dart';
class AttendanceViewerUtils {
  static String calculateDuration(String checkInTime, String checkOutTime) {
    try {

      final checkIn = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkInTime);
      final checkOut = DateFormat('dd-MM-yyyy HH:mm:ss').parse(checkOutTime);
      final duration = checkOut.difference(checkIn);
      if (duration.isNegative) {
        return 'Invalid time range';
      }
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      if (hours > 0) {
        return '${hours}h ${minutes}m ${seconds}s';
      } else if (minutes > 0) {
        return '${minutes}m ${seconds}s';
      } else {
        return '${seconds}s';
      }
    } catch (e) {
      return 'Duration unavailable';
    }
  }
  static String formatLocation(double latitude, double longitude) {
    if (latitude == 0.0 && longitude == 0.0) {
      return 'Location not available';
    }
    return 'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}';
  }
  static bool hasCheckIn(Map<dynamic, dynamic> userData) {
    return userData['checkInTime'] != null && userData['checkInTime'] != 'Not checked in';
  }
  static bool hasCheckOut(Map<dynamic, dynamic> userData) {
    return userData['checkOutTime'] != null;
  }
  static bool isAttendanceComplete(Map<dynamic, dynamic> userData) {
    return hasCheckIn(userData) && hasCheckOut(userData);
  }
}
