import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrscanner/core/services/supabase_storage_service.dart';
class PdfService {

  static Future<PdfLoadResult> loadPdf() async {
    try {






















      print('Falling back to Supabase Storage download...');
      final supabaseBytes = await SupabaseStorageService.downloadFile('leave_policy.pdf');
      if (supabaseBytes != null && supabaseBytes.isNotEmpty) {
        print('Successfully loaded PDF from Supabase Storage');
        final tempDir = await _getTempDirectory();
        final tempFile = File('${tempDir.path}/leave_policy_supabase.pdf');

        await tempFile.writeAsBytes(supabaseBytes);
        return PdfLoadResult(
          success: true,
          filePath: tempFile.path,
          source: PdfSource.supabase,
        );
      } else {
        print('No PDF found in Supabase Storage');
        return PdfLoadResult(
          success: false,
          error: 'No PDF found in Supabase Storage',
          source: PdfSource.none,
        );
      }
    } catch (e) {
      print('Error loading PDF: $e');
      return PdfLoadResult(
        success: false,
        error: 'Error loading PDF: $e',
        source: PdfSource.none,
      );
    }
  }

  static Future<Uint8List> getPdfBytes() async {
    try {

      final bytes = await SupabaseStorageService.downloadFile('leave_policy.pdf');
      if (bytes != null && bytes.isNotEmpty) {
        return bytes;
      }
      throw Exception('No PDF found in Supabase Storage');
    } catch (e) {
      throw Exception('Failed to load PDF from Supabase Storage: $e');
    }
  }

  static Future<Directory> _getTempDirectory() async {
    try {
      return await getTemporaryDirectory();
    } catch (e) {
      print('Error getting temporary directory: $e');

      try {
        return await getApplicationDocumentsDirectory();
      } catch (e2) {
        print('Error getting application documents directory: $e2');

        final tempDir = Directory('/storage/emulated/0/Android/data/com.example.qrscanner/files');
        if (!await tempDir.exists()) {
          await tempDir.create(recursive: true);
        }
        return tempDir;
      }
    }
  }
}
class PdfLoadResult {
  final bool success;
  final String? filePath;
  final String? error;
  final PdfSource source;
  PdfLoadResult({
    required this.success,
    this.filePath,
    this.error,
    required this.source,
  });
}
enum PdfSource {
  assets,
  supabase,
  none,
}
