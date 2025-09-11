import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  final List<File> _selectedImages = [];
  bool _isSubmitting = false;
  String? _error;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _reasonController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.kPrimary,
              onPrimary: Colors.white,
              surface: AppColors.kSurface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = _formatDate(picked);
          // Reset end date if it's before start date
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
            _endDateController.clear();
          }
        } else {
          _endDate = picked;
          _endDateController.text = _formatDate(picked);
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 5) {
      InAppNotificationService.showWarning(
        title: 'Image Limit Reached',
        message: 'You can select up to 5 images only',
      );
      return;
    }

    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      
      if (images.isNotEmpty) {
        setState(() {
          final remainingSlots = 5 - _selectedImages.length;
          final imagesToAdd = images.take(remainingSlots).map((xFile) => File(xFile.path)).toList();
          _selectedImages.addAll(imagesToAdd);
        });
      }
    } catch (e) {
      InAppNotificationService.showError(
        title: 'Image Selection Error',
        message: 'Error picking images: $e',
      );
    }
  }

  Future<void> _takePhoto() async {
    if (_selectedImages.length >= 5) {
      InAppNotificationService.showWarning(
        title: 'Image Limit Reached',
        message: 'You can select up to 5 images only',
      );
      return;
    }

    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        setState(() {
          _selectedImages.add(File(photo.path));
        });
      }
    } catch (e) {
      InAppNotificationService.showError(
        title: 'Camera Error',
        message: 'Error taking photo: $e',
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitLeaveRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_startDate == null || _endDate == null) {
      InAppNotificationService.showWarning(
        title: 'Date Selection Required',
        message: 'Please select both start and end dates',
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      InAppNotificationService.showWarning(
        title: 'Invalid Date Range',
        message: 'End date cannot be before start date',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create leave request with temporary ID
      final leaveRequest = LeaveRequest(
        id: '', // Will be set by Firestore
        userId: user.uid,
        reason: _reasonController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
      );

      // Create the leave request first to get the ID
      final leaveRequestId = await SupabaseLeaveService.createLeaveRequest(leaveRequest);

      // Upload images if any
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        imageUrls = await ImageUploadService.uploadLeaveRequestImages(
          imageFiles: _selectedImages,
          leaveRequestId: leaveRequestId,
        );

        // Update the leave request with image URLs
        await Supabase.instance.client
            .from('leave_requests')
            .update({'imageUrls': imageUrls})
            .eq('id', leaveRequestId);
      }

      if (mounted) {
        InAppNotificationService.showSuccess(
          title: 'Leave Request Submitted',
          message: 'Your leave request has been submitted successfully!',
        );
        Get.back();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (mounted) {
        InAppNotificationService.showError(
          title: 'Submission Failed',
          message: 'Error submitting leave request: $e',
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbstractBackgroundWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Submit Leave Request',
            style: AppTypography.kMedium18,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildReasonField(),
                  const SizedBox(height: 20),
                  _buildDateFields(),
                  const SizedBox(height: 20),
                  _buildImageSection(),
                  const SizedBox(height: 20),
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.kError.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.kError.withOpacity(0.3)),
                      ),
                      child: Text(
                        _error!,
                        style: AppTypography.kMedium14error,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Leave',
          style: AppTypography.kMedium16,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _reasonController,
          maxLines: 4,
          style: AppTypography.kRegular14,
          decoration: InputDecoration(
            hintText: 'Please provide a detailed reason for your leave request...',
            hintStyle: AppTypography.kRegular14.copyWith(
              color: AppColors.kTextMuted,
            ),
            filled: true,
            fillColor: AppColors.kSurface.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.kPrimary),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please provide a reason for your leave request';
            }
            if (value.trim().length < 10) {
              return 'Please provide a more detailed reason (at least 10 characters)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            label: 'Start Date',
            controller: _startDateController,
            onTap: () => _selectDate(true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField(
            label: 'End Date',
            controller: _endDateController,
            onTap: () => _selectDate(false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.kMedium16,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.kSurface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.kTextMuted,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? 'Select $label' : controller.text,
                    style: controller.text.isEmpty
                        ? AppTypography.kRegular14.copyWith(
                            color: AppColors.kTextMuted,
                          )
                        : AppTypography.kRegular14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attach Documents (Optional)',
          style: AppTypography.kMedium16,
        ),
        const SizedBox(height: 8),
        Text(
          'You can attach up to 5 images from gallery or camera',
          style: AppTypography.kRegular12.copyWith(
            color: AppColors.kTextMuted,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildImageButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: _pickImages,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildImageButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: _takePhoto,
              ),
            ),
          ],
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSelectedImages(),
        ],
      ],
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.kPrimary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.kMedium14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Images (${_selectedImages.length}/5)',
          style: AppTypography.kMedium14,
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: _selectedImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.kBorder),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.kError,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.kPrimary, AppColors.kPrimaryDark],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitLeaveRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? LoadingAnimationWidget.stretchedDots(
                color: Colors.white,
                size: 20,
              )
            : Text(
                'Submit Leave Request',
                style: AppTypography.kMedium16.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
