import 'package:flutter/material.dart';
import 'package:qrscanner/widgets/detail_grid_widget.dart';
import 'package:qrscanner/core/utils/profile_utils.dart';
class EmployeeDetailsCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const EmployeeDetailsCard({
    super.key,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB84D), Color(0xFFFF8A50)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.work,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Employee Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (data['employeeId'] != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Employee ID',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['employeeId'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          DetailGridWidget(
            items: [
              if (data['department'] != null)
                DetailItem('Department', ProfileUtils.getDepartmentDisplayName(data['department']), Icons.business),
              if (data['employeeType'] != null)
                DetailItem('Employee Type', ProfileUtils.getEmployeeTypeDisplayName(data['employeeType']), Icons.person_pin),
              if (data['branchCode'] != null)
                DetailItem('Branch Code', ProfileUtils.getBranchCodeDisplayName(data['branchCode']), Icons.location_city),
            ].where((item) => true).toList(),
          ),
        ],
      ),
    );
  }
}
