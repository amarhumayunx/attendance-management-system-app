import 'package:cloud_firestore/cloud_firestore.dart';

enum LeaveStatus { pending, approved, viewed, rejected }

class LeaveRequest {
  final String id;
  final String userId;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveStatus status;
  final Timestamp? createdAt;
  final List<String>? imageUrls;
  final String? adminNotes;
  final Timestamp? statusUpdatedAt;
  final String? statusUpdatedBy;

  LeaveRequest({
    required this.id,
    required this.userId,
    required this.reason,
    required this.startDate,
    required this.endDate,
    this.status = LeaveStatus.pending,
    this.createdAt,
    this.imageUrls,
    this.adminNotes,
    this.statusUpdatedAt,
    this.statusUpdatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'reason': reason,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status.name,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'imageUrls': imageUrls ?? [],
      'adminNotes': adminNotes,
      'statusUpdatedAt': statusUpdatedAt,
      'statusUpdatedBy': statusUpdatedBy,
    };
  }

  factory LeaveRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return LeaveRequest(
      id: doc.id,
      userId: d['userId'] as String,
      reason: d['reason'] as String,
      startDate: (d['startDate'] as Timestamp).toDate(),
      endDate: (d['endDate'] as Timestamp).toDate(),
      status: _statusFromString(d['status'] as String?),
      createdAt: d['createdAt'] as Timestamp?,
      imageUrls: (d['imageUrls'] as List<dynamic>?)?.cast<String>(),
      adminNotes: d['adminNotes'] as String?,
      statusUpdatedAt: d['statusUpdatedAt'] as Timestamp?,
      statusUpdatedBy: d['statusUpdatedBy'] as String?,
    );
  }

  LeaveRequest copyWith({
    String? id,
    String? userId,
    String? reason,
    DateTime? startDate,
    DateTime? endDate,
    LeaveStatus? status,
    Timestamp? createdAt,
    List<String>? imageUrls,
    String? adminNotes,
    Timestamp? statusUpdatedAt,
    String? statusUpdatedBy,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reason: reason ?? this.reason,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      adminNotes: adminNotes ?? this.adminNotes,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
      statusUpdatedBy: statusUpdatedBy ?? this.statusUpdatedBy,
    );
  }

  // Supabase methods
  Map<String, dynamic> toSupabaseMap() {
    return {
      'userId': userId,
      'reason': reason,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'createdAt': createdAt?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
      'imageUrls': imageUrls ?? [],
      'adminNotes': adminNotes,
      'statusUpdatedAt': statusUpdatedAt?.toDate().toIso8601String(),
      'statusUpdatedBy': statusUpdatedBy,
    };
  }

  factory LeaveRequest.fromSupabaseMap(Map<String, dynamic> data) {
    return LeaveRequest(
      id: data['id']?.toString() ?? '',
      userId: data['userId'] as String,
      reason: data['reason'] as String,
      startDate: DateTime.parse(data['startDate'] as String),
      endDate: DateTime.parse(data['endDate'] as String),
      status: _statusFromString(data['status'] as String?),
      createdAt: data['createdAt'] != null ? Timestamp.fromDate(DateTime.parse(data['createdAt'] as String)) : null,
      imageUrls: (data['imageUrls'] as List<dynamic>?)?.cast<String>(),
      adminNotes: data['adminNotes'] as String?,
      statusUpdatedAt: data['statusUpdatedAt'] != null ? Timestamp.fromDate(DateTime.parse(data['statusUpdatedAt'] as String)) : null,
      statusUpdatedBy: data['statusUpdatedBy'] as String?,
    );
  }
}

LeaveStatus _statusFromString(String? v) {
  switch (v) {
    case 'approved':
      return LeaveStatus.approved;
    case 'viewed':
      return LeaveStatus.viewed;
    case 'rejected':
      return LeaveStatus.rejected;
    case 'pending':
    default:
      return LeaveStatus.pending;
  }
}
