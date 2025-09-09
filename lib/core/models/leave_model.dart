import 'package:cloud_firestore/cloud_firestore.dart';
enum LeaveStatus { pending, approved, rejected }
class LeaveRequest {
  final String id;
  final String userId;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveStatus status;
  final Timestamp? createdAt;
  LeaveRequest({
    required this.id,
    required this.userId,
    required this.reason,
    required this.startDate,
    required this.endDate,
    this.status = LeaveStatus.pending,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'reason': reason,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status.name,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
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
    );
  }
}
LeaveStatus _statusFromString(String? v) {
  switch (v) {
    case 'approved':
      return LeaveStatus.approved;
    case 'rejected':
      return LeaveStatus.rejected;
    case 'pending':
    default:
      return LeaveStatus.pending;
  }
}
