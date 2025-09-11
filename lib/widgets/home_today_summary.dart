import 'package:flutter/material.dart';
import 'package:qrscanner/core/controllers/home_controller.dart';
import 'package:qrscanner/widgets/today_summary_widget.dart';

class HomeTodaySummary extends StatelessWidget {
  final HomeController controller;
  const HomeTodaySummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TodaySummaryWidget(
      todayData: controller.todayData.value,
    );
  }
}
