import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/models/document_model.dart';
class ProfileService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static String _docIdForUser(User user) {

    return user.uid;
  }
  static Future<DocumentReference<Map<String, dynamic>>?> _resolveUserDocRef(User user) async {
    final users = _db.collection('users');

    final uidRef = users.doc(_docIdForUser(user));
    final uidSnap = await uidRef.get();
    if (uidSnap.exists) return uidRef;

    final email = user.email;
    if (email != null && email.isNotEmpty) {
      final emailRef = users.doc(email);
      final emailSnap = await emailRef.get();
      if (emailSnap.exists) return emailRef;
      final prefix = email.contains('@') ? email.split('@').first : email;
      final prefixRef = users.doc(prefix);
      final prefixSnap = await prefixRef.get();
      if (prefixSnap.exists) return prefixRef;
      final q = await users.where('email', isEqualTo: email.toLowerCase()).limit(1).get();
      if (q.docs.isNotEmpty) {
        return users.doc(q.docs.first.id);
      }
    }
    return null;
  }
  static Future<Map<String, dynamic>?> getProfile(User user) async {
    final ref = await _resolveUserDocRef(user);
    if (ref != null) {
      final snap = await ref.get();
      return snap.data();
    }

    return null;
  }
  static Future<Map<String, dynamic>?> getProfileById(String userId) async {
    try {
      final docRef = _db.collection('users').doc(userId);
      final snap = await docRef.get();
      if (snap.exists) {
        return snap.data();
      }
      return null;
    } catch (e) {
      print('Error getting profile by ID: $e');
      return null;
    }
  }
  static Future<void> updateProfile(User user, Map<String, dynamic> data) async {
    final existing = await _resolveUserDocRef(user);
    if (existing != null) {
      await existing.set(data, SetOptions(merge: true));
      return;
    }
    final id = _docIdForUser(user);
    await _db.collection('users').doc(id).set(data, SetOptions(merge: true));
  }
  static Future<List<UserDocument>> getDocuments(User user) async {
    final ref = await _resolveUserDocRef(user);
    final base = ref ?? _db.collection('users').doc(_docIdForUser(user));
    final query = await base.collection('documents').orderBy('uploadedAt', descending: true).get();
    return query.docs.map((d) => UserDocument.fromMap(d.data(), d.id)).toList();
  }
  static Future<void> addDocument(User user, UserDocument doc) async {
    final userRef = await _resolveUserDocRef(user);
    final base = userRef ?? _db.collection('users').doc(_docIdForUser(user));
    final ref = base.collection('documents').doc(doc.id);
    await ref.set(doc.toMap());
  }

  static Future<List<Map<String, dynamic>>> getAllEmployees() async {
    try {
      final querySnapshot = await _db.collection('users').get();
      final employees = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'firstName': data['firstName'] ?? '',
          'lastName': data['lastName'] ?? '',
          'email': data['email'] ?? '',
          'phone': data['phone'] ?? '',
          'address': data['address'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'employeeId': data['employeeId'] ?? '',
          'department': data['department'] ?? '',
          'designation': data['designation'] ?? '',
          'employeeType': data['employeeType'] ?? '',
          'branchCode': data['branchCode'] ?? '',
          'officeStartTime': data['officeStartTime'] ?? '',
          'officeEndTime': data['officeEndTime'] ?? '',
        };
      }).toList();

      return employees.where((emp) => emp['designation'] != 'admin').toList();
    } catch (e) {
      print('Error fetching all employees: $e');
      return [];
    }
  }
}
