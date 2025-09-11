import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrscanner/core/screens/home_screen.dart';
import 'package:qrscanner/core/screens/attendance_month_screen.dart';
import 'package:qrscanner/core/screens/profile_screen.dart';
import 'package:qrscanner/core/screens/attendance_management_screen.dart';
import 'package:qrscanner/widgets/bottom_nav.dart';
import 'package:qrscanner/core/services/profile_service.dart';
import 'package:qrscanner/core/models/user_model.dart';
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  Designation? _userDesignation;
  String? _userDesignationString;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _loadUserDesignation();
    _requestLocationPermission();
  }
  Future<void> _loadUserDesignation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await ProfileService.getProfile(user);
      if (mounted) {
        setState(() {
          _userDesignationString = profile?['designation'] as String?;
          _userDesignation = profile != null 
              ? _designationFromString(profile['designation'] as String?)
              : null;
          _loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationPermissionDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationPermissionDeniedDialog();
      return;
    }

    // Permission granted, we can proceed
    print('Location permission granted');
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.location_off, color: Colors.orange[600]),
              const SizedBox(width: 8),
              const Text('Location Services Required'),
            ],
          ),
          content: const Text(
            'This app requires location services to track attendance accurately. Please enable location services in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue[600]),
              const SizedBox(width: 8),
              const Text('Location Permission Required'),
            ],
          ),
          content: const Text(
            'This app needs location permission to track your attendance accurately. Please grant location permission to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestLocationPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Grant Permission'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.location_disabled, color: Colors.red[600]),
              const SizedBox(width: 8),
              const Text('Location Permission Denied'),
            ],
          ),
          content: const Text(
            'Location permission has been permanently denied. You can enable it later in your device settings if needed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
  Designation _designationFromString(String? value) {
    switch (value) {
      case 'admin':
        return Designation.admin;
      case 'teamLeader':
        return Designation.teamLeader;
      case 'manager':
        return Designation.manager;
      case 'employee':
      default:
        return Designation.employee;
    }
  }
  List<Widget> get _pages {
    final isAdmin = _userDesignation == Designation.admin;
    final isTeamLeader = _userDesignation == Designation.teamLeader;
    final isAdminOrTeamLeader = isAdmin || isTeamLeader;
    if (isAdminOrTeamLeader) {
      return const [
        HomeScreen(),
        AttendanceManagementScreen(),
        AttendanceMonthScreen(),
        ProfileScreen(),
      ];
    } else {
      return const [
        HomeScreen(),
        AttendanceMonthScreen(),
        ProfileScreen(),
      ];
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Pure Blur effect with transparent background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      extendBody: true,
      body: _pages[_index],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        userDesignation: _userDesignation,
        userDesignationString: _userDesignationString,
      ),
    );
  }
}
