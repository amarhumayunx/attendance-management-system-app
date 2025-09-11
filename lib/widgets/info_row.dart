import 'package:flutter/material.dart';
import 'package:qrscanner/core/constants/app_typography.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow(
      this.icon,
      this.label,
      this.value, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.kRegular12,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.kMedium14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
