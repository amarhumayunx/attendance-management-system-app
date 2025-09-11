import 'package:flutter/material.dart';
import 'package:qrscanner/core/constants/app_typography.dart';
class AdminUploadHeaderWidget extends StatelessWidget {
  const AdminUploadHeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.cloud_upload,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
      Text(
            'Upload Leave Policy',
            style: AppTypography.kBold24,
          ),
          const SizedBox(height: 8),
          Text(
            'Upload the leave policy PDF to Supabase Storage for users to view',
            style: AppTypography.kMedium14,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
