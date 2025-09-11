import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
            'Notifications',
            style: AppTypography.kMedium18,
          ),
          centerTitle: true,
          actions: [
            StreamBuilder<int>(
              stream: SupabaseNotificationService.getUnreadNotificationsCountStream(user.uid),
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;
                if (unreadCount == 0) return const SizedBox.shrink();
                
                return IconButton(
                  onPressed: () => _markAllAsRead(user.uid),
                  icon: Stack(
                    children: [
                      const Icon(Icons.mark_email_read),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.kError,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: AppTypography.kRegular10.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  tooltip: 'Mark all as read',
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: StreamBuilder<List<AppNotification>>(
            stream: SupabaseNotificationService.getUserNotificationsStream(user.uid),
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
                        'Error loading notifications',
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

              final notifications = snapshot.data ?? [];

              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        color: AppColors.kTextMuted,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: AppTypography.kMedium16,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You don\'t have any notifications yet.',
                        style: AppTypography.kRegular14.copyWith(
                          color: AppColors.kTextMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(22),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(notification);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.kSurface.withOpacity(0.3)
            : AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? AppColors.kBorder.withOpacity(0.5)
              : AppColors.kPrimary.withOpacity(0.3),
          width: notification.isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getNotificationIconColor(notification.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationIconColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.kMedium14.copyWith(
                              color: notification.isRead
                                  ? AppColors.kTextSecondary
                                  : AppColors.kTextPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.kPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: AppTypography.kRegular12.copyWith(
                        color: AppColors.kTextMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.kTextMuted,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTimeAgo(notification.createdAt),
                          style: AppTypography.kRegular10.copyWith(
                            color: AppColors.kTextMuted,
                          ),
                        ),
                        const Spacer(),
                        if (notification.type == NotificationType.leaveRequestUpdate)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Leave Request',
                              style: AppTypography.kRegular10.copyWith(
                                color: AppColors.kPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.leaveRequestUpdate:
        return Icons.event_note;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getNotificationIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.leaveRequestUpdate:
        return AppColors.kPrimary;
      case NotificationType.general:
        return AppColors.kInfo;
    }
  }

  void _handleNotificationTap(AppNotification notification) async {
    // Mark as read if not already read
    if (!notification.isRead) {
      await SupabaseNotificationService.markNotificationAsRead(notification.id);
    }

    // Handle navigation based on notification type
    if (notification.type == NotificationType.leaveRequestUpdate &&
        notification.leaveRequestId != null) {
      _navigateToLeaveRequest(notification.leaveRequestId!);
    }
  }

  void _navigateToLeaveRequest(String leaveRequestId) {
    // Navigate to leave request details or user's leave requests screen
    // For now, we'll show a dialog with the leave request ID
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface,
        title: Text(
          'Leave Request',
          style: AppTypography.kMedium16,
        ),
        content: Text(
          'Leave Request ID: $leaveRequestId\n\nThis would normally open the specific leave request details.',
          style: AppTypography.kRegular14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: AppTypography.kMedium14.copyWith(
                color: AppColors.kPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markAllAsRead(String userId) async {
    try {
      await SupabaseNotificationService.markAllNotificationsAsRead(userId);
      InAppNotificationService.showSuccess(
        title: 'Notifications Updated',
        message: 'All notifications marked as read',
      );
    } catch (e) {
      InAppNotificationService.showError(
        title: 'Update Failed',
        message: 'Error marking notifications as read: $e',
      );
    }
  }

  String _getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
