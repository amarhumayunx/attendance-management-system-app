import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qrscanner/core/models/leave_model.dart';
import 'package:qrscanner/core/models/notification_model.dart';
import 'package:qrscanner/core/services/in_app_notification_service.dart';

class SupabaseLeaveService {
  static SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('Supabase not initialized. Please check your Supabase configuration.');
    }
  }

  static Future<String> createLeaveRequest(LeaveRequest leaveRequest) async {
    try {
      final response = await client
          .from('leave_requests')
          .insert(leaveRequest.toSupabaseMap())
          .select()
          .single();

      final leaveRequestId = response['id'] as String;

      // Create notification for admin
      await _createNotificationForAdmin(
        leaveRequestId: leaveRequestId,
        userId: leaveRequest.userId,
        title: 'New Leave Request',
        message: 'A new leave request has been submitted and requires your review.',
      );

      // Show in-app notification for user
      InAppNotificationService.showSuccess(
        title: 'Leave Request Submitted',
        message: 'Your leave request has been submitted successfully and is under review.',
      );

      return leaveRequestId;
    } catch (e) {
      throw Exception('Failed to create leave request: $e');
    }
  }

  static Future<void> _createNotificationForAdmin({
    required String leaveRequestId,
    required String userId,
    required String title,
    required String message,
  }) async {
    try {
      // Get all admin users
      final adminResponse = await client
          .from('users')
          .select('id')
          .eq('designation', 'admin');

      for (final admin in adminResponse) {
        final adminId = admin['id'] as String;
        if (adminId != userId) { // Don't notify the user who submitted the request
          final notification = AppNotification(
            id: '', // Will be set by Supabase
            userId: adminId,
            title: title,
            message: message,
            type: NotificationType.leaveRequestUpdate,
            createdAt: Timestamp.now(),
            leaveRequestId: leaveRequestId,
          );

          await client
              .from('notifications')
              .insert(notification.toSupabaseMap());
        }
      }
    } catch (e) {
      print('Error creating admin notification: $e');
    }
  }

  static Future<List<LeaveRequest>> getUserLeaveRequests(String userId) async {
    try {
      final response = await client
          .from('leave_requests')
          .select()
          .eq('userId', userId)
          .order('createdAt', ascending: false);

      return response
          .map((data) => LeaveRequest.fromSupabaseMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leave requests: $e');
    }
  }

  static Future<List<LeaveRequest>> getAllLeaveRequests() async {
    try {
      final response = await client
          .from('leave_requests')
          .select()
          .order('createdAt', ascending: false);

      return response
          .map((data) => LeaveRequest.fromSupabaseMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all leave requests: $e');
    }
  }

  static Future<void> updateLeaveRequestStatus(
    String leaveRequestId,
    LeaveStatus status, {
    String? adminNotes,
    String? adminId,
  }) async {
    try {
      final updateData = {
        'status': status.name,
        'statusUpdatedAt': DateTime.now().toIso8601String(),
        'statusUpdatedBy': adminId,
      };

      if (adminNotes != null) {
        updateData['adminNotes'] = adminNotes;
      }

      await client
          .from('leave_requests')
          .update(updateData)
          .eq('id', leaveRequestId);

      // Get the leave request to create notification for user
      final leaveRequestResponse = await client
          .from('leave_requests')
          .select()
          .eq('id', leaveRequestId)
          .single();

      if (leaveRequestResponse.isNotEmpty) {
        final leaveRequest = LeaveRequest.fromSupabaseMap(leaveRequestResponse);
        
        // Create notification for the user
        await _createNotificationForUser(
          leaveRequestId: leaveRequestId,
          userId: leaveRequest.userId,
          status: status,
          adminNotes: adminNotes,
        );

        // Show in-app notification for user
        _showInAppNotificationForUser(status, leaveRequestId);
      }
    } catch (e) {
      throw Exception('Failed to update leave request status: $e');
    }
  }

  static Future<void> _createNotificationForUser({
    required String leaveRequestId,
    required String userId,
    required LeaveStatus status,
    String? adminNotes,
  }) async {
    try {
      String title;
      String message;

      switch (status) {
        case LeaveStatus.approved:
          title = 'Leave Request Approved';
          message = 'Your leave request has been approved.';
          break;
        case LeaveStatus.rejected:
          title = 'Leave Request Rejected';
          message = 'Your leave request has been rejected.';
          break;
        case LeaveStatus.viewed:
          title = 'Leave Request Viewed';
          message = 'Your leave request has been viewed by admin.';
          break;
        default:
          title = 'Leave Request Update';
          message = 'Your leave request status has been updated.';
      }

      if (adminNotes != null && adminNotes.isNotEmpty) {
        message += '\n\nAdmin Notes: $adminNotes';
      }

      final notification = AppNotification(
        id: '', // Will be set by Supabase
        userId: userId,
        title: title,
        message: message,
        type: NotificationType.leaveRequestUpdate,
        createdAt: Timestamp.now(),
        leaveRequestId: leaveRequestId,
      );

      await client
          .from('notifications')
          .insert(notification.toSupabaseMap());
    } catch (e) {
      print('Error creating user notification: $e');
    }
  }

  static void _showInAppNotificationForUser(LeaveStatus status, String leaveRequestId) {
    switch (status) {
      case LeaveStatus.approved:
        InAppNotificationService.showLeaveRequestNotification(
          title: 'Leave Request Approved',
          message: 'Your leave request has been approved!',
          leaveRequestId: leaveRequestId,
        );
        break;
      case LeaveStatus.rejected:
        InAppNotificationService.showLeaveRequestNotification(
          title: 'Leave Request Rejected',
          message: 'Your leave request has been rejected.',
          leaveRequestId: leaveRequestId,
        );
        break;
      case LeaveStatus.viewed:
        InAppNotificationService.showLeaveRequestNotification(
          title: 'Leave Request Viewed',
          message: 'Your leave request has been viewed by admin.',
          leaveRequestId: leaveRequestId,
        );
        break;
      case LeaveStatus.pending:
        InAppNotificationService.showInfo(
          title: 'Leave Request Update',
          message: 'Your leave request status has been updated.',
        );
        break;
    }
  }

  static Future<void> deleteLeaveRequest(String leaveRequestId) async {
    try {
      await client
          .from('leave_requests')
          .delete()
          .eq('id', leaveRequestId);
    } catch (e) {
      throw Exception('Failed to delete leave request: $e');
    }
  }

  static Future<List<LeaveRequest>> getLeaveRequestsByStatus(
    LeaveStatus status,
  ) async {
    try {
      final response = await client
          .from('leave_requests')
          .select()
          .eq('status', status.name)
          .order('createdAt', ascending: false);

      return response
          .map((data) => LeaveRequest.fromSupabaseMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leave requests by status: $e');
    }
  }

  static Future<int> getPendingLeaveRequestsCount() async {
    try {
      final response = await client
          .from('leave_requests')
          .select('id')
          .eq('status', LeaveStatus.pending.name);

      return response.length;
    } catch (e) {
      throw Exception('Failed to get pending leave requests count: $e');
    }
  }

  static Stream<List<LeaveRequest>> getUserLeaveRequestsStream(String userId) {
    return client
        .from('leave_requests')
        .stream(primaryKey: ['id'])
        .eq('userId', userId)
        .order('createdAt', ascending: false)
        .map((data) => data
            .map((item) => LeaveRequest.fromSupabaseMap(item))
            .toList());
  }

  static Stream<List<LeaveRequest>> getAllLeaveRequestsStream() {
    return client
        .from('leave_requests')
        .stream(primaryKey: ['id'])
        .order('createdAt', ascending: false)
        .map((data) => data
            .map((item) => LeaveRequest.fromSupabaseMap(item))
            .toList());
  }
}
