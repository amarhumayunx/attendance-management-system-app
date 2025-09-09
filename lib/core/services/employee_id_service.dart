import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscanner/core/models/user_model.dart';
class EmployeeIdService {
  static const String _companyPrefix = 'ZP';
  static const Map<Department, String> _departmentCodes = {
    Department.softwareDevelopment: 'SD',
    Department.uiUxDesign: 'UX',
    Department.qualityAssurance: 'QA',
    Department.devOps: 'DO',
    Department.projectManagement: 'PM',
    Department.businessDevelopment: 'BD',
    Department.humanResources: 'HR',
    Department.financeAccounts: 'FA',
    Department.mobileAppDevelopment: 'MAD',
  };
  static const Map<BranchCode, String> _branchCodes = {
    BranchCode.eme: 'EME',
    BranchCode.other: 'OTHER',
  };



  static Future<String> generateEmployeeId(Department department, BranchCode branchCode) async {
    final deptCode = _departmentCodes[department] ?? 'XX';
    final branchCodeStr = _branchCodes[branchCode] ?? 'XXX';


    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('department', isEqualTo: department.name)
        .get();
    int nextNumber = 1;
    if (querySnapshot.docs.isNotEmpty) {
      int maxNumber = 0;
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final employeeId = data['employeeId'] as String?;
        if (employeeId != null && employeeId.contains('-')) {
          final parts = employeeId.split('-');
          if (parts.length >= 4) {
            final number = int.tryParse(parts[3]) ?? 0;
            if (number > maxNumber) {
              maxNumber = number;
            }
          }
        }
      }
      nextNumber = maxNumber + 1;
    }

    final formattedNumber = nextNumber.toString().padLeft(6, '0');
    return '$_companyPrefix-$deptCode-$branchCodeStr-$formattedNumber';
  }

  static String getDepartmentDisplayName(Department department) {
    switch (department) {
      case Department.softwareDevelopment:
        return 'Software Development / Engineering';
      case Department.mobileAppDevelopment:
        return 'Mobile App Development';
      case Department.uiUxDesign:
        return 'UI/UX & Design';
      case Department.qualityAssurance:
        return 'Quality Assurance (QA) / Testing';
      case Department.devOps:
        return 'DevOps / IT Infrastructure';
      case Department.projectManagement:
        return 'Project Management / Product Management';
      case Department.businessDevelopment:
        return 'Business Development / Sales';
      case Department.humanResources:
        return 'Human Resources (HR)';
      case Department.financeAccounts:
        return 'Finance & Accounts';
    }
  }

  static String getEmployeeTypeDisplayName(EmployeeType employeeType) {
    switch (employeeType) {
      case EmployeeType.permanent:
        return 'Permanent';
      case EmployeeType.temporary:
        return 'Temporary';
    }
  }


  static Future<String> updateEmployeeIdForDepartmentChange(
    String currentEmployeeId,
    Department newDepartment,
    BranchCode branchCode,
  ) async {

    final newEmployeeId = await generateEmployeeId(newDepartment, branchCode);

    final existingUserQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('employeeId', isEqualTo: newEmployeeId)
        .get();
    if (existingUserQuery.docs.isNotEmpty) {

      return await _generateUniqueEmployeeId(newDepartment, branchCode);
    }
    return newEmployeeId;
  }

  static Future<String> _generateUniqueEmployeeId(
    Department department,
    BranchCode branchCode,
  ) async {
    final deptCode = _departmentCodes[department] ?? 'XX';
    final branchCodeStr = _branchCodes[branchCode] ?? 'XXX';

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('department', isEqualTo: department.name)
        .where('branchCode', isEqualTo: branchCode.name)
        .get();
    int nextNumber = 1;
    if (querySnapshot.docs.isNotEmpty) {
      int maxNumber = 0;
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final employeeId = data['employeeId'] as String?;
        if (employeeId != null && employeeId.contains('-')) {
          final parts = employeeId.split('-');
          if (parts.length >= 4) {
            final number = int.tryParse(parts[3]) ?? 0;
            if (number > maxNumber) {
              maxNumber = number;
            }
          }
        }
      }
      nextNumber = maxNumber + 1;
    }

    final formattedNumber = nextNumber.toString().padLeft(6, '0');
    return '$_companyPrefix-$deptCode-$branchCodeStr-$formattedNumber';
  }
}
