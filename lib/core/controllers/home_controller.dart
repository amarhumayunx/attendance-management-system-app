import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/services/attendance_home_service.dart';
import 'package:qrscanner/core/utils/attendance_utils.dart';
import 'package:qrscanner/core/screens/qr_scanner_screen.dart';
class HomeController extends GetxController {

  final RxString uid = ''.obs;
  final Rx<Map<String, dynamic>?> todayData = Rx<Map<String, dynamic>?>(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final Rx<Map<String, dynamic>> history = Rx<Map<String, dynamic>>({});
  final RxBool isRefreshing = false.obs;

  bool get hasCheckedIn => todayData.value?['checkInTime'] != null && 
                          todayData.value?['checkInTime'] != 'Not checked in';
  bool get hasCheckedOut => todayData.value?['checkOutTime'] != null;
  bool get canSwipe => AttendanceHomeService.canSwipe(todayData.value);
  String get swipeLabel => AttendanceHomeService.getSwipeLabel(todayData.value);
  String get checkInTime => AttendanceUtils.formatTime(todayData.value?['checkInTime'] as String?);
  String get checkOutTime => AttendanceUtils.formatTime(todayData.value?['checkOutTime'] as String?);
  String get onTimePercentage => AttendanceUtils.calculateOnTimePercentage(history.value);
  String get totalAttendance => '${history.value.length} days';
  @override
  void onInit() {
    super.onInit();
    loadAttendanceData();
  }

  Future<void> loadAttendanceData() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await AttendanceHomeService.loadAttendanceData();
      uid.value = result['uid'] ?? '';
      todayData.value = result['todayData'];
      history.value = result['history'] ?? {};
      error.value = result['error'] ?? '';
    } catch (e) {
      error.value = 'Failed to load attendance data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      error.value = '';
      final result = await AttendanceHomeService.loadAttendanceData();
      uid.value = result['uid'] ?? '';
      todayData.value = result['todayData'];
      history.value = result['history'] ?? {};
      error.value = result['error'] ?? '';
    } catch (e) {
      error.value = 'Failed to refresh data: ${e.toString()}';
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> openScanner() async {
    try {
      await Get.to(() => const QRScannerScreen());

      await refreshData();
    } catch (e) {
      error.value = 'Failed to open scanner: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      error.value = 'Failed to logout: ${e.toString()}';
    }
  }

  void showOnTimeDetails() {
    final stats = AttendanceUtils.getOnTimeStats(history.value);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'On-Time Performance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatRow('Total Days', '${stats['totalDays']}'),
              _buildStatRow('On-Time Days', '${stats['onTimeDays']}'),
              _buildStatRow('Late Days', '${stats['lateDays']}'),
              _buildStatRow('Percentage', '${stats['percentage']}%'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void clearError() {
    error.value = '';
  }

  Map<String, dynamic> getAttendanceStats() {
    return {
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'onTimePercentage': onTimePercentage,
      'totalAttendance': totalAttendance,
      'hasCheckedIn': hasCheckedIn,
      'hasCheckedOut': hasCheckedOut,
    };
  }
}
