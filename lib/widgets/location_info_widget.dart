import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      height: 130,
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
          const Text(
            'Current Location',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
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
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Getting location...',
          style: TextStyle(color: Colors.white70, fontSize: 12),
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
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 11,
              ),
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
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Accuracy: ±${currentPosition!.accuracy.toStringAsFixed(1)}m',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
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
          style: TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
      ],
    );
  }
}
