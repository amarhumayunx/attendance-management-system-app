import 'package:flutter/material.dart';
import 'package:qrscanner/core/screens/leave_policy_viewer_screen.dart';

import '../core/constants/app_typography.dart';
class LeavePolicySection extends StatelessWidget {
  const LeavePolicySection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Leave Policy',
          style: AppTypography.kMedium18,
        ),
        const SizedBox(height: 12),
        Text(
          'Take a look at our comprehensive time-off document, as it will give very good knowledge of leave entitlements, policies, leaves actions, and a comprehensive guide that may include concessions on different types of leave.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8A65).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onPressed: () => _openLeavePolicy(context),
            icon: const Icon(Icons.description, color: Colors.white),
            label: Text(
              'View Leave Policy',
              style: AppTypography.kMedium16,
            ),
          ),
        ),
      ],
    );
  }
  void _openLeavePolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LeavePolicyViewerScreen(),
      ),
    );
  }
}
