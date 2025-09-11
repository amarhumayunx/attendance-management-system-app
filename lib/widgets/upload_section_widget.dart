import 'package:flutter/material.dart';
import 'package:qrscanner/core/constants/app_typography.dart';
class UploadSectionWidget extends StatelessWidget {
  final bool uploading;
  final String? uploadStatus;
  final String? errorMessage;
  final String? troubleshooting;
  final String? currentPdfUrl;
  final VoidCallback onUpload;
  final VoidCallback onDownloadToAssets;
  const UploadSectionWidget({
    super.key,
    required this.uploading,
    this.uploadStatus,
    this.errorMessage,
    this.troubleshooting,
    this.currentPdfUrl,
    required this.onUpload,
    required this.onDownloadToAssets,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload to Supabase Storage',
            style: AppTypography.kMedium18,
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8A65).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              onPressed: uploading ? null : onUpload,
              icon: uploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload, color: Colors.white),
              label: Text(
                uploading ? 'Uploading...' : 'Upload to Supabase',
                style: AppTypography.kMedium16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (uploadStatus != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      uploadStatus!,
                      style: AppTypography.kMedium14,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Upload Error',
                          style: AppTypography.kMedium16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    style: AppTypography.kMedium14,
                  ),

                  if (troubleshooting != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.orange, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Troubleshooting:',
                                style: AppTypography.kMedium12,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            troubleshooting!,
                            style: AppTypography.kRegular12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          if (currentPdfUrl != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.link, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'PDF URL:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPdfUrl!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      onPressed: uploading ? null : onDownloadToAssets,
                      icon: const Icon(Icons.download, color: Colors.white, size: 18),
                      label: const Text(
                        'Download to Assets (for Development)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
