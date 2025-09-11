import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qrscanner/core/models/notification_model.dart';

class SupabaseNotificationService {
  static SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('Supabase not initialized. Please check your Supabase configuration.');
    }
  }

  static Future<List<AppNotification>> getUserNotifications(String userId) async {
    try {
      final response = await client
          .from('notifications')
          .select()
          .eq('userId', userId)
          .order('createdAt', ascending: false);

      return response
          .map((data) => AppNotification.fromSupabaseMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  static Stream<List<AppNotification>> getUserNotificationsStream(String userId) {
    return client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('userId', userId)
        .order('createdAt', ascending: false)
        .map((data) => data
            .map((item) => AppNotification.fromSupabaseMap(item))
            .toList());
  }

  static Future<int> getUnreadNotificationsCount(String userId) async {
    try {
      final response = await client
          .from('notifications')
          .select('id')
          .eq('userId', userId)
          .eq('isRead', false);

      return response.length;
    } catch (e) {
      throw Exception('Failed to get unread notifications count: $e');
    }
  }

  static Stream<int> getUnreadNotificationsCountStream(String userId) {
    return client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('userId', userId)
        .map((data) => data.where((item) => item['isRead'] == false).length);
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await client
          .from('notifications')
          .update({'isRead': true})
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  static Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      await client
          .from('notifications')
          .update({'isRead': true})
          .eq('userId', userId)
          .eq('isRead', false);
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  static Future<void> deleteNotification(String notificationId) async {
    try {
      await client
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  static Future<void> createNotification(AppNotification notification) async {
    try {
      await client
          .from('notifications')
          .insert(notification.toSupabaseMap());
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }
}
