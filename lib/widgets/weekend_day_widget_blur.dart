import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qrscanner/core/utils/attendance_month_utils.dart';

class WeekendDayWidgetBlurred extends StatelessWidget {
  final DateTime day;
  const WeekendDayWidgetBlurred({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final wk = AttendanceMonthUtils.weekdayShort(day);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.15), // keep overlay
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.weekend, color: Colors.greenAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Weekend ($wk)  •  ${DateFormat('MMM dd').format(day)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontFamily: GoogleFonts.poppins().fontFamily,fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
