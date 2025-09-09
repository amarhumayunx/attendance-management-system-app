import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscanner/core/models/leave_model.dart';
class LeaveService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'leave_requests';

  static Future<String> createLeaveRequest(LeaveRequest leaveRequest) async {
    try {
      final docRef = await _firestore.collection(_collection).add(leaveRequest.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create leave request: $e');
    }
  }

  static Future<List<LeaveRequest>> getUserLeaveRequests(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => LeaveRequest.fromDoc(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leave requests: $e');
    }
  }

  static Future<List<LeaveRequest>> getAllLeaveRequests() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => LeaveRequest.fromDoc(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all leave requests: $e');
    }
  }

  static Future<void> updateLeaveRequestStatus(
    String leaveRequestId,
    LeaveStatus status,
  ) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(leaveRequestId)
          .update({'status': status.name});
    } catch (e) {
      throw Exception('Failed to update leave request status: $e');
    }
  }

  static Future<void> deleteLeaveRequest(String leaveRequestId) async {
    try {
      await _firestore.collection(_collection).doc(leaveRequestId).delete();
    } catch (e) {
      throw Exception('Failed to delete leave request: $e');
    }
  }

  static Future<List<LeaveRequest>> getLeaveRequestsByStatus(
    LeaveStatus status,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => LeaveRequest.fromDoc(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leave requests by status: $e');
    }
  }

  static Future<int> getPendingLeaveRequestsCount() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: LeaveStatus.pending.name)
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get pending leave requests count: $e');
    }
  }

  static Stream<List<LeaveRequest>> getUserLeaveRequestsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaveRequest.fromDoc(doc))
            .toList());
  }

  static Stream<List<LeaveRequest>> getAllLeaveRequestsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaveRequest.fromDoc(doc))
            .toList());
  }
}
