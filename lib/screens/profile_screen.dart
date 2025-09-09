import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/widgets/profile_header_card.dart';
import 'package:qrscanner/widgets/personal_info_card.dart';
import 'package:qrscanner/widgets/employee_details_card.dart';
import 'package:qrscanner/widgets/no_profile_card.dart';

import '../core/services/profile_service.dart';

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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

              return _buildProfileContent(context, user, data);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Profile Header Card
        ProfileHeaderCard(user: user, data: data),

        const SizedBox(height: 24),

        // Personal Information Card
        PersonalInfoCard(data: data),

        // Employee Details Card (if available)
        if (data['employeeId'] != null || data['department'] != null || data['employeeType'] != null || data['branchCode'] != null) ...[
          const SizedBox(height: 24),
          EmployeeDetailsCard(data: data),
        ],

        const SizedBox(height: 10),


        const SizedBox(height: 100), // Bottom padding for navigation bar
      ],
    );
  }
}