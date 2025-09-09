import 'package:flutter/material.dart';
import 'dart:convert';
import 'attendance_service.dart';
import 'location_service.dart';
import 'user_service.dart';
class QRService {
  static Future<void> handleScan({
    required BuildContext context,
    required String? code,
    required Function(String, double) onSuccess,
    required Function(String) onError,
  }) async {
    if (code == null || code.isEmpty) return;
    try {
      Map<String, dynamic> qrData = json.decode(code);

      if (!qrData.containsKey('lat') || !qrData.containsKey('lng')) {
        throw Exception('Invalid QR code format: Missing lat/lng coordinates');
      }
      double qrLat = qrData['lat'].toDouble();
      double qrLng = qrData['lng'].toDouble();

      String locationName = 'Attendance Location';
      final currentPosition = await LocationService.getCurrentLocation();

      {

        final uid = await UserService.getCurrentUid();

        final todayAttendance = await AttendanceService.getTodayAttendance(uid);
        final hasCheckedIn = todayAttendance['data'] != null && 
                             todayAttendance['data']['checkInTime'] != null && 
                             todayAttendance['data']['checkInTime'] != 'Not checked in';
        final hasCheckedOut = todayAttendance['data'] != null && 
                              todayAttendance['data']['checkOutTime'] != null;

        if (hasCheckedIn && hasCheckedOut) {
          _showAlreadyCompletedDialog(context);
          return;
        }

        String action = hasCheckedIn ? 'checkout' : 'checkin';
        Map<String, dynamic> result;
        if (action == 'checkout') {
          result = await AttendanceService.saveCheckOut(
            uid: uid,
            lat: qrLat,
            lng: qrLng,
          );
        } else {
          result = await AttendanceService.saveCheckIn(
            uid: uid,
            lat: qrLat,
            lng: qrLng,
          );
        }
        onSuccess(locationName, 0.0);
        _showAttendanceDialog(context, locationName, 0.0, qrLat, qrLng, currentPosition.latitude, currentPosition.longitude, result, action);

      }
    } catch (e) {
      onError('Error: ${e.toString()}');
      _showGenericErrorDialog(context, e.toString());
    }
  }
  static Future<void> _showAttendanceDialog(
      BuildContext context, String locationName, double distance, 
      double qrLat, double qrLng, double userLat, double userLng, 
      Map<String, dynamic> result, String qrType) {
    final isCheckIn = qrType == 'checkin';
    final titleText = isCheckIn ? 'Check-in Successful!' : 'Check-out Successful!';
    final duration = result['duration'];
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(
              isCheckIn ? Icons.login : Icons.logout,
              color: isCheckIn ? Colors.green : Colors.orange,
            ),
            SizedBox(width: 8),
            Text(titleText)
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: $locationName'),
            Text('Time: ${DateTime.now().toString().substring(0, 19)}'),
            if (!isCheckIn && duration != null) ...[
              SizedBox(height: 8),
              Text('Duration: $duration', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isCheckIn ? Colors.green : Colors.orange).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: (isCheckIn ? Colors.green : Colors.orange).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    isCheckIn ? Icons.login : Icons.logout,
                    color: isCheckIn ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isCheckIn ? 'Check-in recorded successfully' : 'Check-out recorded successfully',
                      style: TextStyle(
                        color: isCheckIn ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((_) {

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
  static void _showGenericErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: const [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Scan Error')
          ],
        ),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  static void _showAlreadyCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Attendance Complete'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'For today check in and check out done!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Come for tomorrow.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
