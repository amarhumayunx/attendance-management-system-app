import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/services/employee_id_service.dart';
class AdminFormUtils {

  static String getDesignationName(Designation d) {
    switch (d) {
      case Designation.teamLeader:
        return 'Team Leader';
      case Designation.manager:
        return 'Manager';
      case Designation.employee:
        return 'Employee';
    }
  }

  static String getDepartmentDisplayName(Department department) {
    return EmployeeIdService.getDepartmentDisplayName(department);
  }

  static String generateEmployeeIdPreview(Department department, BranchCode branchCode) {
    final deptPrefix = getDepartmentDisplayName(department).substring(0, 2).toUpperCase();
    return 'ID: $deptPrefix-${branchCode.name.toUpperCase()}-XXXXXX';
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Invalid email format';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) return 'Age is required';
    final age = int.tryParse(value.trim());
    if (age == null || age <= 0 || age > 120) return 'Enter valid age';
    return null;
  }

  static String? validateDateFormat(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value.trim())) return 'Use YYYY-MM-DD';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) return 'Salary is required';
    final salary = num.tryParse(value.trim());
    if (salary == null || salary <= 0) return 'Enter valid salary';
    return null;
  }

  static String? validateDropdown<T>(T? value, String fieldName) {
    if (value == null) return 'Select $fieldName';
    return null;
  }
}

extension StringCasingExtension on String {
  String toTitleCase() {
    return split(' ').map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join(' ');
  }
}
