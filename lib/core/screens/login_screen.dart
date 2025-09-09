import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/controllers/login_controller.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: Stack(
        children: [

          _buildAbstractBackground(context),

          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                        Center(
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/image/icons/image.png',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              ),
                            ),
                          ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                        Center(
                          child: const Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Center(
                          child: const Text(
                            'Sign in to Your Zee-palm Attendance App',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            children: [

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: controller.emailController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.alternate_email,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Enter email';
                                    if (!v.contains('@')) return 'Invalid email';
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Obx(() => TextFormField(
                                  controller: controller.passwordController,
                                  obscureText: !controller.isPasswordVisible.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.password_rounded,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 20,
                                      ),
                                      onPressed: controller.togglePasswordVisibility,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Enter password';
                                    if (v.length < 6) return 'Min 6 characters';
                                    return null;
                                  },
                                )),
                              ),
                              const SizedBox(height: 24),

                              Obx(() => controller.error.value != null
                                  ? Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade300,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        controller.error.value!,
                                        style: TextStyle(
                                          color: Colors.red.shade200,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox.shrink()),

                              Obx(() => controller.loginAttempts.value > 0 && !controller.isLocked.value
                                  ? Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.orange.shade300,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Failed attempts: ${controller.loginAttempts.value}/${LoginController.maxLoginAttempts}',
                                        style: TextStyle(
                                          color: Colors.orange.shade200,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox.shrink()),

                              Obx(() => Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: controller.canLogin
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: const Color(0xFF2D3748),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: controller.canLogin ? controller.login : null,
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Color(0xFF2D3748),
                                    ),
                                  )
                                      : Text(
                                    controller.loginButtonText,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Zee-Palm Attendance System © 2025',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAbstractBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: const Color(0xFF1A202C),
      child: Stack(
        children: [

          Positioned(
            top: -size.height * 0.1,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFB794F6).withOpacity(0.8),
                    const Color(0xFFB794F6).withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.2,
            left: -size.width * 0.3,
            child: Container(
              width: size.width * 0.7,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4FD1C7).withOpacity(0.7),
                    const Color(0xFF4FD1C7).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            bottom: -size.height * 0.15,
            right: -size.width * 0.25,
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFBD38D).withOpacity(0.6),
                    const Color(0xFFFBD38D).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.4,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2D3748).withOpacity(0.8),
                    const Color(0xFF2D3748).withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.1,
            right: size.width * 0.1,
            child: Container(
              width: size.width * 0.3,
              height: size.width * 0.3,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFED8936).withOpacity(0.5),
                    const Color(0xFFED8936).withOpacity(0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(size.width),
              ),
            ),
          ),

          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
