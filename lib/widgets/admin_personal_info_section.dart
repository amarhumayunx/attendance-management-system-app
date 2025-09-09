import 'package:flutter/material.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/widgets/admin_form_field_widgets.dart';
import 'package:qrscanner/core/utils/admin_form_utils.dart';
class AdminPersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController ageController;
  final TextEditingController dobController;
  final TextEditingController dojController;
  final Designation designation;
  final ValueChanged<Designation> onDesignationChanged;
  const AdminPersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.ageController,
    required this.dobController,
    required this.dojController,
    required this.designation,
    required this.onDesignationChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        AdminFormFieldWidgets.buildSectionTitle('Personal Information'),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: AdminFormFieldWidgets.buildInputField(
                controller: firstNameController,
                label: 'First Name *',
                helper: 'Required',
                validator: (v) => AdminFormUtils.validateRequired(v, 'First Name'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminFormFieldWidgets.buildInputField(
                controller: lastNameController,
                label: 'Last Name *',
                helper: 'Required',
                validator: (v) => AdminFormUtils.validateRequired(v, 'Last Name'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AdminFormFieldWidgets.buildInputField(
          controller: emailController,
          label: 'Email *',
          helper: 'example@domain.com',
          keyboardType: TextInputType.emailAddress,
          validator: AdminFormUtils.validateEmail,
        ),
        const SizedBox(height: 12),
        AdminFormFieldWidgets.buildInputField(
          controller: passwordController,
          label: 'Password *',
          helper: 'Min 6 characters',
          obscureText: true,
          validator: AdminFormUtils.validatePassword,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AdminFormFieldWidgets.buildInputField(
                controller: ageController,
                label: 'Age *',
                helper: 'Years',
                keyboardType: TextInputType.number,
                validator: AdminFormUtils.validateAge,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminFormFieldWidgets.buildInputField(
                controller: dobController,
                label: 'Date of Birth *',
                helper: 'YYYY-MM-DD',
                validator: (v) => AdminFormUtils.validateDateFormat(v, 'DOB'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AdminFormFieldWidgets.buildInputField(
          controller: dojController,
          label: 'Date of Joining *',
          helper: 'YYYY-MM-DD',
          validator: (v) => AdminFormUtils.validateDateFormat(v, 'Joining date'),
        ),

        const SizedBox(height: 12),
        AdminFormFieldWidgets.buildDropdown<Designation>(
          value: designation,
          label: 'Designation *',
          helper: 'Required',
          items: Designation.values.map((d) => DropdownMenuItem(
            value: d,
            child: Text(AdminFormUtils.getDesignationName(d)),
          )).toList(),
          onChanged: (v) => onDesignationChanged(v!),
          validator: (v) => AdminFormUtils.validateDropdown(v, 'designation'),
        ),
      ],
    );
  }
}
