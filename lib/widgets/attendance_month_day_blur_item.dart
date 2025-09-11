import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qrscanner/core/constants/app_typography.dart';
import 'package:qrscanner/core/utils/attendance_month_utils.dart';

class AttendanceMonthDayItemBlurred extends StatelessWidget {
  final DateTime day;
  final Map<String, dynamic>? data;
  const AttendanceMonthDayItemBlurred({
    super.key,
    required this.day,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08), // semi-transparent layer
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.day.toString().padLeft(2, '0'),
                      style: AppTypography.kMedium18,
                    ),
                    Text(
                      AttendanceMonthUtils.weekdayShort(day),
                      style: AppTypography.kRegular12
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
                          Text('Check-in',
                              style: AppTypography.kMedium16,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AttendanceMonthUtils.timeOrDash(
                                data?['checkInTime'] as String?),
                            style: AppTypography.kRegular12,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Check-out',
                              style: AppTypography.kMedium16,),
                          const SizedBox(height: 4),
                          Text(
                            AttendanceMonthUtils.timeOrDash(
                                data?['checkOutTime'] as String?),
                            style: AppTypography.kRegular12,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration',
                              style: AppTypography.kMedium16,),
                          const SizedBox(height: 4),
                          Text(
                            data != null
                                ? AttendanceMonthUtils.durationOrDash(data!)
                                : '-',
                            style: AppTypography.kRegular12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
