import 'package:flutter/material.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/widgets/admin_form_field_widgets.dart';
import 'package:qrscanner/core/utils/admin_form_utils.dart';
class AdminEmployeeDetailsSection extends StatelessWidget {
  final Department department;
  final EmployeeType employeeType;
  final BranchCode branchCode;
  final TextEditingController imageUrlController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController salaryController;
  final TextEditingController officeStartTimeController;
  final TextEditingController officeEndTimeController;
  final ValueChanged<Department> onDepartmentChanged;
  final ValueChanged<EmployeeType> onEmployeeTypeChanged;
  final ValueChanged<BranchCode> onBranchCodeChanged;
  const AdminEmployeeDetailsSection({
    super.key,
    required this.department,
    required this.employeeType,
    required this.branchCode,
    required this.imageUrlController,
    required this.addressController,
    required this.phoneController,
    required this.salaryController,
    required this.officeStartTimeController,
    required this.officeEndTimeController,
    required this.onDepartmentChanged,
    required this.onEmployeeTypeChanged,
    required this.onBranchCodeChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        const SizedBox(height: 20),
        AdminFormFieldWidgets.buildSectionTitle('Employee Details'),
        const SizedBox(height: 12),
        AdminFormFieldWidgets.buildDropdown<Department>(
          value: department,
          label: 'Department *',
          helper: 'Required',
          items: Department.values.map((d) => DropdownMenuItem(
            value: d,
            child: Text(AdminFormUtils.getDepartmentDisplayName(d)),
          )).toList(),
          onChanged: (v) => onDepartmentChanged(v!),
          validator: (v) => AdminFormUtils.validateDropdown(v, 'department'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AdminFormFieldWidgets.buildDropdown<EmployeeType>(
                value: employeeType,
                label: 'Employee Type *',
                helper: 'Required',
                items: EmployeeType.values.map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t.name.toTitleCase()),
                )).toList(),
                onChanged: (v) => onEmployeeTypeChanged(v!),
                validator: (v) => AdminFormUtils.validateDropdown(v, 'employee type'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminFormFieldWidgets.buildDropdown<BranchCode>(
                value: branchCode,
                label: 'Branch Code *',
                helper: 'Required',
                items: BranchCode.values.map((b) => DropdownMenuItem(
                  value: b,
                  child: Text(b.name.toUpperCase()),
                )).toList(),
                onChanged: (v) => onBranchCodeChanged(v!),
                validator: (v) => AdminFormUtils.validateDropdown(v, 'branch'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        AdminFormFieldWidgets.buildInfoBanner(
          AdminFormUtils.generateEmployeeIdPreview(department, branchCode),
        ),

        const SizedBox(height: 16),
        AdminFormFieldWidgets.buildInputField(
          controller: imageUrlController,
          label: 'Image URL *',
          helper: 'Required',
          validator: (v) => AdminFormUtils.validateRequired(v, 'Image URL'),
        ),
        const SizedBox(height: 12),
        AdminFormFieldWidgets.buildInputField(
          controller: addressController,
          label: 'Address',
          helper: 'Optional',
          validator: (v) => null,
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AdminFormFieldWidgets.buildInputField(
                controller: phoneController,
                label: 'Phone Number',
                helper: 'Optional',
                validator: (v) => null,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminFormFieldWidgets.buildInputField(
                controller: salaryController,
                label: 'Salary *',
                helper: 'In INR',
                keyboardType: TextInputType.number,
                validator: AdminFormUtils.validateSalary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        AdminFormFieldWidgets.buildSectionTitle('Office Timing'),
        const SizedBox(height: 12),

        AdminFormFieldWidgets.buildInputField(
          controller: officeStartTimeController,
          label: 'Office Start Time',
          helper: 'e.g., 10:00 AM (Leave empty for default)',
          keyboardType: TextInputType.text,
          validator: (value) => null,
        ),
        const SizedBox(height: 16),

        AdminFormFieldWidgets.buildInputField(
          controller: officeEndTimeController,
          label: 'Office End Time',
          helper: 'e.g., 07:00 PM (Leave empty for default)',
          keyboardType: TextInputType.text,
          validator: (value) => null,
        ),

        const SizedBox(height: 16),
        AdminFormFieldWidgets.buildWarningBanner(
          'Fields marked with * are required. Address, Phone, and Office Timing are optional.',
        ),
      ],
    );
  }
}
