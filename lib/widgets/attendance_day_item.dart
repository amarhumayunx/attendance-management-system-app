import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qrscanner/core/utils/attendance_utils.dart';
import 'package:qrscanner/widgets/location_map_widget.dart';
import 'package:url_launcher/url_launcher.dart';
class AttendanceDayItem extends StatelessWidget {
  final DateTime day;
  final Map<String, dynamic>? data;
  const AttendanceDayItem({
    super.key,
    required this.day,
    this.data,
  });
  @override
  Widget build(BuildContext context) {

    if (AttendanceUtils.isWeekend(day)) {
      final wk = AttendanceUtils.weekdayShort(day);
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.weekend, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Weekend ($wk)  •  ${DateFormat('MMM dd').format(day)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.day.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AttendanceUtils.weekdayShort(day),
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Check-in', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(AttendanceUtils.formatTime(data?['checkInTime']), style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Check-out', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(AttendanceUtils.formatTime(data?['checkOutTime']), style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Duration', style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(AttendanceUtils.formatDuration(data ?? {}), style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),

                if (data != null && (data!['lat'] != null || data!['lng'] != null)) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                            const SizedBox(width: 6),
                            const Text('Location', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [

                            if (_hasValidCoordinates(data!['lat'], data!['lng']))
                              LocationMapWidget(
                                latitude: _parseCoordinate(data!['lat']),
                                longitude: _parseCoordinate(data!['lng']),
                                height: 80,
                                width: 120,
                              ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => _openLocationInMaps(context, data!['lat'], data!['lng']),
                                    child: Text(
                                      _formatLocation(data!['lat'], data!['lng']),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to view location',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  bool _hasValidCoordinates(dynamic lat, dynamic lng) {
    if (lat == null || lng == null) return false;
    try {
      final latitude = lat is double ? lat : double.parse(lat.toString());
      final longitude = lng is double ? lng : double.parse(lng.toString());

      return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
    } catch (e) {
      return false;
    }
  }
  double _parseCoordinate(dynamic coordinate) {
    if (coordinate is double) return coordinate;
    return double.parse(coordinate.toString());
  }
  String _formatLocation(dynamic lat, dynamic lng) {
    if (lat == null || lng == null) return 'Location not available';
    try {
      final latitude = lat is double ? lat : double.parse(lat.toString());
      final longitude = lng is double ? lng : double.parse(lng.toString());

      final formattedLat = latitude.toStringAsFixed(4);
      final formattedLng = longitude.toStringAsFixed(4);
      return '$formattedLat, $formattedLng';
    } catch (e) {
      return 'Invalid coordinates';
    }
  }
  Future<void> _openLocationInMaps(BuildContext context, dynamic lat, dynamic lng) async {
    if (lat == null || lng == null) return;
    try {
      final latitude = lat is double ? lat : double.parse(lat.toString());
      final longitude = lng is double ? lng : double.parse(lng.toString());

      final List<Map<String, dynamic>> mapOptions = [
        {
          'uri': 'geo:$latitude,$longitude?q=$latitude,$longitude',
          'description': 'Geo scheme with coordinates (view only)',
        },
        {
          'uri': 'intent://maps.google.com/maps?q=$latitude,$longitude#Intent;scheme=https;package=com.google.android.apps.maps;end',
          'description': 'Google Maps App Intent (view only)',
        },
        {
          'uri': 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
          'description': 'Google Maps Website (view only)',
        },
        {
          'uri': 'https://maps.google.com/?q=$latitude,$longitude',
          'description': 'Google Maps Direct Link (view only)',
        },
        {
          'uri': 'https://maps.apple.com/?q=$latitude,$longitude',
          'description': 'Apple Maps (iOS) (view only)',
        },
      ];
      bool launched = false;
      for (final option in mapOptions) {
        try {
          final Uri uri = Uri.parse(option['uri']);
          final String description = option['description'];
          print('Trying: $description');

          if (option['uri'].startsWith('geo:')) {
            try {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              print('Successfully launched: $description');
              launched = true;
              break;
            } catch (e) {
              print('Failed $description: $e');
              continue;
            }
          }

          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri, 
              mode: LaunchMode.externalApplication,
            );
            print('Successfully launched: $description');
            launched = true;
            break;
          } else {
            print('Cannot launch: $description');
          }
        } catch (e) {
          print('Error with ${option['description']}: $e');
          continue;
        }
      }

      if (!launched) {
        try {
          final Uri fallbackUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
          await launchUrl(
            fallbackUri,
            mode: LaunchMode.platformDefault,
          );
          launched = true;
          print('Platform default launch successful');
        } catch (e) {
          print('Platform default failed: $e');

          try {
            await launchUrl(
              Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude'),
              mode: LaunchMode.inAppWebView,
            );
            launched = true;
            print('In-app web view successful');
          } catch (e) {
            print('In-app web view also failed: $e');
          }
        }
      }
      if (!launched) {

        final coordinates = '$latitude, $longitude';
        await Clipboard.setData(ClipboardData(text: coordinates));
        _showSnackBar(context, 'Could not open maps to view location. Coordinates copied to clipboard: $coordinates');
        print('Could not open maps app. Coordinates: $latitude, $longitude');
      }
    } catch (e) {
      print('Error opening location in maps: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
    );
  }
}
