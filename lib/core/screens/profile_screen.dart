import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';
import 'package:qrscanner/widgets/abstract_background_wrapper.dart';

import '../../widgets/info_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: AbstractBackgroundWrapper(
        child: SafeArea(
          top: true,
          bottom: false,
          child: FutureBuilder<Map<String, dynamic>?>(
            future: ProfileService.getProfile(user!),
            builder: (context, snap) {
              if (!snap.hasData) {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: Colors.white,
                    size: 30,
                  ),
                );
              }
              final data = snap.data;
              if (data == null) {
                return const NoProfileCard();
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120,left: 20,right: 20,top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileContent(user, data),
                  ],
                ),
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
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(Icons.email, 'Email', data['email'] ?? 'Not provided'),
              const SizedBox(height: 12),
              InfoRow(Icons.phone, 'Phone', data['phone'] ?? 'Not provided'),
              const SizedBox(height: 12),
              InfoRow(Icons.location_on, 'Address', data['address'] ?? 'Not provided'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(Icons.access_time, 'Office Time', '10:00 AM - 07:00 PM'),
              const SizedBox(height: 12),
              InfoRow(
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
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const AppInfoSection(),
        ),
        const SizedBox(height: 10),
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
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
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
