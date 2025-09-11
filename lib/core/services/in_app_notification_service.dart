import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/lib_exports.dart';

class InAppNotificationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // Show a success notification
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _showNotification(
      title: title,
      message: message,
      type: InAppNotificationType.success,
      duration: duration,
      onTap: onTap,
    );
  }

  // Show an error notification
  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    _showNotification(
      title: title,
      message: message,
      type: InAppNotificationType.error,
      duration: duration,
      onTap: onTap,
    );
  }

  // Show an info notification
  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _showNotification(
      title: title,
      message: message,
      type: InAppNotificationType.info,
      duration: duration,
      onTap: onTap,
    );
  }

  // Show a warning notification
  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _showNotification(
      title: title,
      message: message,
      type: InAppNotificationType.warning,
      duration: duration,
      onTap: onTap,
    );
  }

  // Show a leave request notification
  static void showLeaveRequestNotification({
    required String title,
    required String message,
    required String leaveRequestId,
    Duration duration = const Duration(seconds: 5),
  }) {
    _showNotification(
      title: title,
      message: message,
      type: InAppNotificationType.leaveRequest,
      duration: duration,
      onTap: () => _navigateToLeaveRequest(leaveRequestId),
    );
  }

  // Private method to show notification
  static void _showNotification({
    required String title,
    required String message,
    required InAppNotificationType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Show the notification overlay
    _showNotificationOverlay(
      context: context,
      title: title,
      message: message,
      type: type,
      duration: duration,
      onTap: onTap,
    );
  }

  // Show notification overlay
  static void _showNotificationOverlay({
    required BuildContext context,
    required String title,
    required String message,
    required InAppNotificationType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _NotificationOverlay(
        title: title,
        message: message,
        type: type,
        onTap: onTap,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  // Navigate to leave request details
  static void _navigateToLeaveRequest(String leaveRequestId) {
    // Navigate to leave request details or user's leave requests screen
    Get.to(() => const LeaveScreen());
  }
}

enum InAppNotificationType {
  success,
  error,
  info,
  warning,
  leaveRequest,
}

class _NotificationOverlay extends StatefulWidget {
  final String title;
  final String message;
  final InAppNotificationType type;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _NotificationOverlay({
    required this.title,
    required this.message,
    required this.type,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<_NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<_NotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 16,
      left: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getIconBackgroundColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getIcon(),
                        color: _getIconColor(),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: AppTypography.kMedium14.copyWith(
                              color: _getTextColor(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.message,
                            style: AppTypography.kRegular12.copyWith(
                              color: _getTextColor().withOpacity(0.8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _getTextColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close,
                          color: _getTextColor().withOpacity(0.6),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case InAppNotificationType.success:
        return AppColors.kSuccess.withOpacity(0.1);
      case InAppNotificationType.error:
        return AppColors.kError.withOpacity(0.1);
      case InAppNotificationType.warning:
        return AppColors.kWarning.withOpacity(0.1);
      case InAppNotificationType.info:
        return AppColors.kInfo.withOpacity(0.1);
      case InAppNotificationType.leaveRequest:
        return AppColors.kPrimary.withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (widget.type) {
      case InAppNotificationType.success:
        return AppColors.kSuccess.withOpacity(0.3);
      case InAppNotificationType.error:
        return AppColors.kError.withOpacity(0.3);
      case InAppNotificationType.warning:
        return AppColors.kWarning.withOpacity(0.3);
      case InAppNotificationType.info:
        return AppColors.kInfo.withOpacity(0.3);
      case InAppNotificationType.leaveRequest:
        return AppColors.kPrimary.withOpacity(0.3);
    }
  }

  Color _getIconBackgroundColor() {
    switch (widget.type) {
      case InAppNotificationType.success:
        return AppColors.kSuccess.withOpacity(0.2);
      case InAppNotificationType.error:
        return AppColors.kError.withOpacity(0.2);
      case InAppNotificationType.warning:
        return AppColors.kWarning.withOpacity(0.2);
      case InAppNotificationType.info:
        return AppColors.kInfo.withOpacity(0.2);
      case InAppNotificationType.leaveRequest:
        return AppColors.kPrimary.withOpacity(0.2);
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case InAppNotificationType.success:
        return AppColors.kSuccess;
      case InAppNotificationType.error:
        return AppColors.kError;
      case InAppNotificationType.warning:
        return AppColors.kWarning;
      case InAppNotificationType.info:
        return AppColors.kInfo;
      case InAppNotificationType.leaveRequest:
        return AppColors.kPrimary;
    }
  }

  Color _getTextColor() {
    return AppColors.kTextPrimary;
  }

  IconData _getIcon() {
    switch (widget.type) {
      case InAppNotificationType.success:
        return Icons.check_circle;
      case InAppNotificationType.error:
        return Icons.error;
      case InAppNotificationType.warning:
        return Icons.warning;
      case InAppNotificationType.info:
        return Icons.info;
      case InAppNotificationType.leaveRequest:
        return Icons.event_note;
    }
  }
}
