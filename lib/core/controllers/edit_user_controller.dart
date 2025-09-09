import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/services/employee_id_service.dart';
class EditUserController extends GetxController {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final salaryController = TextEditingController();
  final imageUrlController = TextEditingController();
  final officeStartTimeController = TextEditingController();
  final officeEndTimeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final Rx<Designation> selectedDesignation = Designation.employee.obs;
  final Rx<Department> selectedDepartment = Department.softwareDevelopment.obs;
  final Rx<EmployeeType> selectedEmployeeType = EmployeeType.permanent.obs;
  final Rx<BranchCode> selectedBranchCode = BranchCode.eme.obs;
  final RxBool isActive = true.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxString displayName = ''.obs;
  final RxString userInitials = ''.obs;
  final RxString userEmail = ''.obs;

  late Department originalDepartment;
  late String originalEmployeeId;
  late Map<String, dynamic> userData;
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      initializeWithUserData(args);
    }
  }
  void initializeWithUserData(Map<String, dynamic> data) {
    userData = data;

    firstNameController.text = data['firstName'] ?? '';
    lastNameController.text = data['lastName'] ?? '';
    emailController.text = data['email'] ?? '';
    phoneController.text = data['phone'] ?? '';
    addressController.text = data['address'] ?? '';
    salaryController.text = data['salary']?.toString() ?? '';
    imageUrlController.text = data['imageUrl'] ?? '';
    officeStartTimeController.text = data['officeStartTime'] ?? '';
    officeEndTimeController.text = data['officeEndTime'] ?? '';

    selectedDesignation.value = _designationFromString(data['designation']);
    selectedDepartment.value = _departmentFromString(data['department']);
    selectedEmployeeType.value = _employeeTypeFromString(data['employeeType']);
    selectedBranchCode.value = _branchCodeFromString(data['branchCode']);
    isActive.value = data['isActive'] ?? true;

    originalDepartment = selectedDepartment.value;
    originalEmployeeId = data['employeeId'] ?? '';

    _updateDisplayVariables();

    firstNameController.addListener(_updateDisplayVariables);
    lastNameController.addListener(_updateDisplayVariables);
    emailController.addListener(_updateDisplayVariables);
  }
  void _updateDisplayVariables() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();

    displayName.value = '$firstName $lastName'.trim();

    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    userInitials.value = '$firstInitial$lastInitial';

    userEmail.value = email;
  }

  Future<bool> updateUser() async {
    if (!formKey.currentState!.validate()) return false;
    isLoading.value = true;
    error.value = '';
    try {
      final userId = userData['id'];
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      String? newEmployeeId;
      if (selectedDepartment.value != originalDepartment && originalEmployeeId.isNotEmpty) {

        newEmployeeId = await EmployeeIdService.updateEmployeeIdForDepartmentChange(
          originalEmployeeId,
          selectedDepartment.value,
          selectedBranchCode.value,
        );
      }
      final updatedData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim().toLowerCase(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'salary': salaryController.text.trim().isEmpty 
            ? null 
            : num.tryParse(salaryController.text.trim()),
        'imageUrl': imageUrlController.text.trim(),
        'designation': selectedDesignation.value.name,
        'department': selectedDepartment.value.name,
        'employeeType': selectedEmployeeType.value.name,
        'branchCode': selectedBranchCode.value.name,
        'isActive': isActive.value,
        'officeStartTime': officeStartTimeController.text.trim(),
        'officeEndTime': officeEndTimeController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (newEmployeeId != null) {
        updatedData['employeeId'] = newEmployeeId;
      }
      await userRef.update(updatedData);

      String message = 'User updated successfully!';
      if (newEmployeeId != null) {
        message = 'User updated successfully!\nEmployee ID changed to: $newEmployeeId';
      }
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return true;
    } catch (e) {
      error.value = 'Error updating user: $e';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteUser() async {
    isLoading.value = true;
    error.value = '';
    try {
      final userId = userData['id'];
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      Get.snackbar(
        'Success',
        'User deleted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      error.value = 'Error deleting user: $e';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
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
      case 'mobileAppDevelopment':
        return Department.mobileAppDevelopment;
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
      case 'other':
        return BranchCode.other;
      default:
        return BranchCode.eme;
    }
  }

  String getDesignationDisplayName(Designation designation) {
    switch (designation) {
      case Designation.teamLeader:
        return 'Team Leader';
      case Designation.manager:
        return 'Manager';
      case Designation.employee:
        return 'Employee';
    }
  }
  String getDepartmentDisplayName(Department department) {
    return EmployeeIdService.getDepartmentDisplayName(department);
  }
  String getEmployeeTypeDisplayName(EmployeeType employeeType) {
    return EmployeeIdService.getEmployeeTypeDisplayName(employeeType);
  }
  String getBranchCodeDisplayName(BranchCode branchCode) {
    switch (branchCode) {
      case BranchCode.eme:
        return 'EME';
      case BranchCode.other:
        return 'Other';
    }
  }
  @override
  void onClose() {

    firstNameController.removeListener(_updateDisplayVariables);
    lastNameController.removeListener(_updateDisplayVariables);
    emailController.removeListener(_updateDisplayVariables);
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    salaryController.dispose();
    imageUrlController.dispose();
    officeStartTimeController.dispose();
    officeEndTimeController.dispose();
    super.onClose();
  }
}
