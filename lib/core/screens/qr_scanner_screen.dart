import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/location_info_widget.dart';
import '../../widgets/qr_scanner_overlay.dart';
import '../services/location_service.dart';
import '../services/qr_scanner_controller_service.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            MobileScanner(
              controller: QRScannerControllerService.controller,
              fit: BoxFit.cover,
              onDetect: (BarcodeCapture capture) async {
                await QRScannerControllerService.handleBarcodeDetection(context, capture);
              },
            ),
            const QRScannerOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: LocationInfoWidget(
          currentPosition: _currentPosition,
          locationLoading: _locationLoading,
          onRefresh: _getCurrentLocation,
        ),
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          heroTag: "refresh_location",
          backgroundColor: Colors.white.withOpacity(0.15),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey, width: 1.5),
          ),
          onPressed: _getCurrentLocation,
          tooltip: 'Refresh Location',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}