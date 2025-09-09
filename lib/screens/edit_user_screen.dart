import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/controllers/edit_user_controller.dart';

class EditUserScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const EditUserScreen({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with user data
    final controller = Get.put(EditUserController());
    controller.initializeWithUserData(userData);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('Edit User', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A2E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(controller),
            tooltip: 'Delete User',
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Info Header
                  _buildUserInfoHeader(controller),
                  const SizedBox(height: 24),
                  // Personal Information Section
                  _buildSectionHeader('Personal Information', Icons.person),
                  const SizedBox(height: 16),
                  // Form fields
                  _buildPersonalInfoFields(controller),
                  const SizedBox(height: 24),
                  // Employee Details Section
                  _buildSectionHeader('Employee Details', Icons.work),
                  const SizedBox(height: 16),
                  // Employee fields
                  _buildEmployeeFields(controller),
                  const SizedBox(height: 24),
                  // Save Button
                  _buildSaveButton(controller),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(EditUserController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Delete User', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this user? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await controller.deleteUser();
              if (success) {
                Get.back(result: true);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoHeader(EditUserController controller) {
    return Obx(() => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF4ECDC4),
                          child: Text(
                            controller.userInitials.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.displayName.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.userEmail.value,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              if (controller.originalEmployeeId.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.badge,
                                      color: const Color(0xFF4ECDC4),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      controller.originalEmployeeId,
                                      style: const TextStyle(
                                        color: Color(0xFF4ECDC4),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
    ));
  }

  Widget _buildPersonalInfoFields(EditUserController controller) {
    return Column(
      children: [
                  // First Name
                  _buildTextField(
                    controller: controller.firstNameController,
                    label: 'First Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Last Name
                  _buildTextField(
                    controller: controller.lastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Email
                  _buildTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Phone
                  _buildTextField(
                    controller: controller.phoneController,
                    label: 'Phone',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  // Address
                  _buildTextField(
                    controller: controller.addressController,
                    label: 'Address',
                    icon: Icons.location_on,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  // Salary
                  _buildTextField(
          controller: controller.salaryController,
                    label: 'Salary',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  // Image URL
                  _buildTextField(
          controller: controller.imageUrlController,
                    label: 'Image URL',
                    icon: Icons.image,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  // Office Start Time
                  _buildTextField(
          controller: controller.officeStartTimeController,
                    label: 'Office Start Time (e.g., 10:00 AM)',
                    icon: Icons.schedule,
                    keyboardType: TextInputType.text,
                    hintText: 'Leave empty for default: 10:00 AM',
                  ),
                  const SizedBox(height: 16),
                  // Office End Time
                  _buildTextField(
          controller: controller.officeEndTimeController,
                    label: 'Office End Time (e.g., 07:00 PM)',
                    icon: Icons.schedule,
                    keyboardType: TextInputType.text,
                    hintText: 'Leave empty for default: 07:00 PM',
                  ),
      ],
    );
  }

  Widget _buildEmployeeFields(EditUserController controller) {
    return Column(
      children: [
                  // Designation
                  _buildDropdown<Designation>(
          value: controller.selectedDesignation.value,
                    items: Designation.values,
                    label: 'Designation',
                    icon: Icons.badge,
          onChanged: (value) => controller.selectedDesignation.value = value!,
          itemBuilder: (designation) => Text(controller.getDesignationDisplayName(designation)),
                  ),
                  const SizedBox(height: 16),
                  // Department
                  _buildDropdown<Department>(
          value: controller.selectedDepartment.value,
                    items: Department.values,
                    label: 'Department',
                    icon: Icons.business,
          onChanged: (value) => controller.selectedDepartment.value = value!,
          itemBuilder: (department) => Text(controller.getDepartmentDisplayName(department)),
                  ),
                  const SizedBox(height: 16),
                  // Employee Type
                  _buildDropdown<EmployeeType>(
          value: controller.selectedEmployeeType.value,
                    items: EmployeeType.values,
                    label: 'Employee Type',
                    icon: Icons.person_pin,
          onChanged: (value) => controller.selectedEmployeeType.value = value!,
          itemBuilder: (type) => Text(controller.getEmployeeTypeDisplayName(type)),
                  ),
                  const SizedBox(height: 16),
                  // Branch Code
                  _buildDropdown<BranchCode>(
          value: controller.selectedBranchCode.value,
                    items: BranchCode.values,
                    label: 'Branch Code',
                    icon: Icons.location_city,
          onChanged: (value) => controller.selectedBranchCode.value = value!,
          itemBuilder: (branchCode) => Text(controller.getBranchCodeDisplayName(branchCode)),
                  ),
                  const SizedBox(height: 16),
                  // Active Status
        Obx(() => SwitchListTile(
          title: const Text('Active', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            controller.isActive.value ? 'User is active' : 'User is inactive',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          value: controller.isActive.value,
          onChanged: (value) => controller.isActive.value = value,
          activeThumbColor: const Color(0xFF4ECDC4),
        )),
      ],
    );
  }

  Widget _buildSaveButton(EditUserController controller) {
    return Obx(() => SizedBox(
                    height: 56,
                    child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : () async {
          final success = await controller.updateUser();
          if (success) {
            Get.back(result: true);
          }
        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ECDC4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
        child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Update User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
    ));
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF4ECDC4)),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4ECDC4), width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String label,
    required IconData icon,
    required void Function(T?) onChanged,
    required Widget Function(T) itemBuilder,
    List<T>? excludeItems,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
        value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A1A2E),
        style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: items
              .where((item) => excludeItems?.contains(item) != true)
              .map((item) => DropdownMenuItem<T>(
            value: item,
            child: itemBuilder(item),
                  ))
              .toList(),
        onChanged: onChanged,
      ),
      ),
    );
  }
}
