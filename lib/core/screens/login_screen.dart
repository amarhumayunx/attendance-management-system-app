import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/core/constants/app_typography.dart';
import 'package:qrscanner/core/controllers/login_controller.dart';
import 'package:qrscanner/res/assets_res.dart';
import 'package:qrscanner/widgets/abstract_background_wrapper.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/info_message_box.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: AbstractBackgroundWrapper(
        child: SafeArea(
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
                                      AssetsRes.IMAGE,
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
                          child: Text(
                            'Welcome',
                            style: AppTypography.kBold48,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Center(
                          child: Text(
                            'Sign in to Zee-palm Attendance App',
                            style: AppTypography.kMedium18,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            children: [

                              CustomTextField(
                                controller: controller.emailController,
                                hintText: "Email",
                                prefixIcon: Icons.alternate_email,
                                textStyle: AppTypography.kMedium16,
                                hintStyle: AppTypography.kMedium16,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Enter email';
                                  if (!v.contains('@')) return 'Invalid email';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              Obx(() => CustomTextField(
                                controller: controller.passwordController,
                                hintText: "Password",
                                prefixIcon: Icons.password_rounded,
                                textStyle: AppTypography.kMedium16,
                                hintStyle: AppTypography.kMedium16,
                                obscureText: !controller.isPasswordVisible.value,
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
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Enter password';
                                  if (v.length < 6) return 'Min 6 characters';
                                  return null;
                                },
                              )),
                              const SizedBox(height: 24),

                              // Error Message
                              Obx(() => controller.error.value != null
                                  ? InfoMessageBox(
                                message: controller.error.value!,
                                color: Colors.red,
                                icon: Icons.error_outline,
                              )
                                  : const SizedBox.shrink()),

                              // Warning Message
                              Obx(() => controller.loginAttempts.value > 0 && !controller.isLocked.value
                                  ? InfoMessageBox(
                                message:
                                'Failed attempts: ${controller.loginAttempts.value}/${LoginController.maxLoginAttempts}',
                                color: Colors.orange,
                                icon: Icons.warning_amber_outlined,
                              )
                                  : const SizedBox.shrink()),

                              // Login Button
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
                                      ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: LoadingAnimationWidget.inkDrop(
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  )
                                      : Text(
                                    controller.loginButtonText,
                                    style: AppTypography.kMedium16,
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
                    style: AppTypography.kMedium12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
