import 'package:flutter/material.dart';
import 'dart:io';
import 'package:qrscanner/widgets/admin_upload_header_widget.dart';
import 'package:qrscanner/widgets/config_warning_widget.dart';
import 'package:qrscanner/widgets/file_selection_widget.dart';
import 'package:qrscanner/widgets/upload_section_widget.dart';
import 'package:qrscanner/widgets/upload_instructions_widget.dart';
import 'package:qrscanner/core/services/admin_upload_service.dart';
import 'package:qrscanner/core/services/supabase_storage_service.dart';
class AdminLeavePolicyUploadScreen extends StatefulWidget {
  const AdminLeavePolicyUploadScreen({super.key});
  @override
  State<AdminLeavePolicyUploadScreen> createState() => _AdminLeavePolicyUploadScreenState();
}
class _AdminLeavePolicyUploadScreenState extends State<AdminLeavePolicyUploadScreen> {
  File? _selectedFile;
  bool _uploading = false;
  String? _uploadStatus;
  String? _errorMessage;
  String? _troubleshooting;
  String? _currentPdfUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('Upload Leave Policy'),
        backgroundColor: const Color(0xFF0F3460),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const AdminUploadHeaderWidget(),
              const SizedBox(height: 24),

              const ConfigWarningWidget(),
              if (!_isSupabaseConfigured()) const SizedBox(height: 24),

              FileSelectionWidget(
                selectedFile: _selectedFile,
                uploading: _uploading,
                onPickFile: _pickFile,
                onClearFile: _clearFile,
              ),
              const SizedBox(height: 24),

              if (_selectedFile != null) ...[
                UploadSectionWidget(
                  uploading: _uploading,
                  uploadStatus: _uploadStatus,
                  errorMessage: _errorMessage,
                  troubleshooting: _troubleshooting,
                  currentPdfUrl: _currentPdfUrl,
                  onUpload: _uploadFile,
                  onDownloadToAssets: _downloadToAssets,
                ),
                const SizedBox(height: 24),
              ],

              const UploadInstructionsWidget(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  bool _isSupabaseConfigured() {
    return SupabaseStorageService.isConfigured;
  }
  void _clearFile() {
    setState(() {
      _selectedFile = null;
      _uploadStatus = null;
      _errorMessage = null;
      _troubleshooting = null;
    });
  }
  Future<void> _pickFile() async {
    try {
      final file = await AdminUploadService.pickPdfFile();
      if (file != null) {
        setState(() {
          _selectedFile = file;
          _uploadStatus = null;
          _errorMessage = null;
          _troubleshooting = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;
    setState(() {
      _uploading = true;
      _uploadStatus = null;
      _errorMessage = null;
      _troubleshooting = null;
    });
    try {
      final result = await AdminUploadService.uploadFile(_selectedFile!);
      if (result['success'] == true) {
        setState(() {
          _uploadStatus = result['message'];
          _currentPdfUrl = result['url'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _errorMessage = result['error'];
          _troubleshooting = result['troubleshooting'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Upload error: $e';
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }
  Future<void> _downloadToAssets() async {
    if (_currentPdfUrl == null) return;
    setState(() {
      _uploading = true;
      _uploadStatus = 'Downloading PDF to assets...';
      _errorMessage = null;
      _troubleshooting = null;
    });
    try {
      final result = await AdminUploadService.downloadPdfToAssets();
      if (result['success'] == true) {
        setState(() {
          _uploadStatus = result['message'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _errorMessage = result['error'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Download error: $e';
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }
}
