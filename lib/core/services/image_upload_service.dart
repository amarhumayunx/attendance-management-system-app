import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:qrscanner/core/services/supabase_storage_service.dart';

class ImageUploadService {
  static const String _bucketName = 'zeepalm-document';

  static Future<List<String>> uploadLeaveRequestImages({
    required List<File> imageFiles,
    required String leaveRequestId,
  }) async {
    try {
      final List<String> uploadedUrls = [];

      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final fileName = 'leave_requests/$leaveRequestId/image_${i + 1}_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
        
        final result = await SupabaseStorageService.uploadFile(
          file: file,
          fileName: fileName,
        );

        if (result['success'] == true) {
          uploadedUrls.add(result['url']);
        } else {
          throw Exception('Failed to upload image ${i + 1}: ${result['error']}');
        }
      }

      return uploadedUrls;
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }

  static Future<String> uploadSingleImage({
    required File imageFile,
    required String folder,
    required String fileName,
  }) async {
    try {
      final fullFileName = '$folder/$fileName';
      
      final result = await SupabaseStorageService.uploadFile(
        file: imageFile,
        fileName: fullFileName,
      );

      if (result['success'] == true) {
        return result['url'];
      } else {
        throw Exception('Failed to upload image: ${result['error']}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract filename from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final fileName = pathSegments.last;
        await SupabaseStorageService.deleteFile(fileName);
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  static Future<void> deleteLeaveRequestImages(List<String> imageUrls) async {
    try {
      for (final url in imageUrls) {
        await deleteImage(url);
      }
    } catch (e) {
      print('Error deleting leave request images: $e');
    }
  }

  static String getImageUrl(String fileName) {
    return SupabaseStorageService.getPublicUrl(fileName);
  }
}
