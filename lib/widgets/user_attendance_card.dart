import 'package:flutter/material.dart';
import 'package:qrscanner/widgets/attendance_row_widget.dart';
import 'package:qrscanner/core/utils/attendance_viewer_utils.dart';
class UserAttendanceCard extends StatelessWidget {
  final String userId;
  final Map<dynamic, dynamic> userData;
  const UserAttendanceCard({
    super.key,
    required this.userId,
    required this.userData,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'User: $userId',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (AttendanceViewerUtils.hasCheckIn(userData)) ...[
              AttendanceRowWidget(
                type: 'Check-In',
                timeString: userData['checkInTime'],
                latitude: userData['lat']?.toDouble() ?? 0.0,
                longitude: userData['lng']?.toDouble() ?? 0.0,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
            ],

            if (AttendanceViewerUtils.hasCheckOut(userData)) ...[
              AttendanceRowWidget(
                type: 'Check-Out',
                timeString: userData['checkOutTime'],
                latitude: userData['lat']?.toDouble() ?? 0.0,
                longitude: userData['lng']?.toDouble() ?? 0.0,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),

              if (AttendanceViewerUtils.hasCheckIn(userData)) ...[
                _buildDurationCard(),
                const SizedBox(height: 12),
              ],

              _buildCompletionCard(),
            ],

            if (!AttendanceViewerUtils.hasCheckIn(userData) && !AttendanceViewerUtils.hasCheckOut(userData)) ...[
              _buildNoAttendanceCard(),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildDurationCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Duration',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userData['duration'] ?? AttendanceViewerUtils.calculateDuration(
                    userData['checkInTime'], 
                    userData['checkOutTime']
                  ),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(
            'Attendance Complete for Today',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNoAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.grey),
          const SizedBox(width: 8),
          Text('No attendance recorded for today'),
        ],
      ),
    );
  }
}
