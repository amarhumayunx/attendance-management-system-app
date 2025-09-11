import 'package:flutter/material.dart';
import 'package:qrscanner/core/constants/app_typography.dart';

class TodaySummaryWidget extends StatelessWidget {
  final Map<String, dynamic>? todayData;
  
  const TodaySummaryWidget({
    super.key,
    required this.todayData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Check In
          Expanded(
            child: _buildStatItem(
              title: 'Check In',
              value: _getCheckInTime(),
              icon: Icons.login_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.2),
          ),
          // Check Out
          Expanded(
            child: _buildStatItem(
              title: 'Check Out',
              value: _getCheckOutTime(),
              icon: Icons.logout_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.2),
          ),
          // Duration
          Expanded(
            child: _buildStatItem(
              title: 'Duration',
              value: _getDuration(),
              icon: Icons.access_time_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.kMedium16,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTypography.kMedium12,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getCheckInTime() {
    if (todayData == null) return '--:--';
    final checkInTime = todayData!['checkInTime'];
    if (checkInTime == null || checkInTime == 'Not checked in') {
      return '--:--';
    }
    // Format time to show only HH:MM
    try {
      final time = DateTime.parse('2023-01-01 $checkInTime');
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return checkInTime;
    }
  }

  String _getCheckOutTime() {
    if (todayData == null) return '--:--';
    final checkOutTime = todayData!['checkOutTime'];
    if (checkOutTime == null) {
      return '--:--';
    }
    // Format time to show only HH:MM
    try {
      final time = DateTime.parse('2023-01-01 $checkOutTime');
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return checkOutTime;
    }
  }

  String _getDuration() {
    if (todayData == null) return '--:--';
    final duration = todayData!['duration'];
    if (duration == null || duration == '') {
      return '--:--';
    }
    return duration;
  }
}