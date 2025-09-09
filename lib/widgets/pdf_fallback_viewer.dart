import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qrscanner/core/services/pdf_service.dart';
import 'package:qrscanner/widgets/simple_text_viewer.dart';
class PdfFallbackViewer extends StatelessWidget {
  const PdfFallbackViewer({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: PdfService.getPdfBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        if (snapshot.hasError) {
          return const SimpleTextViewer();
        }
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: PdfPreview(
              build: (format) => _generatePDF(),
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              canChangeOrientation: false,
              canDebug: false,
              initialPageFormat: PdfPageFormat.a4,
              pdfFileName: 'leave_policy.pdf',
            ),
          );
        }
        return const SimpleTextViewer();
      },
    );
  }
  Future<Uint8List> _generatePDF() async {
    try {

      return await PdfService.getPdfBytes();
    } catch (e) {

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'ZEE PALM - LEAVE POLICY',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  '1. ANNUAL LEAVE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Full-time employees are entitled to 21 days of annual leave per year. Leave must be requested at least 7 days in advance. Maximum 5 consecutive days can be taken without manager approval.',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  '2. SICK LEAVE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '10 days of paid sick leave per year. Medical certificate required for absences longer than 3 days. Sick leave can be carried forward to next year (maximum 5 days).',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  '3. MATERNITY/PATERNITY LEAVE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Maternity leave: 12 weeks paid leave. Paternity leave: 2 weeks paid leave. Must be applied for at least 4 weeks in advance.',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  '4. EMERGENCY LEAVE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Up to 3 days of emergency leave per year. For family emergencies or unforeseen circumstances. Manager approval required.',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  '5. LEAVE APPLICATION PROCESS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Submit leave request through the HR system. Manager approval required for all leave types. Leave balance will be updated after approval.',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  '6. LEAVE BALANCE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Check your leave balance in the employee portal. Leave balances are updated monthly. Unused leave expires at the end of each year (except sick leave).',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Spacer(),
                pw.Text(
                  'For more information, contact HR at hr@zeepalm.com',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '© 2025 Zee Palm. All rights reserved.',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            );
          },
        ),
      );
      return pdf.save();
    }
  }
}
