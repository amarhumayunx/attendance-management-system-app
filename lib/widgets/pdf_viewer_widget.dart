import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
class PdfViewerWidget extends StatelessWidget {
  final String filePath;
  final Function(int?) onRender;
  final Function(PDFViewController) onViewCreated;
  final Function(int?, int?) onPageChanged;
  final Function(dynamic) onError;
  const PdfViewerWidget({
    super.key,
    required this.filePath,
    required this.onRender,
    required this.onViewCreated,
    required this.onPageChanged,
    required this.onError,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PDFView(
          filePath: filePath,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: true,
          pageSnap: true,
          onRender: onRender,
          onViewCreated: onViewCreated,
          onPageChanged: onPageChanged,
          onError: onError,
        ),

      ],
    );
  }
}
