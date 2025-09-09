import 'package:flutter/material.dart';
import 'package:qrscanner/core/services/attendance_home_service.dart';
class TodaySummaryWidget extends StatelessWidget {
  final Map<String, dynamic>? todayData;
  const TodaySummaryWidget({
    super.key,
    required this.todayData,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getStatusColors(),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      AttendanceHomeService.getTodayStatus(todayData),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Duration',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AttendanceHomeService.getTodayDuration(todayData),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  List<Color> _getStatusColors() {
    if (todayData == null) {
      return [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)];
    }
    if (todayData?['checkOutTime'] != null) {
      return [const Color(0xFF4ECDC4), const Color(0xFF44A08D)];
    }
    return [const Color(0xFFFFB84D), const Color(0xFFFF8A50)];
  }
}
