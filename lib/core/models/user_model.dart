import 'package:cloud_firestore/cloud_firestore.dart';
enum Designation {
  teamLeader,
  manager,
  employee,
}
enum Department {
  softwareDevelopment,
  uiUxDesign,
  qualityAssurance,
  devOps,
  projectManagement,
  businessDevelopment,
  humanResources,
  financeAccounts,
  mobileAppDevelopment,
}
enum EmployeeType {
  permanent,
  temporary,
}
enum BranchCode {
  eme,
  other,

}
class AppUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? age;
  final String? dob;
  final String? dateOfJoining;
  final Designation designation;
  final String? imageUrl;
  final String? address;
  final String? phone;
  final num? salary;
  final Timestamp? createdAt;

  final String? employeeId;
  final Department? department;
  final EmployeeType? employeeType;
  final BranchCode? branchCode;

  final String? officeStartTime;
  final String? officeEndTime;
  AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.designation,
    this.age,
    this.dob,
    this.imageUrl,
    this.dateOfJoining,
    this.address,
    this.phone,
    this.salary,
    this.createdAt,
    this.employeeId,
    this.department,
    this.employeeType,
    this.branchCode,
    this.officeStartTime,
    this.officeEndTime,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'age': age,
      'dob': dob,
      'dateOfJoining': dateOfJoining,
      'designation': designation.name,
      'imageUrl': imageUrl,
      'address': address,
      'phone': phone,
      'salary': salary,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'employeeId': employeeId,
      'department': department?.name,
      'employeeType': employeeType?.name,
      'branchCode': branchCode?.name,
      'officeStartTime': officeStartTime,
      'officeEndTime': officeEndTime,
    };
  }
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      age: map['age'] as String?,
      dob: map['dob'] as String?,
      dateOfJoining: map['dateOfJoining'] as String?,
      designation: _designationFromString(map['designation'] as String?),
      imageUrl: map['imageUrl'] as String?,
      address: map['address'] as String?,
      phone: map['phone'] as String?, 
      salary: map['salary'] as num?,
      createdAt: map['createdAt'] as Timestamp?,
      employeeId: map['employeeId'] as String?,
      department: _departmentFromString(map['department'] as String?),
      employeeType: _employeeTypeFromString(map['employeeType'] as String?),
      branchCode: _branchCodeFromString(map['branchCode'] as String?),
      officeStartTime: map['officeStartTime'] as String?,
      officeEndTime: map['officeEndTime'] as String?,
    );
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
    default:
      return Department.softwareDevelopment;
  }
}
EmployeeType _employeeTypeFromString(String? value) {
  switch (value) {
    case 'permanent':
      return EmployeeType.permanent;
    case 'temporary':
      return EmployeeType.temporary;
    default:
      return EmployeeType.permanent;
  }
}
BranchCode _branchCodeFromString(String? value) {
  switch (value) {
    case 'eme':
      return BranchCode.eme;
    default:
      return BranchCode.eme;
  }
}
