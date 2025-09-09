import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsController extends GetxController {

  Future<void> launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: email));
        showSnackBar('Email copied to clipboard: $email');
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: email));
      showSnackBar('Email copied to clipboard: $email');
    }
  }

  Future<void> launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: phoneNumber));
        showSnackBar('Phone number copied to clipboard');
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: phoneNumber));
      showSnackBar('Phone number copied to clipboard');
    }
  }

  Future<void> launchMaps() async {
    const double latitude = 31.4349917;
    const double longitude = 74.2154017;
    const String address = 'EME DHA Phase 12, Lahore, Punjab, Pakistan';
    const String shortLink = 'https://maps.app.goo.gl/bbteVgEnvwMGzhzQ7';
    final List<String> mapUris = [
      'geo:$latitude,$longitude?q=$latitude,$longitude(${Uri.encodeComponent(address)})',
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      'https://maps.google.com/?q=$latitude,$longitude',
      shortLink,
    ];
    bool launched = false;
    for (var uriStr in mapUris) {
      final uri = Uri.parse(uriStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        launched = true;
        break;
      }
    }
    if (!launched) {
      await Clipboard.setData(const ClipboardData(text: shortLink));
      showMapOptionsDialog(address, latitude, longitude, shortLink);
    }
  }

  void showMapOptionsDialog(String address, double lat, double lng, String shortLink) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('View Location', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Could not open maps to view location. Link copied to clipboard:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            SelectableText(
              shortLink,
              style: const TextStyle(
                color: Color(0xFF4ECDC4),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              address,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: shortLink));
              showSnackBar('Location link copied to clipboard');
              Get.back();
            },
            child: const Text('Copy Link', style: TextStyle(color: Color(0xFF4ECDC4))),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK', style: TextStyle(color: Color(0xFF4ECDC4))),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String message) {
    Get.snackbar(
      "Info",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4ECDC4),
      colorText: Colors.black,
      duration: const Duration(seconds: 3),
    );
  }
}
