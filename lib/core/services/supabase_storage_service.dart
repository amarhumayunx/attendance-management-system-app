import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SupabaseStorageService {


  static const String _supabaseUrl = 'https://gdyqsuihuhydqilbcmxo.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdkeXFzdWlodWh5ZHFpbGJjbXhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcwNzM1MTEsImV4cCI6MjA3MjY0OTUxMX0.j-s-d_uPrm3cw6HjmnLZt-5U_PE2-Rq5AbF4rhSFLwU';

  static const String _bucketName = 'zeepalm-document';

  static bool get isConfigured {
    return _supabaseUrl.isNotEmpty && 
           _supabaseUrl != 'https://your-project-id.supabase.co' &&
           _supabaseAnonKey.isNotEmpty && 
           _supabaseAnonKey != 'your-anon-key-here';
  }

  static Future<void> initialize() async {
    if (!isConfigured) {
      throw Exception('Supabase not configured. Please update supabase_storage_service.dart with your credentials.');
    }
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<Map<String, dynamic>> uploadFile({
    required File file,
    required String fileName,
    String? contentType,
  }) async {
    try {

      if (!isConfigured) {
        return {
          'success': false,
          'error': 'Supabase not configured. Please update supabase_storage_service.dart with your credentials.',
          'details': 'Missing Supabase URL or anon key',
        };
      }

      try {
        await initialize();
      } catch (e) {

      }
      print('Uploading file to Supabase Storage: $fileName');

      final fileBytes = await file.readAsBytes();

      // Determine content type based on file extension if not provided
      String fileContentType = contentType ?? _getContentType(fileName);

      final response = await client.storage
          .from(_bucketName)
          .uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(
              contentType: fileContentType,
              upsert: true,
            ),
          );
      print('Upload response: $response');

      final publicUrl = client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);
      print('Public URL: $publicUrl');
      final result = {
        'success': true,
        'url': publicUrl,
        'fileName': fileName,
        'bucket': _bucketName,
        'path': response,
        'contentType': fileContentType,
      };

      // Only store PDF URLs for leave policy
      if (fileName.contains('leave_policy') && fileContentType == 'application/pdf') {
        await storePdfUrl(publicUrl);
      }
      print('Upload successful: $result');
      return result;
    } catch (e) {
      print('Upload error: $e');
      return {
        'success': false,
        'error': 'Upload failed: $e',
        'details': e.toString(),
      };
    }
  }

  static String _getContentType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'tiff':
        return 'image/tiff';
      case 'svg':
        return 'image/svg+xml';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'json':
        return 'application/json';
      case 'xml':
        return 'application/xml';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      case '7z':
        return 'application/x-7z-compressed';
      default:
        return 'application/octet-stream';
    }
  }

  static String getPublicUrl(String fileName) {
    if (!isConfigured) {
      throw Exception('Supabase not configured');
    }
    final url = client.storage
        .from(_bucketName)
        .getPublicUrl(fileName);
    print('Generated Supabase URL: $url');
    return url;
  }

  static Future<void> storePdfUrl(String url) async {
    try {
      final cleanUrl = url.trim();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('leave_policy_pdf_url_supabase', cleanUrl);
      print('Stored Supabase PDF URL: "$cleanUrl"');
    } catch (e) {
      print('Error storing Supabase PDF URL: $e');
    }
  }

  static Future<String?> getStoredPdfUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString('leave_policy_pdf_url_supabase');
      if (url != null) {
        final cleanUrl = url.trim();
        print('Retrieved stored Supabase PDF URL: "$cleanUrl"');
        return cleanUrl;
      }
      print('No stored Supabase PDF URL found');
      return null;
    } catch (e) {
      print('Error retrieving stored Supabase PDF URL: $e');
      return null;
    }
  }

  static Future<Uint8List?> downloadFile(String fileName) async {
    try {
      if (!isConfigured) {
        throw Exception('Supabase not configured');
      }

      try {
        await initialize();
      } catch (e) {

      }
      print('Downloading file from Supabase: $fileName');
      final response = await client.storage
          .from(_bucketName)
          .download(fileName);
      print('Download successful, size: ${response.length} bytes');
      return response;
    } catch (e) {
      print('Error downloading file from Supabase: $e');
      return null;
    }
  }

  static Future<bool> downloadPdfToAssets(String fileName) async {
    try {
      print('Downloading PDF to assets directory from Supabase...');
      final bytes = await downloadFile(fileName);
      if (bytes != null && bytes.isNotEmpty) {

        final assetsDir = Directory('assets/pdf');
        if (!await assetsDir.exists()) {
          await assetsDir.create(recursive: true);
        }
        final pdfFile = File('assets/pdf/leave_policy.pdf');
        await pdfFile.writeAsBytes(bytes);
        print('PDF saved to assets/pdf/leave_policy.pdf');
        print('File size: ${bytes.length} bytes');
        return true;
      }
      return false;
    } catch (e) {
      print('Error downloading PDF to assets from Supabase: $e');
      return false;
    }
  }

  static Future<bool> fileExists(String fileName) async {
    try {
      if (!isConfigured) {
        return false;
      }

      try {
        await initialize();
      } catch (e) {

      }
      final response = await client.storage
          .from(_bucketName)
          .list()
          .then((files) => files.any((file) => file.name == fileName));
      return response;
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getFileInfo(String fileName) async {
    try {
      if (!isConfigured) {
        return null;
      }

      try {
        await initialize();
      } catch (e) {

      }
      final files = await client.storage
          .from(_bucketName)
          .list();
      final file = files.firstWhere(
        (f) => f.name == fileName,
        orElse: () => throw Exception('File not found'),
      );
      return {
        'name': file.name,
        'size': file.metadata?['size'],
        'lastModified': file.updatedAt,
        'contentType': file.metadata?['mimetype'],
        'publicUrl': getPublicUrl(fileName),
      };
    } catch (e) {
      print('Error getting file info: $e');
      return null;
    }
  }

  static Future<bool> deleteFile(String fileName) async {
    try {
      if (!isConfigured) {
        return false;
      }

      try {
        await initialize();
      } catch (e) {

      }
      await client.storage
          .from(_bucketName)
          .remove([fileName]);
      print('File deleted successfully: $fileName');
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}
