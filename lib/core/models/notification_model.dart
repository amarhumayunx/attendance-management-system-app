import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { leaveRequestUpdate, general }

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final Timestamp createdAt;
  final String? leaveRequestId;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.leaveRequestId,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'isRead': isRead,
      'createdAt': createdAt,
      'leaveRequestId': leaveRequestId,
      'data': data,
    };
  }

  factory AppNotification.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return AppNotification(
      id: doc.id,
      userId: d['userId'] as String,
      title: d['title'] as String,
      message: d['message'] as String,
      type: _typeFromString(d['type'] as String?),
      isRead: d['isRead'] as bool? ?? false,
      createdAt: d['createdAt'] as Timestamp,
      leaveRequestId: d['leaveRequestId'] as String?,
      data: d['data'] as Map<String, dynamic>?,
    );
  }

  AppNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    Timestamp? createdAt,
    String? leaveRequestId,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      leaveRequestId: leaveRequestId ?? this.leaveRequestId,
      data: data ?? this.data,
    );
  }

  // Supabase methods
  Map<String, dynamic> toSupabaseMap() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'isRead': isRead,
      'createdAt': createdAt.toDate().toIso8601String(),
      'leaveRequestId': leaveRequestId,
      'data': data,
    };
  }

  factory AppNotification.fromSupabaseMap(Map<String, dynamic> data) {
    return AppNotification(
      id: data['id']?.toString() ?? '',
      userId: data['userId'] as String,
      title: data['title'] as String,
      message: data['message'] as String,
      type: _typeFromString(data['type'] as String?),
      isRead: data['isRead'] as bool? ?? false,
      createdAt: Timestamp.fromDate(DateTime.parse(data['createdAt'] as String)),
      leaveRequestId: data['leaveRequestId'] as String?,
      data: data['data'] as Map<String, dynamic>?,
    );
  }
}

NotificationType _typeFromString(String? v) {
  switch (v) {
    case 'leaveRequestUpdate':
      return NotificationType.leaveRequestUpdate;
    case 'general':
    default:
      return NotificationType.general;
  }
}
