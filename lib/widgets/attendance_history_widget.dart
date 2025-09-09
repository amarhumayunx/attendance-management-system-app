import 'package:flutter/material.dart';
import 'package:qrscanner/core/utils/attendance_utils.dart';
class AttendanceHistoryWidget extends StatelessWidget {
  final Map<String, dynamic> history;
  const AttendanceHistoryWidget({
    super.key,
    required this.history,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.0),
            1: FlexColumnWidth(1.0),
            2: FlexColumnWidth(1.0),
            3: FlexColumnWidth(1.0),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              ),
              children: [
                'Date', 'Check-In', 'Check-Out', 'Duration'
              ].map((header) => 
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).toList(),
            ),
            ...history.entries.toList().reversed.take(10).map((e) {
              final date = e.key;
              final d = e.value as Map<String, dynamic>;
              return TableRow(
                children: [
                  AttendanceUtils.formatDateLabel(date),
                  AttendanceUtils.getAttendanceStatus(d['checkInTime'] as String?, history, date),
                  AttendanceUtils.getAttendanceStatus(d['checkOutTime'] as String?, history, date),
                  d['duration'] ?? AttendanceUtils.formatDuration(d),
                ].map((text) => 
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      text.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
