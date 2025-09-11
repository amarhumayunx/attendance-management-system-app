import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/core/core_exports.dart';

import '../../widgets/abstract_background_wrapper.dart';
class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});
  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}
class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _dob = TextEditingController();
  final _age = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _imageUrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }
  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final data = await ProfileService.getProfile(user);
      if (data != null) {
        _firstName.text = (data['firstName'] ?? '').toString();
        _lastName.text = (data['lastName'] ?? '').toString();
        _dob.text = (data['dob'] ?? '').toString();
        _age.text = (data['age'] ?? '').toString();
        _address.text = (data['address'] ?? '').toString();
        _phone.text = (data['phone'] ?? '').toString();
        _imageUrl.text = (data['imageUrl'] ?? '').toString();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _saving = true; _error = null; });
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await ProfileService.updateProfile(user, {
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        'dob': _dob.text.trim().isEmpty ? null : _dob.text.trim(),
        'age': _age.text.trim().isEmpty ? null : _age.text.trim(),
        'address': _address.text.trim().isEmpty ? null : _address.text.trim(),
        'phone': _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        'imageUrl': _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbstractBackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent, // 👈 transparent scaffold
        appBar: AppBar(
          title: const Text(
            'Update Profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent, // 👈 transparent appbar
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: _loading
            ? Center(
          child: LoadingAnimationWidget.stretchedDots(
          color: Colors.white,
          size: 30,
        ),)
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<Map<String, dynamic>?>(
                  future: ProfileService.getProfile(
                      FirebaseAuth.instance.currentUser!),
                  builder: (context, snap) {
                    final data = snap.data;
                    if (data == null) return const SizedBox.shrink();
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Admin Info',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _ReadOnlyRow(
                                label: 'Email',
                                value: (data['email'] ?? '').toString(),
                                dark: true),
                            const SizedBox(height: 8),
                            _ReadOnlyRow(
                                label: 'Designation',
                                value:
                                (data['designation'] ?? '').toString(),
                                dark: true),
                            const SizedBox(height: 8),
                            _ReadOnlyRow(
                                label: 'Date of Joining',
                                value: (data['dateOfJoining'] ?? '')
                                    .toString(),
                                dark: true),
                            const SizedBox(height: 8),
                            _ReadOnlyRow(
                                label: 'Salary',
                                value: (data['salary']?.toString() ?? ''),
                                dark: true),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                const Text(
                  'Personal Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _darkTextField(
                          controller: _firstName,
                          label: 'First Name',
                          validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Required'
                              : null),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _darkTextField(
                          controller: _lastName,
                          label: 'Last Name',
                          validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Required'
                              : null),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                        child: _darkTextField(
                            controller: _dob,
                            label: 'DOB (YYYY-MM-DD)')),
                    const SizedBox(width: 16),
                    Expanded(
                        child:
                        _darkTextField(controller: _age, label: 'Age')),
                  ],
                ),
                const SizedBox(height: 20),

                _darkTextField(controller: _address, label: 'Address'),
                const SizedBox(height: 20),

                _darkTextField(controller: _phone, label: 'Phone'),
                const SizedBox(height: 20),

                _darkTextField(controller: _imageUrl, label: 'Image URL'),
                const SizedBox(height: 32),

                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.redAccent.withOpacity(0.3)),
                    ),
                    child: Text(_error!,
                        style:
                        const TextStyle(color: Colors.redAccent)),
                  ),
                  const SizedBox(height: 20),
                ],

                /// --- Save Button ---
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                        : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                    onPressed: () => Get.to(() => DocumentUploadScreen()),
                    child: _saving
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.white,
                        size: 200,
                        ),
                    )
                        : const Text(
                      'Upload Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final String label;
  final String value;
  final bool dark;
  const _ReadOnlyRow({required this.label, required this.value, this.dark = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140, 
            child: Text(
              label, 
              style: TextStyle(
                color: dark ? Colors.white70 : Colors.grey,
                fontWeight: FontWeight.w500,
              )
            )
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value, 
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: dark ? Colors.white : Colors.black,
                height: 1.3,
              )
            )
          ),
        ],
      ),
    );
  }
}
Widget _darkTextField({
  required TextEditingController controller, 
  required String label, 
  String? Function(String?)? validator
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF4ECDC4), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
    ),
  );
}
