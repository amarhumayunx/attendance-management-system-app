import 'package:flutter/material.dart';
import 'package:qrscanner/widgets/detail_grid_widget.dart';
import 'package:qrscanner/widgets/action_button_widget.dart';
class PersonalInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onUpdateProfile;
  final VoidCallback? onUploadDocuments;
  const PersonalInfoCard({
    super.key,
    required this.data,
    this.onUpdateProfile,
    this.onUploadDocuments,
  });
  @override
  Widget build(BuildContext context) {
    final salary = data['salary'];
    final dob = (data['dob'] ?? '').toString();
    final age = (data['age'] ?? '').toString();
    final address = (data['address'] ?? '').toString();
    final phone = (data['phone'] ?? '').toString();
    final doj = (data['dateOfJoining'] ?? '').toString();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFC44569)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DetailGridWidget(
            items: [
              DetailItem('Date of Birth', dob.isEmpty ? '—' : dob, Icons.cake),
              DetailItem('Age', age.isEmpty ? '—' : age, Icons.person_outline),
              DetailItem('Phone', phone.isEmpty ? '—' : phone, Icons.phone),
              DetailItem('Address', address.isEmpty ? '—' : address, Icons.location_on),
              DetailItem('Date of Joining', doj.isEmpty ? '—' : doj, Icons.work),
              DetailItem('Salary', salary?.toString() ?? '—', Icons.attach_money),
            ],
          ),
          if (onUpdateProfile != null || onUploadDocuments != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                if (onUpdateProfile != null) ...[
                  Expanded(
                    child: ActionButtonWidget(
                      onPressed: onUpdateProfile!,
                      icon: Icons.edit,
                      label: 'Update Profile',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                      ),
                    ),
                  ),
                  if (onUploadDocuments != null) const SizedBox(width: 12),
                ],
                if (onUploadDocuments != null)
                  Expanded(
                    child: ActionButtonWidget(
                      onPressed: onUploadDocuments!,
                      icon: Icons.upload_file,
                      label: 'Update Docs',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
