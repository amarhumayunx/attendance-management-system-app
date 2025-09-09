import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/utils/attendance_management_utils.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/widgets/avatar_widget.dart';
import 'package:qrscanner/widgets/location_map_widget.dart';
import 'package:qrscanner/core/screens/user_attendance_detail_screen.dart';
class UserAttendanceManagementCard extends StatefulWidget {
  final Map<String, dynamic> attendance;
  final Department selectedDepartment;
  const UserAttendanceManagementCard({
    super.key,
    required this.attendance,
    required this.selectedDepartment,
  });
  @override
  State<UserAttendanceManagementCard> createState() => _UserAttendanceManagementCardState();
}
class _UserAttendanceManagementCardState extends State<UserAttendanceManagementCard> {
  bool _isTeamLeader = false;
  @override
  void initState() {
    super.initState();
    _checkTeamLeaderStatus();
  }
  Future<void> _checkTeamLeaderStatus() async {
    final isTeamLeader = await AttendanceManagementUtils.isCurrentUserTeamLeader();
    if (mounted) {
      setState(() {
        _isTeamLeader = isTeamLeader;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = widget.attendance['user'] as Map<String, dynamic>;
    final checkIn = widget.attendance['checkIn'] as String?;
    final checkOut = widget.attendance['checkOut'] as String?;
    final lat = widget.attendance['lat'] as double?;
    final lng = widget.attendance['lng'] as double?;
    final hasAttendance = widget.attendance['hasAttendance'] as bool? ?? false;

    String formattedCheckIn = AttendanceManagementUtils.formatTime(checkIn);
    String formattedCheckOut = AttendanceManagementUtils.formatTime(checkOut);
    String duration = AttendanceManagementUtils.formatDuration(checkIn, checkOut);

    print('Building card for user: ${user['firstName']}');
    print('  Raw checkIn: $checkIn');
    print('  Raw checkOut: $checkOut');
    print('  Formatted checkIn: $formattedCheckIn');
    print('  Formatted checkOut: $formattedCheckOut');
    print('  Duration: $duration');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Expanded(
                flex: 2,
                child: Container(),
              ),

              Expanded(
                child: Text(
                  'Check In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  'Check Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  'Duration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {

                        Get.to(() => UserAttendanceDetailScreen(
                          userId: user['id'] ?? '',
                          userName: '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}',
                          userDepartment: widget.selectedDepartment.name,
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AvatarWidget(
                          imageUrl: user['imageUrl'],
                          firstName: user['firstName'],
                          lastName: user['lastName'],
                          radius: 18,
                          backgroundColor: Colors.white.withOpacity(0.12),
                          textColor: Colors.white,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if ((user['employeeId'] as String?)?.isNotEmpty == true)
                          Text(
                            'ID: ${user['employeeId'] ?? ''}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  formattedCheckIn,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  formattedCheckOut,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  duration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          if (_isTeamLeader && hasAttendance && AttendanceManagementUtils.hasValidLocation(lat, lng))
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.blueAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Attendance Location',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [

                      if (AttendanceManagementUtils.hasValidLocation(lat, lng))
                        LocationMapWidget(
                          latitude: lat!,
                          longitude: lng!,
                          height: 60,
                          width: 100,
                        ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AttendanceManagementUtils.formatLocation(lat, lng),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Location where attendance was marked',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
