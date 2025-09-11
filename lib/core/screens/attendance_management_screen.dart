import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';

class AttendanceManagementScreen extends StatefulWidget {
  const AttendanceManagementScreen({super.key});
  @override
  State<AttendanceManagementScreen> createState() => _AttendanceManagementScreenState();
}
class _AttendanceManagementScreenState extends State<AttendanceManagementScreen> {
  Department _selectedDepartment = Department.softwareDevelopment;
  DateTime _selectedDate = DateTime.now();
  bool _loading = false;
  String? _error;

  Designation? _userDesignation;
  Department? _userDepartment;
  bool _isAdmin = false;
  bool _isTeamLeader = false;

  List<Map<String, dynamic>> _users = [];
  final Map<String, Map<String, dynamic>> _attendanceData = {};
  Map<String, dynamic> _averages = {};
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await ProfileService.getProfile(user);
      if (mounted && profile != null) {
        setState(() {
          _userDesignation = _designationFromString(profile['designation'] as String?);
          _userDepartment = _departmentFromString(profile['department'] as String?);
          _isAdmin = _userDesignation == Designation.admin;
          _isTeamLeader = _userDesignation == Designation.teamLeader;

          if (_isTeamLeader && _userDepartment != null) {
            _selectedDepartment = _userDepartment!;
          }
        });
        _loadData();
      }
    }
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
  Department _departmentFromString(String? value) {
    switch (value) {
      case 'softwareDevelopment':
        return Department.softwareDevelopment;
      case 'uiUxDesign':
        return Department.uiUxDesign;
      case 'qualityAssurance':
        return Department.qualityAssurance;
      case 'devOps':
        return Department.devOps;
      case 'projectManagement':
        return Department.projectManagement;
      case 'businessDevelopment':
        return Department.businessDevelopment;
      case 'humanResources':
        return Department.humanResources;
      case 'financeAccounts':
        return Department.financeAccounts;
      case 'mobileAppDevelopment':
        return Department.mobileAppDevelopment;
      default:
        return Department.softwareDevelopment;
    }
  }
  @override
  void dispose() {

    super.dispose();
  }
  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {

      _users = await AttendanceManagementService.loadUsersByDepartment(_selectedDepartment);

      if (!mounted) return;

      _attendanceData.clear();
      _attendanceData.addAll(await AttendanceManagementService.loadAttendanceData(_users));

      if (!mounted) return;

      _averages = AttendanceManagementUtils.calculateAverages(_attendanceData, _selectedDate);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return AbstractBackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
              'Attendance Management',
              style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            )
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: _loading
            ? Center(
                child: LoadingAnimationWidget.stretchedDots(
                color: Colors.white,
                size: 30,
        ),)
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: $_error',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (mounted) {
                                _loadData();
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [

                      AttendanceManagementFilters(
                        selectedDepartment: _selectedDepartment,
                        selectedDate: _selectedDate,
                        showDepartmentSelector: _isAdmin,
                        onDepartmentChanged: (value) {
                          if (mounted) {
                            setState(() => _selectedDepartment = value);
                            _loadData();
                          }
                        },
                        onDateChanged: (dt) {
                          if (mounted) {
                            setState(() { _selectedDate = DateTime(dt.year, dt.month, dt.day); });
                            _loadData();
                          }
                        },
                      ),

                      if (_isTeamLeader && _userDepartment != null) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF4ECDC4).withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.business,
                                color: const Color(0xFF4ECDC4),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Viewing: ${AttendanceManagementUtils.getDepartmentDisplayName(_userDepartment!)}',
                                style: AppTypography.kRegular14,
                              ),
                            ],
                          ),
                        ),
                      ],

                      AttendanceAveragesWidget(averages: _averages),

                      Expanded(
                        child: AttendanceManagementList(
                          selectedDate: _selectedDate,
                          dayAttendance: AttendanceManagementService.getAttendanceForDate(
                            _selectedDate,
                            _users,
                            _attendanceData,
                          ),
                          selectedDepartment: _selectedDepartment,
                        ),
                      ),
                    ],
                  ),),
      );
  }
}
