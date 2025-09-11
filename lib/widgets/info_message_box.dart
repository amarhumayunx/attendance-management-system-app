import 'package:flutter/material.dart';
import 'package:qrscanner/core/constants/app_typography.dart';

class InfoMessageBox extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;

  const InfoMessageBox({
    super.key,
    required this.message,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.kMedium12,
            ),
          ),
        ],
      ),
    );
  }
}
