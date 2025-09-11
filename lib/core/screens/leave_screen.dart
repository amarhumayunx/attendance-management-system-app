import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';


class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});
  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return AbstractBackgroundWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'My Leave Requests',
            style: AppTypography.kMedium18,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => Get.to(() => const LeaveRequestScreen()),
              icon: const Icon(Icons.add),
              tooltip: 'Submit New Request',
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: StreamBuilder<List<LeaveRequest>>(
            stream: SupabaseLeaveService.getUserLeaveRequestsStream(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: Colors.white,
                    size: 30,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.kError,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading leave requests',
                        style: AppTypography.kMedium16,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: AppTypography.kRegular14.copyWith(
                          color: AppColors.kTextMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: AppTypography.kMedium14.copyWith(
                            color: Colors.white,
                          ),
                          ),
                        ),
                      ],
                  ),
                );
              }

              final leaveRequests = snapshot.data ?? [];

              if (leaveRequests.isEmpty) {
                return Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(
                        Icons.event_note_outlined,
                        color: AppColors.kTextMuted,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No leave requests',
                        style: AppTypography.kMedium16,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You haven\'t submitted any leave requests yet.',
                        style: AppTypography.kRegular14.copyWith(
                          color: AppColors.kTextMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Get.to(() => const LeaveRequestScreen()),
                        icon: const Icon(Icons.add),
                        label: const Text('Submit New Request'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(22),
                itemCount: leaveRequests.length,
                itemBuilder: (context, index) {
                  final leaveRequest = leaveRequests[index];
                  return _buildLeaveRequestCard(leaveRequest);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveRequestCard(LeaveRequest leaveRequest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        'Leave Request',
                        style: AppTypography.kMedium16,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDate(leaveRequest.startDate)} - ${_formatDate(leaveRequest.endDate)}',
                        style: AppTypography.kRegular14.copyWith(
                          color: AppColors.kTextSecondary,
                        ),
                      ),
                              ],
                            ),
                          ),
                _buildStatusChip(leaveRequest.status),
              ],
                        ),
                        const SizedBox(height: 12),
            Text(
              leaveRequest.reason,
              style: AppTypography.kRegular14,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
                              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.kTextMuted,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Submitted ${_getTimeAgo(leaveRequest.createdAt)}',
                  style: AppTypography.kRegular12.copyWith(
                    color: AppColors.kTextMuted,
                  ),
                ),
                const Spacer(),
                if (leaveRequest.imageUrls != null && leaveRequest.imageUrls!.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.attach_file,
                        color: AppColors.kPrimary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${leaveRequest.imageUrls!.length} attachment(s)',
                        style: AppTypography.kRegular12.copyWith(
                          color: AppColors.kPrimary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (leaveRequest.adminNotes != null && leaveRequest.adminNotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.kCardBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.kBorder.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Notes',
                      style: AppTypography.kMedium12.copyWith(
                        color: AppColors.kPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      leaveRequest.adminNotes!,
                      style: AppTypography.kRegular12,
                  ),
                ],
              ),
            ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(LeaveStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case LeaveStatus.pending:
        backgroundColor = AppColors.kWarning.withOpacity(0.2);
        textColor = AppColors.kWarning;
        break;
      case LeaveStatus.approved:
        backgroundColor = AppColors.kSuccess.withOpacity(0.2);
        textColor = AppColors.kSuccess;
        break;
      case LeaveStatus.rejected:
        backgroundColor = AppColors.kError.withOpacity(0.2);
        textColor = AppColors.kError;
        break;
      case LeaveStatus.viewed:
        backgroundColor = AppColors.kInfo.withOpacity(0.2);
        textColor = AppColors.kInfo;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusDisplayName(status),
        style: AppTypography.kMedium12.copyWith(
          color: textColor,
        ),
      ),
    );
  }

  String _getStatusDisplayName(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.viewed:
        return 'Viewed';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
