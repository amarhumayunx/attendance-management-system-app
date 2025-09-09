import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/services/profile_service.dart';
import 'package:qrscanner/core/screens/about_us_screen.dart';
import 'package:qrscanner/core/utils/attendance_utils.dart';
import 'package:qrscanner/widgets/avatar_widget.dart';
class UserHeader extends StatelessWidget {
  final String? uid;
  final VoidCallback onLogout;
  const UserHeader({
    super.key,
    required this.uid,
    required this.onLogout,
  });
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final emailPrefix = user?.email?.split('@').first ?? (uid ?? '');
    return Row(
      children: [
        FutureBuilder<Map<String, dynamic>?>(
          future: user != null ? ProfileService.getProfile(user) : null,
          builder: (context, profileSnap) {

            if (profileSnap.connectionState == ConnectionState.waiting) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              );
            }
            final profileData = profileSnap.data;
            final firstName = (profileData?['firstName'] ?? '').toString();
            final lastName = (profileData?['lastName'] ?? '').toString();
            return AvatarWidget(
              imageUrl: profileData?['imageUrl'],
              firstName: firstName,
              lastName: lastName,
              radius: 25,
              backgroundColor: const Color(0xFF4ECDC4),
              textColor: Colors.white,
              fontSize: 18,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: (user == null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emailPrefix.isNotEmpty ? emailPrefix : 'User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '-',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : FutureBuilder<Map<String, dynamic>?>(
                  future: ProfileService.getProfile(user),
                  builder: (context, snap) {

                    if (snap.connectionState == ConnectionState.waiting) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 14,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }
                    final data = snap.data;
                    final firstName = (data?['firstName'] ?? '').toString();
                    final lastName = (data?['lastName'] ?? '').toString();
                    final designation = (data?['designation'] ?? '').toString();
                    final displayName = [firstName, lastName]
                        .where((e) => e.isNotEmpty)
                        .join(' ');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName.isNotEmpty ? displayName : '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          designation.isNotEmpty ? AttendanceUtils.titleCase(designation) : '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
        ),
        IconButton(
          onPressed: () => _showUserMenu(context, emailPrefix, user),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
  void _showUserMenu(BuildContext context, String emailPrefix, User? user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(
                emailPrefix.isNotEmpty ? emailPrefix : (user?.email ?? 'User'),
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                user?.email ?? '',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
            const Divider(height: 0, color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                Get.to(() => AboutUsScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
