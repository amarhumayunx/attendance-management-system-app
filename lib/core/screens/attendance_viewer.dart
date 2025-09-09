import 'package:flutter/material.dart';
import 'package:qrscanner/core/services/attendance_viewer_service.dart';
import 'package:qrscanner/widgets/attendance_summary_header.dart';
import 'package:qrscanner/widgets/user_attendance_card.dart';
class AttendanceViewer extends StatefulWidget {
  const AttendanceViewer({super.key});
  @override
  State<AttendanceViewer> createState() => _AttendanceViewerState();
}
class _AttendanceViewerState extends State<AttendanceViewer> {
  Map<String, dynamic> _todayAttendance = {};
  bool _loading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadTodayAttendance();
  }
  Future<void> _loadTodayAttendance() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await AttendanceViewerService.loadTodayAttendance();
    setState(() {
      _todayAttendance = result['attendance'];
      _error = result['error'];
      _loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Attendance'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTodayAttendance,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text('Error: $_error'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTodayAttendance,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
                                 : _todayAttendance.isEmpty
                   ? Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.event_busy, size: 64, color: Colors.grey),
                           SizedBox(height: 16),
                           Text('No attendance records for today'),
                           SizedBox(height: 16),
                           Text('Scan a QR code to record attendance'),
                         ],
                       ),
                     )
                   : Column(
                       children: [

                         AttendanceSummaryHeader(userCount: _todayAttendance.length),

                         Expanded(
                           child: ListView.builder(
                             padding: const EdgeInsets.symmetric(horizontal: 16),
                             itemCount: _todayAttendance.length,
                             itemBuilder: (context, index) {
                               final userId = _todayAttendance.keys.elementAt(index);
                               final userData = _todayAttendance[userId];
                               return UserAttendanceCard(
                                 userId: userId,
                                 userData: userData,
                               );
                             },
                           ),
                         ),
                       ],
                     ),
    );
  }
}
