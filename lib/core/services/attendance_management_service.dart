import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/services/attendance_service.dart';
class AttendanceManagementService {

  static Future<List<Map<String, dynamic>>> loadUsersByDepartment(Department department) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('department', isEqualTo: department.name)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'firstName': data['firstName'] ?? '',
          'lastName': data['lastName'] ?? '',
          'email': data['email'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'employeeId': data['employeeId'] ?? '',
        };
      }).toList();
    } catch (e) {
      throw Exception('Error loading users: $e');
    }
  }

  static Future<Map<String, Map<String, dynamic>>> loadAttendanceData(List<Map<String, dynamic>> users) async {
    final Map<String, Map<String, dynamic>> attendanceData = {};
    print('=== LOADING ATTENDANCE DATA ===');
    print('Total users to process: ${users.length}');
    for (final user in users) {
      try {
        final userId = user['id'] as String;
        final userName = '${user['firstName']} ${user['lastName']}';
        print('\n--- Processing user: $userName ---');
        print('User ID: $userId');
        print('User ID length: ${userId.length}');

        if (userId.length > 20) {
          print('✅ User ID appears to be a valid Firebase UID');
        } else {
          print('⚠️ User ID appears to be too short for a Firebase UID');
        }
        print('🔍 Attempting to fetch attendance data...');
        final attendance = await AttendanceService.getUserAttendanceHistory(
          userId, 
          limit: 31
        );
        print('📡 Attendance service response: $attendance');
        if (attendance['success'] == true) {
          final history = attendance['history'] as Map<String, dynamic>;
          attendanceData[userId] = history;
          print('✅ Attendance data loaded successfully');
          print('Number of days with data: ${history.length}');
          if (history.isNotEmpty) {
            print('Sample dates: ${history.keys.take(3).toList()}');

            final todayKey = AttendanceService.formatDateKey(DateTime.now());
            print('Today\'s date key: $todayKey');
            if (history.containsKey(todayKey)) {
              final todayData = history[todayKey];
              print('Today\'s data: $todayData');
              print('Check-in time: ${todayData['checkInTime']}');
              print('Check-out time: ${todayData['checkOutTime']}');
            } else {
              print('No data for today ($todayKey)');
              print('Available dates: ${history.keys.toList()}');
            }
          } else {
            print('❌ No attendance history found');
          }
        } else {
          print('❌ Attendance service failed: ${attendance['error'] ?? 'Unknown error'}');
          attendanceData[userId] = {};
        }
      } catch (e) {
        print('❌ Error loading attendance for user ${user['firstName']}: $e');
        print('Stack trace: ${StackTrace.current}');

        attendanceData[user['id']] = {};
      }
    }
    print('\n=== ATTENDANCE LOADING COMPLETE ===');
    print('Total users processed: ${users.length}');
    print('Users with attendance data: ${attendanceData.length}');
    print('Users without attendance data: ${users.length - attendanceData.length}');

    for (final user in users) {
      final userId = user['id'] as String;
      final userName = '${user['firstName']} ${user['lastName']}';
      final hasData = attendanceData[userId]?.isNotEmpty ?? false;
      print('$userName: ${hasData ? "✅ Has data" : "❌ No data"}');
    }
    return attendanceData;
  }

  static List<Map<String, dynamic>> getAttendanceForDate(
    DateTime selectedDate,
    List<Map<String, dynamic>> users,
    Map<String, Map<String, dynamic>> attendanceData,
  ) {
    final dateKey = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    List<Map<String, dynamic>> dayAttendance = [];
    for (final user in users) {
      final userId = user['id'] as String;
      final userAttendance = attendanceData[userId] ?? {};
      final dayData = userAttendance[dateKey] as Map<String, dynamic>?;

      final hasAttendance = dayData != null && 
          (dayData['checkInTime'] != null || dayData['checkOutTime'] != null);
      dayAttendance.add({
        'user': user,
        'checkIn': dayData?['checkInTime'] as String?,
        'checkOut': dayData?['checkOutTime'] as String?,
        'hasAttendance': hasAttendance,
        'lat': dayData?['lat'] as double?,
        'lng': dayData?['lng'] as double?,
      });
    }
    return dayAttendance;
  }
}
