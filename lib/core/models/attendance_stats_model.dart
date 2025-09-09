class AttendanceStats {
  final int onTime;
  final int late;
  final int total;
  final String percentage;
  AttendanceStats({
    required this.onTime,
    required this.late,
    required this.total,
    required this.percentage,
  });
  factory AttendanceStats.fromHistory(Map<String, dynamic> history) {
    int onTimeCount = 0;
    int lateCount = 0;
    int totalValidEntries = 0;
    for (var entry in history.values) {
      final checkIn = entry['checkInTime'] as String?;
      if (checkIn != null && checkIn != 'Not checked in') {
        try {
          final dt = DateTime.parse(checkIn);
          final standardTime = DateTime(dt.year, dt.month, dt.day, 10, 0);
          final graceTime = standardTime.add(const Duration(minutes: 15));
          if (dt.isBefore(graceTime) || dt.isAtSameMomentAs(graceTime)) {
            onTimeCount++;
          } else {
            lateCount++;
          }
          totalValidEntries++;
        } catch (_) {

        }
      }
    }
    final percentage = totalValidEntries == 0 
        ? '0%' 
        : '${(onTimeCount / totalValidEntries * 100).round()}%';
    return AttendanceStats(
      onTime: onTimeCount,
      late: lateCount,
      total: totalValidEntries,
      percentage: percentage,
    );
  }
}
