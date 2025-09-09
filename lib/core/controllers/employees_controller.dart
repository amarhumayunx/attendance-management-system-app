import 'package:get/get.dart';
import 'package:qrscanner/core/services/profile_service.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/screens/edit_user_screen.dart';
import 'package:qrscanner/core/screens/admin_screen.dart';
class EmployeesController extends GetxController {

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

  Future<void> loadEmployees() async {
    try {
      isLoading.value = true;
      error.value = '';
      final employeesList = await ProfileService.getAllEmployees();
      employees.value = employeesList;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshEmployees() async {
    await loadEmployees();
  }

  Map<String, dynamic>? getEmployeeById(String id) {
    try {
      return employees.firstWhere((emp) => emp['id'] == id);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> getEmployeesByDepartment(String department) {
    return employees.where((emp) => emp['department'] == department).toList();
  }

  List<Map<String, dynamic>> getEmployeesByDesignation(String designation) {
    return employees.where((emp) => emp['designation'] == designation).toList();
  }

  List<Map<String, dynamic>> getActiveEmployees() {
    return employees.where((emp) => emp['isActive'] != false).toList();
  }

  List<Map<String, dynamic>> getInactiveEmployees() {
    return employees.where((emp) => emp['isActive'] == false).toList();
  }

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

  Future<void> loadDepartments() async {
    try {

      final allDepartments = Department.values.map((dept) => dept.name).toList();
      departments.value = ['Show All Users', ...allDepartments];
    } catch (e) {
    }
  }

  List<Map<String, dynamic>> get filteredEmployees {
    if (selectedDepartment.value == 'Show All Users') {
      return employees;
    }
    return employees.where((emp) => emp['department'] == selectedDepartment.value).toList();
  }

  void updateSelectedDepartment(String department) {
    selectedDepartment.value = department;
  }

  void navigateToEditUser(Map<String, dynamic> employee) {
    Get.to(() => EditUserScreen(userData: employee));
  }

  void navigateToAdmin() {
    Get.to(() => const AdminScreen());
  }
}
