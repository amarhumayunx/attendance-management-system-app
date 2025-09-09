import 'package:flutter/material.dart';
class ScannerInstructionsWidget extends StatelessWidget {
  const ScannerInstructionsWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.black.withOpacity(0.3),
        child: const Text(
          "Scan QR to Mark Attendance",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
