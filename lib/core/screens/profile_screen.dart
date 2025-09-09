import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/services/profile_service.dart';
import 'package:qrscanner/widgets/app_info_section.dart';
import 'package:qrscanner/widgets/profile_header_card.dart';
import 'package:qrscanner/widgets/no_profile_card.dart';
import 'package:qrscanner/core/screens/profile_update_screen.dart';
import 'package:qrscanner/core/screens/about_us_screen.dart';
import 'package:qrscanner/core/screens/employees_screen.dart';
import 'package:qrscanner/core/screens/leave_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A2E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
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
          child: FutureBuilder<Map<String, dynamic>?>(
            future: ProfileService.getProfile(user!),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snap.data;
              if (data == null) {
                return const NoProfileCard();
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                children: [
                  _buildProfileContent(user, data),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  Widget _buildProfileContent(User user, Map<String, dynamic> data) {
    final isAdmin = data['designation'] == 'admin';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        ProfileHeaderCard(user: user, data: data),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.email, 'Email', data['email'] ?? 'Not provided'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone, 'Phone', data['phone'] ?? 'Not provided'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, 'Address', data['address'] ?? 'Not provided'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.access_time, 'Office Time', '10:00 AM - 07:00 PM'),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.location_city,
                'Office Address',
                '23-D 2nd Floor, Commercial Area EME DHA Phase 12, Lahore, Punjab, Pakistan',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        if (isAdmin) ...[
          _buildActionButton(
            Icons.people,
            'Employees',
            'Manage all employees',
                () => Get.to(() => const EmployeesScreen()),
          ),
          const SizedBox(height: 12),
        ] else ...[
          _buildActionButton(
            Icons.event_available,
            'Leave Request',
            'Submit a leave request',
                () => Get.to(() => const LeaveScreen()),
          ),
          const SizedBox(height: 12),
        ],

        _buildActionButton(
          Icons.edit,
          'My Profile',
          'Update your profile information',
              () => Get.to(() => const ProfileUpdateScreen()),
        ),
        const SizedBox(height: 12),

        _buildActionButton(
          Icons.info_outline,
          'About Us',
          'Learn more about the app',
              () => Get.to(() => const AboutUsScreen()),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const AppInfoSection(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4ECDC4), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildActionButton(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
