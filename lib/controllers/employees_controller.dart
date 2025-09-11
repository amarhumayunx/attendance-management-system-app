import 'package:get/get.dart';
import 'package:qrscanner/core/services/profile_service.dart';
import 'package:qrscanner/core/models/user_model.dart';

import '../core/screens/admin_screen.dart';
import '../core/screens/edit_user_screen.dart';

class EmployeesController extends GetxController {
  // Observable variables
  final RxList<Map<String, dynamic>> employees = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedDepartment = 'Show All Users'.obs;
  final RxList<String> departments = <String>['Show All Users'].obs;

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
    loadDepartments();
  }

  // Load all employees
  Future<void> loadEmployees() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final employeesList = await ProfileService.getAllEmployees();
      employees.value = employeesList;
    } catch (e) {
      error.value = e.toString();
      print('Error loading employees: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh employees list
  Future<void> refreshEmployees() async {
    await loadEmployees();
  }

  // Get employee by ID
  Map<String, dynamic>? getEmployeeById(String id) {
    try {
      return employees.firstWhere((emp) => emp['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Filter employees by department
  List<Map<String, dynamic>> getEmployeesByDepartment(String department) {
    return employees.where((emp) => emp['department'] == department).toList();
  }

  // Filter employees by designation
  List<Map<String, dynamic>> getEmployeesByDesignation(String designation) {
    return employees.where((emp) => emp['designation'] == designation).toList();
  }

  // Get active employees
  List<Map<String, dynamic>> getActiveEmployees() {
    return employees.where((emp) => emp['isActive'] != false).toList();
  }

  // Get inactive employees
  List<Map<String, dynamic>> getInactiveEmployees() {
    return employees.where((emp) => emp['isActive'] == false).toList();
  }

  // Search employees
  List<Map<String, dynamic>> searchEmployees(String query) {
    if (query.isEmpty) return employees;
    
    final lowercaseQuery = query.toLowerCase();
    return employees.where((emp) {
      final firstName = (emp['firstName'] ?? '').toLowerCase();
      final lastName = (emp['lastName'] ?? '').toLowerCase();
      final email = (emp['email'] ?? '').toLowerCase();
      final employeeId = (emp['employeeId'] ?? '').toLowerCase();
      
      return firstName.contains(lowercaseQuery) ||
             lastName.contains(lowercaseQuery) ||
             email.contains(lowercaseQuery) ||
             employeeId.contains(lowercaseQuery);
    }).toList();
  }

  // Load departments
  Future<void> loadDepartments() async {
    try {
      // Get all available departments from the enum
      final allDepartments = Department.values.map((dept) => dept.name).toList();
      departments.value = ['Show All Users', ...allDepartments];
    } catch (e) {
      print('Error loading departments: $e');
    }
  }

  // Filter employees by selected department
  List<Map<String, dynamic>> get filteredEmployees {
    if (selectedDepartment.value == 'Show All Users') {
      return employees;
    }
    return employees.where((emp) => emp['department'] == selectedDepartment.value).toList();
  }

  // Update selected department
  void updateSelectedDepartment(String department) {
    selectedDepartment.value = department;
  }

  // Navigate to edit user screen
  void navigateToEditUser(Map<String, dynamic> employee) {
    Get.to(() => EditUserScreen(userData: employee));
  }

  // Navigate to admin screen
  void navigateToAdmin() {
    Get.to(() => const AdminScreen());
  }
}
