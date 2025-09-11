import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscanner/core/constants/app_typography.dart';
import 'package:qrscanner/core/controllers/home_controller.dart';

class HomeErrorState extends StatelessWidget {
  final HomeController controller;
  const HomeErrorState({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: AppTypography.kSemiBold26,
            ),
            const SizedBox(height: 16),
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white.withOpacity(0.8),
                fontFamily: GoogleFonts.poppins().fontFamily,
                height: 1.6,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: controller.loadAttendanceData,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                'Try Again',
                style: AppTypography.kMedium16,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
