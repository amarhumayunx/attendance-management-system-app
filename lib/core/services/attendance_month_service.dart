import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/services/attendance_service.dart';
import 'package:qrscanner/core/services/user_service.dart';
class AttendanceMonthService {

  static Future<Map<String, dynamic>> loadAttendanceHistory() async {
    try {
      final uid = await UserService.getCurrentUid();
      print('📅 Monthly Attendance Screen - Loading data for UID: $uid');

      final currentUser = FirebaseAuth.instance.currentUser;
      print('📅 Monthly Attendance Screen - Current Firebase user: ${currentUser?.uid}');
      print('📅 Monthly Attendance Screen - Current Firebase email: ${currentUser?.email}');

      final resp = await AttendanceService.getUserAttendanceHistory(uid, limit: 62);
      print('📅 Monthly Attendance Screen - History response: ${resp['history']?.length ?? 0} days');
      return {
        'history': (resp['history'] as Map<String, dynamic>?) ?? {},
        'error': null,
      };
    } catch (e) {
      print('📅 Monthly Attendance Screen - Error loading data: $e');
      return {
        'history': {},
        'error': e.toString(),
      };
    }
  }
}
