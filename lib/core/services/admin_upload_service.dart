import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:qrscanner/core/services/supabase_storage_service.dart';
class AdminUploadService {

  static Future<File?> pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw Exception('Error selecting file: $e');
    }
  }

  static Future<Map<String, dynamic>> uploadFile(File file) async {
    try {
      final result = await SupabaseStorageService.uploadFile(
        file: file,
        fileName: 'leave_policy.pdf',
      );
      if (result['success'] == true) {
        return {
          'success': true,
          'message': 'PDF uploaded successfully to Supabase Storage!',
          'url': result['url'],
        };
      } else {
        return {
          'success': false,
          'error': result['error'] ?? 'Upload failed',
          'troubleshooting': result['details'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Upload error: $e',
        'troubleshooting': null,
      };
    }
  }

  static Future<Map<String, dynamic>> downloadPdfToAssets() async {
    try {
      final success = await SupabaseStorageService.downloadPdfToAssets('leave_policy.pdf');
      if (success) {
        return {
          'success': true,
          'message': 'PDF downloaded to assets successfully!',
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to download PDF to assets',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Download error: $e',
      };
    }
  }

  static String getFileSizeInMB(File file) {
    final sizeInBytes = file.lengthSync();
    final sizeInMB = sizeInBytes / 1024 / 1024;
    return sizeInMB.toStringAsFixed(2);
  }

  static String getFileName(File file) {
    return file.path.split('/').last;
  }
}
