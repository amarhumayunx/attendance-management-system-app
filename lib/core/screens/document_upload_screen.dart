import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/core/models/document_model.dart';
import 'package:qrscanner/core/services/profile_service.dart';
class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});
  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}
class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  DocumentType _type = DocumentType.cnic;
  final _url = TextEditingController();
  final _notes = TextEditingController();
  bool _saving = false;
  String? _error;
  Future<void> _save() async {
    if (_url.text.trim().isEmpty) {
      setState(() { _error = 'URL is required'; });
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final doc = UserDocument(
        id: id, 
        type: _type, 
        url: _url.text.trim(), 
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim()
      );
      await ProfileService.addDocument(user, doc);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document uploaded successfully'))
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _saving = false; });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('Upload Document'),
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.upload_file,
                            color: Color(0xFF4ECDC4),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Document Upload',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Upload your important documents securely. All documents are encrypted and stored safely.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Document Details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: DropdownButtonFormField<DocumentType>(
                initialValue: _type,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                dropdownColor: const Color(0xFF0F3460),
                decoration: InputDecoration(
                  labelText: 'Document Type',
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: DocumentType.cnic, 
                    child: Text('CNIC', style: TextStyle(color: Colors.white))
                  ),
                  DropdownMenuItem(
                    value: DocumentType.transcript, 
                    child: Text('Transcript', style: TextStyle(color: Colors.white))
                  ),
                  DropdownMenuItem(
                    value: DocumentType.degree, 
                    child: Text('Degree', style: TextStyle(color: Colors.white))
                  ),
                  DropdownMenuItem(
                    value: DocumentType.matricCertificate, 
                    child: Text('Matric Certificate', style: TextStyle(color: Colors.white))
                  ),
                  DropdownMenuItem(
                    value: DocumentType.intermediateCertificate, 
                    child: Text('Intermediate Certificate', style: TextStyle(color: Colors.white))
                  ),
                  DropdownMenuItem(
                    value: DocumentType.other, 
                    child: Text('Other', style: TextStyle(color: Colors.white))
                  ),
                ],
                onChanged: (v) { 
                  if (v != null) setState(() => _type = v); 
                },
              ),
            ),
            const SizedBox(height: 20),

            _darkTextField(
              controller: _url, 
              label: 'Document URL',
              icon: Icons.link,
            ),
            const SizedBox(height: 20),

            _darkTextField(
              controller: _notes, 
              label: 'Notes (optional)',
              icon: Icons.note_add,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!, 
                        style: const TextStyle(color: Colors.redAccent)
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  elevation: 2,
                ),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white
                        )
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Upload Document',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4ECDC4).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF4ECDC4),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Make sure your document URL is publicly accessible and contains clear, readable content.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _darkTextField({
  required TextEditingController controller, 
  required String label,
  IconData? icon,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
      ),
      prefixIcon: icon != null 
          ? Icon(icon, color: Colors.white.withOpacity(0.6), size: 20)
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF4ECDC4), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
    ),
  );
}
