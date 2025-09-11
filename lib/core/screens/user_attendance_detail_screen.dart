import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';


class UserAttendanceDetailScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userDepartment;

  const UserAttendanceDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userDepartment,
  });

  @override
  State<UserAttendanceDetailScreen> createState() => _UserAttendanceDetailScreenState();
}

class _UserAttendanceDetailScreenState extends State<UserAttendanceDetailScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _profile = {};
  Map<String, dynamic> _attendanceData = {};
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final profileResult = await ProfileService.getProfileById(widget.userId);
      final attendanceResult = await AttendanceService.getUserAttendanceHistory(widget.userId);

      if (mounted) {
        setState(() {
          _profile = profileResult ?? {};
          _attendanceData = attendanceResult['data'] ?? {};
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _onDateChanged(DateTime newDate) async {
    setState(() {
      _selectedDate = newDate;
    });
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return AbstractBackgroundWrapper(
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('${widget.userName} - Attendance'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? Center(child: LoadingAnimationWidget.stretchedDots(
        color: Colors.white,
        size: 30,
      ),)
          : _error != null
              ? _buildErrorState()
              : _buildContent(),
      ),);
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $_error',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUserData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: UserProfileCard(
              profile: _profile,
              userDepartment: widget.userDepartment,
            ),
          ),
          const SizedBox(height: 24),
          
          MonthYearPicker(
            selectedMonth: _selectedDate,
            userJoiningDate: _profile['joiningDate'] != null 
                ? DateTime.parse(_profile['joiningDate']) 
                : null,
            onDateSelected: _onDateChanged,
          ),
          const SizedBox(height: 16),
          
          AttendanceList(
            selectedMonth: _selectedDate,
            attendanceHistory: _attendanceData,
            profile: _profile,
          ),
        ],
      ),
    );
  }
}
