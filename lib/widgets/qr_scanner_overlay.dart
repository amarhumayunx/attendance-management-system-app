import 'package:flutter/material.dart';
class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.greenAccent.withOpacity(0.6),
            width: 3,
          ),
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              Colors.greenAccent.withOpacity(0.2),
            ],
            stops: const [0.7, 1.0],
          ),
        ),
        child: const Align(
          alignment: Alignment.center,
          child: Text(
            "Align QR Code",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.greenAccent,
                  blurRadius: 8,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
