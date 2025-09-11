import 'package:flutter/material.dart';
import 'package:qrscanner/core/utils/attendance_month_utils.dart';

class AttendanceMonthDayItem extends StatelessWidget {
  final DateTime day;
  final Map<String, dynamic>? data;
  const AttendanceMonthDayItem({
    super.key,
    required this.day,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.day.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AttendanceMonthUtils.weekdayShort(day),
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Check-in', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        AttendanceMonthUtils.timeOrDash(data?['checkInTime'] as String?),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Check-out', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        AttendanceMonthUtils.timeOrDash(data?['checkOutTime'] as String?),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Duration', style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        data != null ? AttendanceMonthUtils.durationOrDash(data!) : '-',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
