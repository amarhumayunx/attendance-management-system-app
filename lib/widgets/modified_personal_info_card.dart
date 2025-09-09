import 'package:flutter/material.dart';
class ModifiedPersonalInfoCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onUpdateProfile;
  final VoidCallback? onUploadDocuments;
  final bool isAdmin;
  const ModifiedPersonalInfoCard({
    super.key,
    required this.data,
    this.onUpdateProfile,
    this.onUploadDocuments,
    this.isAdmin = false,
  });
  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: (value != null && value.isNotEmpty) ? Text(value) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
  @override
  Widget build(BuildContext context) {
    final address = (data['address'] ?? '').toString();
    final phone = (data['phone'] ?? '').toString();
    final email = (data['email'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (!isAdmin) ...[
          _buildListTile(
            icon: Icons.phone,
            title: 'Phone',
            value: phone,
          ),
          _buildListTile(
            icon: Icons.location_on,
            title: 'Address',
            value: address,
          ),
          _buildListTile(
            icon: Icons.email,
            title: 'Email',
            value: email,
          ),
        ],

        if (onUpdateProfile != null)
          _buildListTile(
            icon: Icons.edit,
            title: 'Update Profile',
            onTap: onUpdateProfile,
          ),
        if (onUploadDocuments != null)
          _buildListTile(
            icon: Icons.upload_file,
            title: 'Update Docs',
            onTap: onUploadDocuments,
          ),
      ],
    );
  }
}
