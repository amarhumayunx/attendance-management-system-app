import 'package:qrscanner/core/services/attendance_service.dart';
import 'package:qrscanner/core/services/user_service.dart';
class AttendanceViewerService {

  static Future<Map<String, dynamic>> loadTodayAttendance() async {
    try {
      final uid = await UserService.getCurrentUid();
      final resp = await AttendanceService.getTodayAttendance(uid);
      final data = resp['data'] as Map<String, dynamic>?;
      return {
        'attendance': data != null ? {uid: data} : {},
        'error': null,
      };
    } catch (e) {
      return {
        'attendance': {},
        'error': e.toString(),
      };
    }
  }
}
