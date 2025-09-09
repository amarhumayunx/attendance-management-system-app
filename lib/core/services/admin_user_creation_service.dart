import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/models/user_model.dart';
import 'package:qrscanner/core/services/employee_id_service.dart';
class AdminUserCreationService {

  static Future<Map<String, dynamic>> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String age,
    required String dob,
    required String doj,
    required Designation designation,
    required Department department,
    required EmployeeType employeeType,
    required BranchCode branchCode,
    required String imageUrl,
    required String address,
    required String phone,
    required String salary,
    required String officeStartTime,
    required String officeEndTime,
  }) async {
    try {
      final emailLower = email.trim().toLowerCase();

      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailLower,
          password: password,
        );
        final uid = credential.user?.uid;
        if (uid == null) {
          throw FirebaseAuthException(code: 'unknown', message: 'Failed to obtain UID after account creation');
        }

        final employeeId = await EmployeeIdService.generateEmployeeId(department, branchCode);

        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        final user = AppUser(
          id: uid,
          firstName: firstName.trim(),
          lastName: lastName.trim(),
          email: emailLower,
          password: password,
          age: age.trim().isEmpty ? null : age.trim(),
          dob: dob.trim().isEmpty ? null : dob.trim(),
          dateOfJoining: doj.trim().isEmpty ? null : doj.trim(),
          designation: designation,
          department: department,
          employeeType: employeeType,
          branchCode: branchCode,
          employeeId: employeeId,
          imageUrl: imageUrl.trim().isEmpty ? null : imageUrl.trim(),
          address: address.trim().isEmpty ? null : address.trim(),
          phone: phone.trim().isEmpty ? null : phone.trim(),
          salary: salary.trim().isEmpty ? null : num.tryParse(salary.trim()),
          officeStartTime: officeStartTime.trim().isEmpty ? null : officeStartTime.trim(),
          officeEndTime: officeEndTime.trim().isEmpty ? null : officeEndTime.trim(),
        );
        await docRef.set(user.toMap());

        await FirebaseAuth.instance.signOut();
        return {
          'success': true,
          'message': 'User created successfully! Redirecting to Login.',
          'shouldRedirect': true,
        };
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          return {
            'success': false,
            'message': 'User already exists. Auth account creation skipped.',
            'shouldRedirect': false,
            'error': e.message ?? e.code,
          };
        } else {
          return {
            'success': false,
            'message': 'Auth account creation failed: ${e.message ?? e.code}',
            'shouldRedirect': false,
            'error': e.message ?? e.code,
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error creating user: $e',
        'shouldRedirect': false,
        'error': e.toString(),
      };
    }
  }
}
