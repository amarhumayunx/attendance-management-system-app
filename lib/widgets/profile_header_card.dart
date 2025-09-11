import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                backgroundColor: Colors.white,
                textColor: Colors.black,
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
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isNotEmpty ? fullName : 'User',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      child: Text(
                        designation.isNotEmpty ? designation : 'Employee',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
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
