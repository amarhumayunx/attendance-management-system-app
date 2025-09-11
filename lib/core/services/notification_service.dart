import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscanner/core/models/notification_model.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'notifications';

  static Future<List<AppNotification>> getUserNotifications(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AppNotification.fromDoc(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  static Stream<List<AppNotification>> getUserNotificationsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromDoc(doc))
            .toList());
  }

  static Future<int> getUnreadNotificationsCount(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread notifications count: $e');
    }
  }

  static Stream<int> getUnreadNotificationsCountStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  static Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  static Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection(_collection).doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  static Future<void> createNotification(AppNotification notification) async {
    try {
      await _firestore.collection(_collection).add(notification.toMap());
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }
}
