import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/services/profile_service.dart';
import 'package:qrscanner/core/models/user_model.dart';
class UserController extends GetxController {

  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Map<String, dynamic>?> userProfile = Rx<Map<String, dynamic>?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isAdmin = false.obs;
  final RxBool isTeamLeader = false.obs;
  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  void _initializeAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user != null) {
        loadUserProfile();
      } else {
        userProfile.value = null;
        isAdmin.value = false;
        isTeamLeader.value = false;
      }
    });
  }

  Future<void> loadUserProfile() async {
    final user = currentUser.value;
    if (user == null) return;
    try {
      isLoading.value = true;
      error.value = '';
      final profile = await ProfileService.getProfile(user);
      userProfile.value = profile;
      if (profile != null) {
        _updateUserRoles(profile);
      }
    } catch (e) {
      error.value = e.toString();
      print('Error loading user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUserRoles(Map<String, dynamic> profile) {
    final designation = profile['designation'] as String?;
    isAdmin.value = designation == 'admin';
    isTeamLeader.value = designation == 'teamLeader';
  }

  Future<bool> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      userProfile.value = null;
      isAdmin.value = false;
      isTeamLeader.value = false;
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final user = currentUser.value;
    if (user == null) return false;
    try {
      isLoading.value = true;
      error.value = '';
      await ProfileService.updateProfile(user, data);
      await loadUserProfile();
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Designation? getUserDesignation() {
    final profile = userProfile.value;
    if (profile == null) return null;
    return _designationFromString(profile['designation'] as String?);
  }

  Department? getUserDepartment() {
    final profile = userProfile.value;
    if (profile == null) return null;
    return _departmentFromString(profile['department'] as String?);
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

  bool get hasAdminPrivileges => isAdmin.value;

  bool get hasTeamLeaderPrivileges => isTeamLeader.value;

  bool get hasManagementPrivileges => isAdmin.value || isTeamLeader.value;
}
