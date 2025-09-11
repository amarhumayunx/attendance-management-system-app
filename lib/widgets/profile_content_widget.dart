import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/screens/about_us_screen.dart';
import '../core/screens/employees_screen.dart';
import '../core/screens/leave_screen.dart';
import '../core/screens/profile_update_screen.dart';
import 'action_button_row.dart';
import 'info_row.dart';
import 'profile_header_card.dart';
import 'app_info_section.dart';

class ProfileContent extends StatelessWidget {
  final User user;
  final Map<String, dynamic> data;

  const ProfileContent(
      this.user,
      this.data, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final isAdmin = data['designation'] == 'admin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileHeaderCard(user: user, data: data),
        const SizedBox(height: 20),

        _buildSection([
          InfoRow(Icons.email, 'Email', data['email'] ?? 'Not provided'),
          const SizedBox(height: 12),
          InfoRow(Icons.phone, 'Phone', data['phone'] ?? 'Not provided'),
          const SizedBox(height: 12),
          InfoRow(Icons.location_on, 'Address', data['address'] ?? 'Not provided'),
        ]),
        const SizedBox(height: 20),

        _buildSection(const [
          InfoRow(Icons.access_time, 'Office Time', '10:00 AM - 07:00 PM'),
          SizedBox(height: 12),
          InfoRow(
            Icons.location_city,
            'Office Address',
            '23-D 2nd Floor, Commercial Area EME DHA Phase 12, Lahore, Punjab, Pakistan',
          ),
        ]),
        const SizedBox(height: 20),

        if (isAdmin) ...[
          ActionButton(
            Icons.people,
            'Employees',
            'Manage all employees',
                () => Get.to(() => const EmployeesScreen()),
          ),
          const SizedBox(height: 12),
        ] else ...[
          ActionButton(
            Icons.event_available,
            'Leave Request',
            'Submit a leave request',
                () => Get.to(() => const LeaveScreen()),
          ),
          const SizedBox(height: 12),
        ],

        /// Common actions
        ActionButton(
          Icons.edit,
          'My Profile',
          'Update your profile information',
              () => Get.to(() => const ProfileUpdateScreen()),
        ),
        const SizedBox(height: 12),

        ActionButton(
          Icons.info_outline,
          'About Us',
          'Learn more about the app',
              () => Get.to(() => const AboutUsScreen()),
        ),
        const SizedBox(height: 12),

        _buildSection(const [AppInfoSection()], radius: 12),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSection(
      List<Widget> children, {
        EdgeInsets padding = const EdgeInsets.all(20),
        double radius = 18,
      }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
