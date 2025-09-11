import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/lib_exports.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AbstractBackgroundWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'About Us',
            style: AppTypography.kMedium18,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                AboutUsSection(),
                SizedBox(height: 24),
                LeavePolicySection(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
