import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/services/in_app_notification_service.dart';
import 'package:qrscanner/core/utils/responsive_utils.dart';
import 'package:qrscanner/widgets/auth_wrapper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: InAppNotificationService.navigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionHandleColor: Colors.white,
          )
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final clampedScale = ResponsiveUtils.clampTextScale(media.textScaleFactor);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(clampedScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AuthWrapper(),
    );
  }
}