import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/services/admin_user_creation_service.dart';
import 'package:qrscanner/core/screens/admin_leave_policy_upload_screen.dart';
import 'package:qrscanner/widgets/admin_personal_info_section.dart';
import 'package:qrscanner/widgets/admin_employee_details_section.dart';
import 'package:qrscanner/widgets/admin_form_field_widgets.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}
class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _age = TextEditingController();
  final _dob = TextEditingController();
  final _doj = TextEditingController();
  Designation _designation = Designation.employee;
  Department _department = Department.softwareDevelopment;
  EmployeeType _employeeType = EmployeeType.permanent;
  BranchCode _branchCode = BranchCode.eme;
  final _imageUrl = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _salary = TextEditingController();
  final _officeStartTime = TextEditingController();
  final _officeEndTime = TextEditingController();
  bool _saving = false;
  String? _error;
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _saving = true; _error = null; });
    final result = await AdminUserCreationService.createUser(
      firstName: _firstName.text,
      lastName: _lastName.text,
      email: _email.text,
      password: _password.text,
      age: _age.text,
      dob: _dob.text,
      doj: _doj.text,
      designation: _designation,
      department: _department,
      employeeType: _employeeType,
      branchCode: _branchCode,
      imageUrl: _imageUrl.text,
      address: _address.text,
      phone: _phone.text,
      salary: _salary.text,
      officeStartTime: _officeStartTime.text,
      officeEndTime: _officeEndTime.text,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.orange,
        ),
      );
      if (result['shouldRedirect'] == true) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      if (!result['success']) {
        setState(() { _error = result['error']; });
      }
    }
    setState(() { _saving = false; });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('Admin - Create User'),
        backgroundColor: const Color(0xFF0F3460),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const AdminLeavePolicyUploadScreen());
            },
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Upload Leave Policy',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              AdminPersonalInfoSection(
                firstNameController: _firstName,
                lastNameController: _lastName,
                emailController: _email,
                passwordController: _password,
                ageController: _age,
                dobController: _dob,
                dojController: _doj,
                designation: _designation,
                onDesignationChanged: (value) => setState(() => _designation = value),
              ),

              AdminEmployeeDetailsSection(
                department: _department,
                employeeType: _employeeType,
                branchCode: _branchCode,
                imageUrlController: _imageUrl,
                addressController: _address,
                phoneController: _phone,
                salaryController: _salary,
                officeStartTimeController: _officeStartTime,
                officeEndTimeController: _officeEndTime,
                onDepartmentChanged: (value) => setState(() => _department = value),
                onEmployeeTypeChanged: (value) => setState(() => _employeeType = value),
                onBranchCodeChanged: (value) => setState(() => _branchCode = value),
              ),

              AdminFormFieldWidgets.buildErrorText(_error),
              const SizedBox(height: 24),
              AdminFormFieldWidgets.buildSubmitButton(
                onPressed: _saving ? null : _save,
                isLoading: _saving,
                text: 'Create User',
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _age.dispose();
    _dob.dispose();
    _doj.dispose();
    _imageUrl.dispose();
    _address.dispose();
    _phone.dispose();
    _salary.dispose();
    _officeStartTime.dispose();
    _officeEndTime.dispose();
    super.dispose();
  }
}
