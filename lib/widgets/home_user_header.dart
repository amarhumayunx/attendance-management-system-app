import 'package:flutter/material.dart';
import 'package:qrscanner/core/controllers/home_controller.dart';
import 'package:qrscanner/widgets/user_header_widget.dart';

class HomeUserHeader extends StatelessWidget {
  final HomeController controller;
  const HomeUserHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return UserHeader(
      uid: controller.uid.value,
      onLogout: controller.logout,
    );
  }
}
