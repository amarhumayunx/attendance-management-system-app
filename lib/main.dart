import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrscanner/core/screens/myapp.dart';
import 'package:qrscanner/core/services/admin_setup_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AdminSetupService.createDefaultAdmin();
  runApp(const MyApp());
}
