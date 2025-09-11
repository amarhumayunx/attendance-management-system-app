import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';
import '../../widgets/profile_content_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: AbstractBackgroundWrapper(
        child: SafeArea(
          top: true,
          bottom: false,
          child: FutureBuilder<Map<String, dynamic>?>(
            future: ProfileService.getProfile(user!),
            builder: (context, snap) {
              if (!snap.hasData) {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: Colors.white,
                    size: 30,
                  ),
                );
              }
              final data = snap.data;
              if (data == null) {
                return const NoProfileCard();
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120,left: 20,right: 20,top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileContent(user, data),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
