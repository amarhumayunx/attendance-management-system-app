import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/widgets/avatar_widget.dart';
class ProfileHeaderCard extends StatelessWidget {
  final User user;
  final Map<String, dynamic> data;
  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    final imageUrl = (data['imageUrl'] as String?)?.trim();
    final firstName = (data['firstName'] ?? '').toString();
    final lastName = (data['lastName'] ?? '').toString();
    final fullName = [firstName, lastName].where((e) => e.isNotEmpty).join(' ');
    final designation = (data['designation'] ?? '').toString();
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarWidget(
                imageUrl: imageUrl,
                firstName: firstName,
                lastName: lastName,
                radius: 45,
                backgroundColor: const Color(0xFF4ECDC4),
                textColor: Colors.white,
                fontSize: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 3,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isNotEmpty ? fullName : 'User',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        designation.isNotEmpty ? designation : 'Employee',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
