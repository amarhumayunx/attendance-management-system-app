import 'package:flutter/material.dart';
import 'package:qrscanner/core/services/attendance_month_service.dart';
import 'package:qrscanner/widgets/month_selector_widget.dart';
import 'package:qrscanner/widgets/attendance_month_day_item.dart';
import 'package:qrscanner/widgets/weekend_day_widget.dart';
import 'package:qrscanner/widgets/attendance_empty_state_widget.dart';
import 'package:qrscanner/core/utils/attendance_month_utils.dart';
class AttendanceMonthScreen extends StatefulWidget {
  const AttendanceMonthScreen({super.key});
  @override
  State<AttendanceMonthScreen> createState() => _AttendanceMonthScreenState();
}
class _AttendanceMonthScreenState extends State<AttendanceMonthScreen> {
  bool _loading = true;
  String? _error;

  Map<String, dynamic> _history = {};
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  @override
  void initState() {
    super.initState();
    _load();
  }
  void _onMonthChanged(DateTime newMonth) {
    if (mounted) {
      setState(() {
        _currentMonth = newMonth;
      });
    }
  }
  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await AttendanceMonthService.loadAttendanceHistory();
    if (mounted) {
      setState(() {
        _history = result['history'];
        _error = result['error'];
        _loading = false;
      });
    }
  }
  void _changeMonth(int delta) {
    if (!mounted) return;
    final next = DateTime(_currentMonth.year, _currentMonth.month + delta);
    setState(() => _currentMonth = DateTime(next.year, next.month));
  }
  @override
  Widget build(BuildContext context) {
    final hasAttendance = AttendanceMonthUtils.hasAttendanceInMonth(_currentMonth, _history);
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.white)))
                  : Column(
                      children: [
                        MonthSelectorWidget(
                          currentMonth: _currentMonth,
                          onMonthChanged: _onMonthChanged,
                          onPreviousMonth: () => _changeMonth(-1),
                          onNextMonth: () => _changeMonth(1),
                          onRefresh: _load,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: hasAttendance
                              ? ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                                  itemCount: AttendanceMonthUtils.daysInMonth(_currentMonth).length,
                                  itemBuilder: (context, index) {
                                    final day = AttendanceMonthUtils.daysInMonth(_currentMonth)[index];
                                    final key = AttendanceMonthUtils.dateKey(day);
                                    final data = _history[key] as Map<String, dynamic>?;
                                    if (AttendanceMonthUtils.isWeekend(day)) {
                                      return WeekendDayWidget(day: day);
                                    }
                                    return AttendanceMonthDayItem(
                                      day: day,
                                      data: data,
                                    );
                                  },
                                )
                              : AttendanceEmptyStateWidget(currentMonth: _currentMonth),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
