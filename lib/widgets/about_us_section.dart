import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/controllers/about_us_controller.dart';

class AboutUsSection extends StatelessWidget {
  const AboutUsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutUsController());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Center(
            child: Text(
              'Zee Palm',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Zee Palm, LLC is a technology company focused on mobile and web app development, specializing in Flutter, AI, and cloud solutions.\n\nImportant Facts:\n\n• Headquarters: Lahore, Punjab, Pakistan, with virtual presence in New York, USA\n• Founded: 2018 (with experience in developing MVPs and scalable systems)\n• Focus: Mobile and web app development, AI integration, and cloud services',
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Our mission is to empower businesses with technology solutions that drive growth, efficiency, and innovation in the digital age.',
            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 24),

          _buildContactItem('Email:', 'contact@zeepalm.com', () => controller.launchEmail('contact@zeepalm.com')),
          _buildContactItem('Phone:', '+1 (814) 303-9055', () => controller.launchPhone('+18143039055')),
          _buildContactItem('Address:', '23-D 2nd Floor, Commercial Area EME DHA Phase 12, Lahore, Punjab, Pakistan', () => controller.launchMaps()),
        ],
      ),
    );
  }
  Widget _buildContactItem(String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4ECDC4),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
