import 'package:flutter/material.dart';
import 'package:qrscanner/core/controllers/home_controller.dart';
import 'package:qrscanner/widgets/circular_checkin_button.dart';

class HomeActionButton extends StatelessWidget {
  final HomeController controller;
  const HomeActionButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularCheckInButton(
        canTap: controller.canTap,
        label: controller.TapLabel,
        onTap: controller.openScanner,
        currentLocation: controller.currentLocationName.value,
      ),
    );
  }
}
