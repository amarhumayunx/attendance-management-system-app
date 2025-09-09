import 'package:flutter/material.dart';
import 'package:qrscanner/core/utils/attendance_viewer_utils.dart';
class AttendanceRowWidget extends StatelessWidget {
  final String type;
  final String timeString;
  final double latitude;
  final double longitude;
  final Color color;
  const AttendanceRowWidget({
    super.key,
    required this.type,
    required this.timeString,
    required this.latitude,
    required this.longitude,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            type == 'Check-In' ? Icons.login : Icons.logout,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Time: $timeString',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Location: ${AttendanceViewerUtils.formatLocation(latitude, longitude)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                if (latitude != 0.0 && longitude != 0.0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Coordinates: ${AttendanceViewerUtils.formatLocation(latitude, longitude)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'monospace'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
