import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrscanner/core/utils/attendance_utils.dart';
import 'package:qrscanner/widgets/attendance_day_item.dart';
class AttendanceList extends StatelessWidget {
  final DateTime selectedMonth;
  final Map<String, dynamic> attendanceHistory;
  final Map<String, dynamic> profile;
  const AttendanceList({
    super.key,
    required this.selectedMonth,
    required this.attendanceHistory,
    required this.profile,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Attendance Records',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(selectedMonth),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (AttendanceUtils.isFutureMonth(selectedMonth))
            _buildFutureMonthMessage()
          else if (AttendanceUtils.isBeforeJoiningMonth(selectedMonth, profile))
            _buildBeforeJoiningMessage()
          else if (AttendanceUtils.daysInMonth(selectedMonth, profile).isEmpty)
            _buildNoDaysMessage()
          else
            _buildAttendanceList(),
        ],
      ),
    );
  }
  Widget _buildFutureMonthMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_month_outlined, color: Colors.orange, size: 48),
          const SizedBox(height: 16),
          const Text(
            'No attendance in this month',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You have selected ${DateFormat('MMMM yyyy').format(selectedMonth)} which is a future month. Attendance data will be available once the employees start checking in.',
            style: TextStyle(
              color: Colors.orange.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildBeforeJoiningMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.person_off_outlined, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          const Text(
            'No attendance available before joining date',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You have selected ${DateFormat('MMMM yyyy').format(selectedMonth)} which is before the employee\'s joining date (${AttendanceUtils.formatJoiningDate(profile['dateOfJoining'])}). Please select a month from joining date onwards.',
            style: TextStyle(
              color: Colors.red.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: Colors.red, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Employee joined: ${AttendanceUtils.formatJoiningDate(profile['dateOfJoining'])}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNoDaysMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 48),
          const SizedBox(height: 16),
          const Text(
            'No days available for this month',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This could be because:\n• The month contains only future dates\n• No attendance data is available for this period',
            style: TextStyle(
              color: Colors.blue.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildAttendanceList() {
    final days = AttendanceUtils.daysInMonth(selectedMonth, profile);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final dateKey = AttendanceUtils.dateKey(day);
        final data = attendanceHistory[dateKey] as Map<String, dynamic>?;
        return AttendanceDayItem(
          day: day,
          data: data,
        );
      },
    );
  }
}
