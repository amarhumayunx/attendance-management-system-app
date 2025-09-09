import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/widgets/action_button_widget.dart';
import 'package:qrscanner/core/screens/profile_update_screen.dart';
import 'package:qrscanner/core/screens/document_upload_screen.dart';
class NoProfileCard extends StatelessWidget {
  const NoProfileCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Profile Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete your profile to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ActionButtonWidget(
                onPressed: () => Get.to(() => ProfileUpdateScreen()),
                icon: Icons.edit,
                label: 'Update Profile',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                ),
              ),
              const SizedBox(height: 16),
              ActionButtonWidget(
                onPressed: () => Get.to(() => DocumentUploadScreen()),
                icon: Icons.upload_file,
                label: 'Upload Documents',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
