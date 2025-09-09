import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrscanner/widgets/avatar_widget.dart';
class UserProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final String userDepartment;
  const UserProfileCard({
    super.key,
    required this.profile,
    required this.userDepartment,
  });
  String _formatJoiningDate(String? joiningDateString) {
    if (joiningDateString == null || joiningDateString.isEmpty) return 'N/A';
    try {

      final parts = joiningDateString.split('-');
      if (parts.length >= 2) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final joiningDate = DateTime(year, month, 1);
        return DateFormat('MMM yyyy').format(joiningDate);
      } else {
        return joiningDateString;
      }
    } catch (e) {
      print('Error formatting joining date: $e');
      return joiningDateString;
    }
  }
  @override
  Widget build(BuildContext context) {
    final firstName = profile['firstName']?.toString() ?? '';
    final lastName = profile['lastName']?.toString() ?? '';
    final employeeId = profile['employeeId']?.toString() ?? 'N/A';
    final displayName = [firstName, lastName].where((e) => e.isNotEmpty).join(' ');
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3460), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          AvatarWidget(
            imageUrl: profile['imageUrl'],
            firstName: firstName,
            lastName: lastName,
            radius: 60,
            backgroundColor: const Color(0xFF4ECDC4),
            textColor: Colors.white,
            fontSize: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            displayName.isNotEmpty ? displayName : 'Unknown User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Employee ID: $employeeId',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userDepartment,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),

          if (profile['dateOfJoining'] != null && (profile['dateOfJoining'] as String).isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Joined: ${_formatJoiningDate(profile['dateOfJoining'])}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
