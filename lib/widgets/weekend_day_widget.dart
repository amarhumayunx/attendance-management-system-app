import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrscanner/core/utils/attendance_month_utils.dart';
class WeekendDayWidget extends StatelessWidget {
  final DateTime day;
  const WeekendDayWidget({
    super.key,
    required this.day,
  });
  @override
  Widget build(BuildContext context) {
    final wk = AttendanceMonthUtils.weekdayShort(day);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.weekend, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Weekend ($wk)  •  ${DateFormat('MMM dd').format(day)}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
