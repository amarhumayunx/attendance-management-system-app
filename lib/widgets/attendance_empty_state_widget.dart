import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AttendanceEmptyStateWidget extends StatelessWidget {
  final DateTime currentMonth;
  const AttendanceEmptyStateWidget({
    super.key,
    required this.currentMonth,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'No Attendance Found',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            'No attendance records available for ${DateFormat('MMMM yyyy').format(currentMonth)}',
            style: const TextStyle(fontSize: 14, color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
