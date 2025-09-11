import 'package:flutter/material.dart';
import 'package:qrscanner/core/controllers/home_controller.dart';
import 'home_user_header.dart';
import 'home_action_button.dart';
import 'home_today_summary.dart';

class HomeMainContent extends StatelessWidget {
  final HomeController controller;
  const HomeMainContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: Colors.blue[600],
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeUserHeader(controller: controller),
            const SizedBox(height: 45),
            HomeActionButton(controller: controller),
            const SizedBox(height: 35),
            HomeTodaySummary(controller: controller),
          ],
        ),
      ),
    );
  }
}
