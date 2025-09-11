import 'package:flutter/material.dart';
import 'package:qrscanner/widgets/cupertino_department_picker.dart';
import 'package:qrscanner/widgets/cupertino_date_dropdown.dart';
import 'package:qrscanner/core/utils/attendance_management_utils.dart';
import 'package:qrscanner/core/models/user_model.dart';
class AttendanceManagementFilters extends StatelessWidget {
  final Department selectedDepartment;
  final DateTime selectedDate;
  final bool showDepartmentSelector;
  final Function(Department) onDepartmentChanged;
  final Function(DateTime) onDateChanged;
  const AttendanceManagementFilters({
    super.key,
    required this.selectedDepartment,
    required this.selectedDate,
    this.showDepartmentSelector = true,
    required this.onDepartmentChanged,
    required this.onDateChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Row(
                  children: [
                    if (showDepartmentSelector) ...[
                      Expanded(
                        child: CupertinoDepartmentPicker(
                          selected: selectedDepartment,
                          onSelected: onDepartmentChanged,
                          getLabel: AttendanceManagementUtils.getDepartmentDisplayName,
                          dense: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: CupertinoDateDropdown(
                        selectedDate: selectedDate,
                        onDateChanged: onDateChanged,
                        dense: true,
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [

                    if (showDepartmentSelector) ...[
                      Expanded(
                        child: CupertinoDepartmentPicker(
                          selected: selectedDepartment,
                          onSelected: onDepartmentChanged,
                          getLabel: AttendanceManagementUtils.getDepartmentDisplayName,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],

                    Expanded(
                      child: CupertinoDateDropdown(
                        selectedDate: selectedDate,
                        onDateChanged: onDateChanged,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
