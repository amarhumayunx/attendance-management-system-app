import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';

import '../../widgets/abstract_background_wrapper.dart';
class LeavePolicyViewerScreen extends StatefulWidget {
  const LeavePolicyViewerScreen({super.key});
  @override
  State<LeavePolicyViewerScreen> createState() => _LeavePolicyViewerScreenState();
}
class _LeavePolicyViewerScreenState extends State<LeavePolicyViewerScreen> {
  String? localPath;
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  PDFViewController? pdfController;
  bool useFallbackViewer = false;
  @override
  void initState() {
    super.initState();
    _loadPDF();
  }
  Future<void> _loadPDF() async {
    try {
      final result = await PdfService.loadPdf();
      if (result.success && result.filePath != null) {
        setState(() {
          localPath = result.filePath;
          isReady = true;
        });
      } else {

        print('No PDF found, using fallback viewer');
        setState(() {
          useFallbackViewer = true;
          isReady = true;
        });
      }
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        errorMessage = e.toString();
        isReady = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return AbstractBackgroundWrapper(
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Leave Policy'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (pages > 0)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${currentPage + 1} / $pages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        child: isReady
            ? (useFallbackViewer 
                ? const PdfFallbackViewer() 
                : PdfViewerWidget(
                    filePath: localPath!,
                    onRender: (pages) {
                      setState(() {
                        this.pages = pages ?? 0;
                      });
                    },
                    onViewCreated: (controller) {
                      pdfController = controller;
                    },
                    onPageChanged: (page, total) {
                      setState(() {
                        currentPage = page ?? 0;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                    },
                  ))
            : errorMessage.isNotEmpty
                ? PdfErrorView(
                    errorMessage: errorMessage,
                    onRetry: () {
                      setState(() {
                        errorMessage = '';
                      });
                      _loadPDF();
                    },
                  )
                : Center(
                    child: LoadingAnimationWidget.stretchedDots(
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
      ),),
    );
  }
}
