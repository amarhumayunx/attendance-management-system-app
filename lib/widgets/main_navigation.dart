import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Designation _designationFromString(String? value) {
    switch (value) {
      case 'admin':
        return Designation.employee;
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
    final isAdmin = _userDesignationString == 'admin';
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
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
          ),
        ),
      );
    }
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF1A1A2E),
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
