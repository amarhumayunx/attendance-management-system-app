import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../core/constants/app_typography.dart';
class LocationInfoWidget extends StatelessWidget {
  final Position? currentPosition;
  final bool locationLoading;
  final VoidCallback onRefresh;
  const LocationInfoWidget({
    super.key,
    required this.currentPosition,
    required this.locationLoading,
    required this.onRefresh,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Current Location',
            style: AppTypography.kMedium14,
          ),
          const SizedBox(height: 12),
          if (locationLoading)
            _buildLoadingState()
          else if (currentPosition != null)
            _buildLocationData()
          else
            _buildErrorState(),
        ],
      ),
    );
  }
  Widget _buildLoadingState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: LoadingAnimationWidget.stretchedDots(
              color: Colors.black, size: 30),
        ),
        const SizedBox(width: 8),
        Text(
          'Loading location...',
          style: AppTypography.kMedium12,
        ),
      ],
    );
  }
  Widget _buildLocationData() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 14, color: Colors.greenAccent),
            const SizedBox(width: 4),
            Text(
              'Lat: ${currentPosition!.latitude.toStringAsFixed(6)}',
              style: AppTypography.kMedium12,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 14, color: Colors.blueAccent),
            const SizedBox(width: 4),
            Text(
              'Lng: ${currentPosition!.longitude.toStringAsFixed(6)}',
              style: AppTypography.kMedium12,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Accuracy: ±${currentPosition!.accuracy.toStringAsFixed(1)}m',
          style: AppTypography.kMedium12,
        ),
      ],
    );
  }
  Widget _buildErrorState() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_off, color: Colors.redAccent, size: 16),
        const SizedBox(width: 4),
        Text(
          'Location unavailable',
          style: AppTypography.kMedium12,
        ),
      ],
    );
  }
}
