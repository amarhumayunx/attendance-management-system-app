import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrscanner/core/services/qr_service.dart';

class QRScannerControllerService {
  static final MobileScannerController _controller = MobileScannerController();
  static bool _isHandlingScan = false;
  static String? _lastCode;

  static MobileScannerController get controller => _controller;

  static bool get isHandlingScan => _isHandlingScan;

  static String? get lastCode => _lastCode;

  static Future<void> handleBarcodeDetection(
    BuildContext context,
    BarcodeCapture capture,
  ) async {
    if (_isHandlingScan) return;
    
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code == null || code.isEmpty) continue;
      if (_lastCode == code) return;

      _isHandlingScan = true;
      _lastCode = code;

      await _controller.stop();

      await QRService.handleScan(
        context: context,
        code: code,
        onSuccess: (location, distance) {
          debugPrint('Attendance recorded at $location (${distance.toInt()}m)');
        },
        onError: (message) {
          debugPrint('Scan failed: $message');
        },
      );

      await Future.delayed(const Duration(milliseconds: 300));
      
      _isHandlingScan = false;
      await _controller.start();
      return;
    }
  }

  static void resetScanState() {
    _isHandlingScan = false;
    _lastCode = null;
  }

  static void dispose() {
    _controller.dispose();
  }
}
