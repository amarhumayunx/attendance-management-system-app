import 'package:flutter/material.dart';
import 'package:qrscanner/core/services/supabase_storage_service.dart';
class ConfigWarningWidget extends StatelessWidget {
  const ConfigWarningWidget({super.key});
  @override
  Widget build(BuildContext context) {
    if (SupabaseStorageService.isConfigured) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Supabase Not Configured',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'To upload PDFs to Supabase Storage, you need to configure your credentials:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Create a Supabase project at https://supabase.com\n'
            '2. Create a storage bucket named "zeepalm-document"\n'
            '3. Open lib/services/supabase_storage_service.dart\n'
            '4. Replace "_supabaseUrl" with your project URL\n'
            '5. Replace "_supabaseAnonKey" with your anon key\n'
            '6. See SUPABASE_SETUP.md for detailed setup instructions',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
