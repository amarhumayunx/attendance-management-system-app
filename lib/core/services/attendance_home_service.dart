import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/services/attendance_service.dart';
import 'package:qrscanner/core/services/user_service.dart';
import 'package:qrscanner/core/utils/attendance_utils.dart';
class AttendanceHomeService {

  static Future<Map<String, dynamic>> loadAttendanceData() async {
    try {
      final uid = await UserService.getCurrentUid();
      print('🏠 Home Screen - Loading data for UID: $uid');

      final currentUser = FirebaseAuth.instance.currentUser;
      print('🏠 Home Screen - Current Firebase user: ${currentUser?.uid}');
      print('🏠 Home Screen - Current Firebase email: ${currentUser?.email}');
      final todayResp = await AttendanceService.getTodayAttendance(uid);
      print('🏠 Home Screen - Today attendance response: $todayResp');
      final history = await AttendanceService.getUserAttendanceHistory(uid, limit: 30);
      print('🏠 Home Screen - History response: ${history['history']?.length ?? 0} days');
      print('🏠 Home Screen - Data loaded successfully for UID: $uid');
      return {
        'uid': uid,
        'todayData': todayResp['data'] as Map<String, dynamic>?,
        'history': history['history'] as Map<String, dynamic>,
        'error': null,
      };
    } catch (e) {
      print('🏠 Home Screen - Error loading data: $e');
      return {
        'uid': null,
        'todayData': null,
        'history': {},
        'error': e.toString(),
      };
    }
  }

  static bool canTap(Map<String, dynamic>? todayData) {
    if (todayData == null) return true;
    if (todayData['checkOutTime'] != null) return false;
    return true;
  }

  static String getTapLabel(Map<String, dynamic>? todayData) {
    if (todayData == null) return 'Tap to Check In';
    if (todayData['checkOutTime'] != null) return 'Attendance Completed';
    final ci = todayData['checkInTime'];
    if (ci != null && ci != 'Not checked in') return 'Tap to Check Out';
    return 'Tap to Check In';
  }

  static String getTodayStatus(Map<String, dynamic>? todayData) {
    if (todayData == null) return 'No record';
    if (todayData['checkOutTime'] != null) return 'Completed';
    return 'In progress';
  }

  static String getTodayDuration(Map<String, dynamic>? todayData) {
    if (todayData == null) return '-';
    return todayData['duration'] ?? 
           AttendanceUtils.formatDuration(todayData);
  }

  static String getUserDisplayName(String? uid, String? emailPrefix) {
    if (uid == null) return emailPrefix ?? 'User';
    return emailPrefix ?? 'User';
  }
}
