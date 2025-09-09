import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/location_info_widget.dart';
import '../../widgets/qr_scanner_overlay.dart';
import '../../widgets/scanner_instructions_widget.dart';
import '../services/location_service.dart';
import '../services/qr_scanner_controller_service.dart';
import 'attendance_viewer.dart';
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}
class _QRScannerScreenState extends State<QRScannerScreen> {
  Position? _currentPosition;
  bool _locationLoading = true;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _locationLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text("QR Scanner"),
        backgroundColor: const Color(0xFF0F3460),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note, color: Colors.white70),
            onPressed: () => Get.to(() => const AttendanceViewer()),
            tooltip: 'View Attendance',
          ),
        ],
      ),
      body: Stack(
        children: [

          MobileScanner(
            controller: QRScannerControllerService.controller,
            fit: BoxFit.cover,
            onDetect: (BarcodeCapture capture) async {
              await QRScannerControllerService.handleBarcodeDetection(context, capture);
            },
          ),

          const QRScannerOverlay(),

          const ScannerInstructionsWidget(),
        ],
      ),

      bottomNavigationBar: LocationInfoWidget(
        currentPosition: _currentPosition,
        locationLoading: _locationLoading,
        onRefresh: _getCurrentLocation,
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "refresh_location",
        backgroundColor: Colors.white.withOpacity(0.15),
        foregroundColor: Colors.greenAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.greenAccent.withOpacity(0.4), width: 1.5),
        ),
        onPressed: _getCurrentLocation,
        tooltip: 'Refresh Location',
        child: const Icon(Icons.refresh),
      ),
    );
  }
  @override
  void dispose() {
    QRScannerControllerService.dispose();
    super.dispose();
  }
}
