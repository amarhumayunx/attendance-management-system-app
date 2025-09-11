import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscanner/lib_exports.dart';

class AdminLeaveRequestsScreen extends StatefulWidget {
  const AdminLeaveRequestsScreen({super.key});

  @override
  State<AdminLeaveRequestsScreen> createState() => _AdminLeaveRequestsScreenState();
}

class _AdminLeaveRequestsScreenState extends State<AdminLeaveRequestsScreen> {
  LeaveStatus _selectedFilter = LeaveStatus.pending;

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
            'Leave Requests',
            style: AppTypography.kMedium18,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              _buildFilterSection(),
              Expanded(
                child: _buildLeaveRequestsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Status',
            style: AppTypography.kMedium16,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: LeaveStatus.values.map((status) {
                final isSelected = _selectedFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = status;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.kPrimary
                            : AppColors.kSurface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.kPrimary
                              : AppColors.kBorder,
                        ),
                      ),
                      child: Text(
                        _getStatusDisplayName(status),
                        style: AppTypography.kMedium14.copyWith(
                          color: isSelected ? Colors.white : AppColors.kTextSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestsList() {
    return StreamBuilder<List<LeaveRequest>>(
      stream: _getLeaveRequestsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.stretchedDots(
              color: Colors.white,
              size: 30,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.kError,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading leave requests',
                  style: AppTypography.kMedium16,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: AppTypography.kRegular14.copyWith(
                    color: AppColors.kTextMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: AppTypography.kMedium14.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final leaveRequests = snapshot.data ?? [];

        if (leaveRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  color: AppColors.kTextMuted,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No leave requests found',
                  style: AppTypography.kMedium16,
                ),
                const SizedBox(height: 8),
                Text(
                  'There are no leave requests with ${_getStatusDisplayName(_selectedFilter).toLowerCase()} status.',
                  style: AppTypography.kRegular14.copyWith(
                    color: AppColors.kTextMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          itemCount: leaveRequests.length,
          itemBuilder: (context, index) {
            final leaveRequest = leaveRequests[index];
            return _buildLeaveRequestCard(leaveRequest);
          },
        );
      },
    );
  }

  Widget _buildLeaveRequestCard(LeaveRequest leaveRequest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder),
      ),
      child: InkWell(
        onTap: () => _showLeaveRequestDetails(leaveRequest),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leave Request',
                          style: AppTypography.kMedium16,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatDate(leaveRequest.startDate)} - ${_formatDate(leaveRequest.endDate)}',
                          style: AppTypography.kRegular14.copyWith(
                            color: AppColors.kTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(leaveRequest.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                leaveRequest.reason,
                style: AppTypography.kRegular14,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.kTextMuted,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Submitted ${_getTimeAgo(leaveRequest.createdAt)}',
                    style: AppTypography.kRegular12.copyWith(
                      color: AppColors.kTextMuted,
                    ),
                  ),
                  const Spacer(),
                  if (leaveRequest.imageUrls != null && leaveRequest.imageUrls!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: AppColors.kPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${leaveRequest.imageUrls!.length} attachment(s)',
                          style: AppTypography.kRegular12.copyWith(
                            color: AppColors.kPrimary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(LeaveStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case LeaveStatus.pending:
        backgroundColor = AppColors.kWarning.withOpacity(0.2);
        textColor = AppColors.kWarning;
        break;
      case LeaveStatus.approved:
        backgroundColor = AppColors.kSuccess.withOpacity(0.2);
        textColor = AppColors.kSuccess;
        break;
      case LeaveStatus.rejected:
        backgroundColor = AppColors.kError.withOpacity(0.2);
        textColor = AppColors.kError;
        break;
      case LeaveStatus.viewed:
        backgroundColor = AppColors.kInfo.withOpacity(0.2);
        textColor = AppColors.kInfo;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusDisplayName(status),
        style: AppTypography.kMedium12.copyWith(
          color: textColor,
        ),
      ),
    );
  }

  void _showLeaveRequestDetails(LeaveRequest leaveRequest) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LeaveRequestDetailsModal(
        leaveRequest: leaveRequest,
        onStatusUpdated: () {
          setState(() {});
        },
      ),
    );
  }

  Stream<List<LeaveRequest>> _getLeaveRequestsStream() {
    if (_selectedFilter == LeaveStatus.pending) {
      return SupabaseLeaveService.getAllLeaveRequestsStream();
    } else {
      return SupabaseLeaveService.getAllLeaveRequestsStream().map((requests) {
        return requests.where((request) => request.status == _selectedFilter).toList();
      });
    }
  }

  String _getStatusDisplayName(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.viewed:
        return 'Viewed';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class LeaveRequestDetailsModal extends StatefulWidget {
  final LeaveRequest leaveRequest;
  final VoidCallback onStatusUpdated;

  const LeaveRequestDetailsModal({
    super.key,
    required this.leaveRequest,
    required this.onStatusUpdated,
  });

  @override
  State<LeaveRequestDetailsModal> createState() => _LeaveRequestDetailsModalState();
}

class _LeaveRequestDetailsModalState extends State<LeaveRequestDetailsModal> {
  final _adminNotesController = TextEditingController();
  LeaveStatus _selectedStatus = LeaveStatus.pending;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.leaveRequest.status;
    _adminNotesController.text = widget.leaveRequest.adminNotes ?? '';
  }

  @override
  void dispose() {
    _adminNotesController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      await SupabaseLeaveService.updateLeaveRequestStatus(
        widget.leaveRequest.id,
        _selectedStatus,
        adminNotes: _adminNotesController.text.trim().isEmpty
            ? null
            : _adminNotesController.text.trim(),
        adminId: user?.uid,
      );

      if (mounted) {
        InAppNotificationService.showSuccess(
          title: 'Status Updated',
          message: 'Leave request status updated successfully!',
        );
        widget.onStatusUpdated();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        InAppNotificationService.showError(
          title: 'Update Failed',
          message: 'Error updating status: $e',
        );
      }
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Leave Request Details',
                        style: AppTypography.kSemiBold18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.kTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailSection(),
                        const SizedBox(height: 20),
                        _buildStatusUpdateSection(),
                        const SizedBox(height: 20),
                        _buildImagesSection(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildUpdateButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kCardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request Details',
            style: AppTypography.kMedium16,
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Start Date', _formatDate(widget.leaveRequest.startDate)),
          _buildDetailRow('End Date', _formatDate(widget.leaveRequest.endDate)),
          _buildDetailRow('Duration', '${_calculateDuration()} day${_calculateDuration() == 1 ? '' : 's'}'),
          _buildDetailRow('Status', _getStatusDisplayName(widget.leaveRequest.status)),
          if (widget.leaveRequest.statusUpdatedAt != null)
            _buildDetailRow('Last Updated', _formatDate(widget.leaveRequest.statusUpdatedAt!.toDate())),
          const SizedBox(height: 12),
          Text(
            'Reason',
            style: AppTypography.kMedium14,
          ),
          const SizedBox(height: 4),
          Text(
            widget.leaveRequest.reason,
            style: AppTypography.kRegular14,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.kRegular14.copyWith(
                color: AppColors.kTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.kRegular14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusUpdateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kCardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Status',
            style: AppTypography.kMedium16,
          ),
          const SizedBox(height: 12),
            DropdownButtonFormField<LeaveStatus>(
              value: _selectedStatus,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.kSurface.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.kBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.kPrimary),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            dropdownColor: AppColors.kSurface,
            style: AppTypography.kRegular14,
            items: LeaveStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  _getStatusDisplayName(status),
                  style: AppTypography.kRegular14,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Admin Notes (Optional)',
            style: AppTypography.kMedium14,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _adminNotesController,
            maxLines: 3,
            style: AppTypography.kRegular14,
            decoration: InputDecoration(
              hintText: 'Add any notes for the employee...',
              hintStyle: AppTypography.kRegular14.copyWith(
                color: AppColors.kTextMuted,
              ),
              filled: true,
              fillColor: AppColors.kSurface.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.kBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.kPrimary),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection() {
    if (widget.leaveRequest.imageUrls == null || widget.leaveRequest.imageUrls!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kCardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attached Documents (${widget.leaveRequest.imageUrls!.length})',
            style: AppTypography.kMedium16,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: widget.leaveRequest.imageUrls!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showImagePreview(widget.leaveRequest.imageUrls![index]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.kBorder),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.leaveRequest.imageUrls![index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.kSurface,
                          child: const Icon(
                            Icons.broken_image,
                            color: AppColors.kTextMuted,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
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
        onPressed: _isUpdating ? null : _updateStatus,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isUpdating
            ? LoadingAnimationWidget.stretchedDots(
                color: Colors.white,
                size: 20,
              )
            : Text(
                'Update Status',
                style: AppTypography.kMedium16.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.kSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image,
                              color: AppColors.kTextMuted,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: AppColors.kTextMuted),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusDisplayName(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.viewed:
        return 'Viewed';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateDuration() {
    return widget.leaveRequest.endDate.difference(widget.leaveRequest.startDate).inDays + 1;
  }
}
