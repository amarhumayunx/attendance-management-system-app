import 'package:flutter/material.dart';
class AttendanceAveragesWidget extends StatelessWidget {
  final Map<String, dynamic> averages;
  const AttendanceAveragesWidget({
    super.key,
    required this.averages,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 88,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildAverageCardBox(
                  'Avg Check In',
                  averages['checkIn'] ?? '--:--',
                  Colors.green,
                ),
                _buildAverageCardBox(
                  'Avg Check Out',
                  averages['checkOut'] ?? '--:--',
                  Colors.orange,
                ),
                _buildAverageCardBox(
                  'Avg Duration',
                  averages['duration'] ?? '--:--',
                  Colors.blue,
                ),
              ],
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildAverageCard(
                'Avg Check In',
                averages['checkIn'] ?? '--:--',
                Colors.green,
              ),
              const SizedBox(width: 8),
              _buildAverageCard(
                'Avg Check Out',
                averages['checkOut'] ?? '--:--',
                Colors.orange,
              ),
              const SizedBox(width: 8),
              _buildAverageCard(
                'Avg Duration',
                averages['duration'] ?? '--:--',
                Colors.blue,
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildAverageCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageCardBox(String title, String value, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
