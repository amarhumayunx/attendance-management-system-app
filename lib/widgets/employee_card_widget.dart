import 'package:flutter/material.dart';
import 'package:qrscanner/core/utils/profile_utils.dart';
class EmployeeCardWidget extends StatelessWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onTap;
  const EmployeeCardWidget({
    super.key,
    required this.employee,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final firstName = employee['firstName'] ?? '';
    final lastName = employee['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final email = employee['email'] ?? '';
    final department = employee['department'] ?? '';
    final designation = employee['designation'] ?? '';
    final imageUrl = employee['imageUrl'] ?? '';
    final phone = employee['phone'] ?? '';
    final address = employee['address'] ?? '';
    final employeeId = employee['employeeId'] ?? '';
    final isTeamLeader = designation == 'teamLeader';
    final isAdmin = designation == 'admin';
    final isActive = employee['isActive'] ?? true;
    final officeStartTime = employee['officeStartTime'] ?? '';
    final officeEndTime = employee['officeEndTime'] ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: isAdmin 
                              ? Colors.purple.withOpacity(0.8)
                              : const Color(0xFF4ECDC4).withOpacity(0.8),
                          backgroundImage: imageUrl.isNotEmpty 
                              ? NetworkImage(imageUrl) 
                              : null,
                          child: imageUrl.isEmpty 
                              ? Text(
                                  fullName.isNotEmpty 
                                      ? fullName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').join('').toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        if (isTeamLeader)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: const Text(
                                'TL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (isAdmin)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: const Text(
                                'ADMIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          if (employeeId.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'ID: $employeeId',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                isActive ? Icons.check_circle : Icons.cancel,
                                color: isActive ? Colors.green : Colors.red,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: isActive ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (department.isNotEmpty || designation.isNotEmpty) ...[
                  Row(
                    children: [
                      if (department.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF4ECDC4).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            ProfileUtils.getDepartmentDisplayName(department),
                            style: const TextStyle(
                              color: Color(0xFF4ECDC4),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (designation.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getDesignationDisplayName(designation),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        officeStartTime.isNotEmpty && officeEndTime.isNotEmpty
                            ? 'Working Hours: $officeStartTime - $officeEndTime'
                            : 'Working Hours: 10:00 AM - 07:00 PM (Default)',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                if (phone.isNotEmpty || address.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (phone.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.white.withOpacity(0.6),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                phone,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          if (address.isNotEmpty) const SizedBox(height: 8),
                        ],
                        if (address.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.6),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  address,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  String _getDesignationDisplayName(String designation) {
    switch (designation) {
      case 'admin':
        return 'Admin';
      case 'teamLeader':
        return 'Team Leader';
      case 'manager':
        return 'Manager';
      case 'employee':
        return 'Employee';
      default:
        return 'Employee';
    }
  }
}
