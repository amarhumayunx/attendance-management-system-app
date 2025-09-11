import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:qrscanner/core/constants/app_typography.dart';
import 'package:qrscanner/widgets/user_attendance_management_card.dart';
import 'package:qrscanner/core/utils/attendance_management_utils.dart';
import 'package:qrscanner/core/models/user_model.dart';
class AttendanceManagementList extends StatelessWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> dayAttendance;
  final Department selectedDepartment;
  const AttendanceManagementList({
    super.key,
    required this.selectedDate,
    required this.dayAttendance,
    required this.selectedDepartment,
  });
  @override
  Widget build(BuildContext context) {

    if (dayAttendance.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.info, size: 36, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              'No users found in ${AttendanceManagementUtils.getDepartmentDisplayName(selectedDepartment)} department',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedDate.day.toString(),
                      style: AppTypography.kMedium18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM').format(selectedDate),
                      style: AppTypography.kRegular12,
                    ),
                    const Spacer(),
                    Text(
                      '${dayAttendance.length} Users',
                      style: AppTypography.kRegular12,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: dayAttendance
                      .map((attendance) => UserAttendanceManagementCard(
                            attendance: attendance,
                            selectedDepartment: selectedDepartment,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
