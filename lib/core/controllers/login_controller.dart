import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscanner/core/services/admin_setup_service.dart';
class LoginController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final error = RxnString();
  final isFormValid = false.obs;
  final loginAttempts = 0.obs;
  final isLocked = false.obs;

  final formKey = GlobalKey<FormState>();

  static const int maxLoginAttempts = 3;
  static const Duration lockoutDuration = Duration(minutes: 5);
  @override
  void onInit() {
    super.onInit();
    _setupTextControllerListeners();
    _checkLockoutStatus();
  }
  void _setupTextControllerListeners() {

    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }
  void _validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    isFormValid.value = email.isNotEmpty && 
                       email.contains('@') && 
                       password.length >= 6;
  }
  void _checkLockoutStatus() {

    if (isLocked.value) {
      _startLockoutTimer();
    }
  }
  void _startLockoutTimer() {
    Future.delayed(lockoutDuration, () {
      if (isLocked.value) {
        isLocked.value = false;
        loginAttempts.value = 0;
        error.value = null;
      }
    });
  }
  void _incrementLoginAttempts() {
    loginAttempts.value++;
    if (loginAttempts.value >= maxLoginAttempts) {
      isLocked.value = true;
      error.value = 'Too many failed attempts. Please try again in ${lockoutDuration.inMinutes} minutes.';
      _startLockoutTimer();
    }
  }
  void _resetLoginAttempts() {
    loginAttempts.value = 0;
    isLocked.value = false;
  }
  Future<void> login() async {

    if (isLocked.value) {
      return;
    }
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    error.value = null;
    try {
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text;

      if (AdminSetupService.isAdminEmail(email)) {
        await _handleAdminLogin(email, password);
      } else {
        await _handleUserLogin(email, password);
      }

      _resetLoginAttempts();

      showSuccessMessage();
    } catch (e) {
      _incrementLoginAttempts();
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _handleAdminLogin(String email, String password) async {
    if (AdminSetupService.validateAdminCredentials(email, password)) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          await AdminSetupService.createDefaultAdmin();
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else if (e.code == 'wrong-password') {
          throw Exception('Invalid admin credentials.');
        } else {
          throw Exception(e.message ?? 'Authentication error');
        }
      }
    } else {
      throw Exception('Invalid admin credentials.');
    }
  }
  Future<void> _handleUserLogin(String email, String password) async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) {
      throw Exception('User not found. Please contact admin.');
    }
    final data = snap.docs.first.data();
    if (data['password'] != password) {
      throw Exception('Invalid credentials.');
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else if (e.code == 'wrong-password') {
        throw Exception('Invalid credentials.');
      } else {
        throw Exception(e.message ?? 'Authentication error');
      }
    }
  }

  bool get canLogin => isFormValid.value && !isLoading.value && !isLocked.value;
  String get loginButtonText {
    if (isLoading.value) return 'Logging in...';
    if (isLocked.value) return 'Account Locked';
    return 'Login';
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    error.value = null;
    _resetLoginAttempts();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void showSuccessMessage() {
    Get.snackbar(
      'Success',
      'Login successful!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
  @override
  void onClose() {
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
