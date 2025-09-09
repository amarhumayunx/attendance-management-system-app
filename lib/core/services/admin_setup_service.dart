import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscanner/core/models/user_model.dart';
class AdminSetupService {
  static const String adminEmail = 'admin@zeepalm.com';
  static const String adminPassword = 'amar2627';

  static Future<void> createDefaultAdmin() async {
    try {

      final adminQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: adminEmail)
          .limit(1)
          .get();
      if (adminQuery.docs.isNotEmpty) {
        print('Admin user already exists');
        return;
      }

      final allAdminsQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('designation', isEqualTo: 'admin')
          .get();
      if (allAdminsQuery.docs.isNotEmpty) {
        print('Admin user already exists with different email');
        return;
      }

      UserCredential? credential;
      try {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          print('Admin email already exists in Firebase Auth');

          try {
            credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: adminEmail,
              password: adminPassword,
            );
          } catch (signInError) {
            print('Error signing in existing admin: $signInError');
            return;
          }
        } else {
          print('Error creating admin auth account: $e');
          return;
        }
      }
      final user = credential.user;
      if (user == null) {
        print('Failed to get user from credential');
        return;
      }

      final adminUser = AppUser(
        id: user.uid,
        firstName: 'Admin',
        lastName: 'User',
        email: adminEmail,
        password: adminPassword,
        designation: Designation.employee,
        department: Department.humanResources,
        employeeType: EmployeeType.permanent,
        branchCode: BranchCode.eme,
        employeeId: 'ZP-HR-EME-ADMIN',
        phone: '-',
        address: 'Zeepalm Office',
        salary: 0,
      );

      final adminData = adminUser.toMap();
      adminData['designation'] = 'admin';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(adminData);

      await FirebaseAuth.instance.signOut();
      print('Default admin user created successfully');
      print('Admin user data: $adminData');

      final verifyQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: adminEmail)
          .get();
      print('Admin user verification: ${verifyQuery.docs.length} documents found');
      if (verifyQuery.docs.isNotEmpty) {
        print('Admin user document: ${verifyQuery.docs.first.data()}');
      }
    } catch (e) {
      print('Error creating default admin: $e');
    }
  }

  static bool isAdminEmail(String email) {
    return email.toLowerCase().trim() == adminEmail;
  }

  static bool validateAdminCredentials(String email, String password) {
    return email.toLowerCase().trim() == adminEmail && password == adminPassword;
  }
}
