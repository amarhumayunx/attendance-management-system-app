import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class AttendanceService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
  }

  static DateTime? parseDateKey(String dateKey) {
    try {
      final parts = dateKey.split('-');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> saveCheckIn({
    required String uid,
    required double lat,
    required double lng,
  }) async {
    try {
      final now = DateTime.now();
      final todayKey = formatDateKey(now);

      final checkInData = {
        'checkInTime': formatDateTime(now),
        'checkInTimestamp': Timestamp.fromDate(now),
        'lat': lat,
        'lng': lng,
        'user_id': uid,
      };

      final docRef = _db.collection('attendance').doc(uid).collection('days').doc(todayKey);
      await docRef.set(checkInData);
      return {
        'success': true,
        'checkInTime': now,
        'checkInId': uid,
      };
    } catch (e) {
      throw Exception('Error saving check-in: $e');
    }
  }

  static Future<Map<String, dynamic>> saveCheckOut({
    required String uid,
    required double lat,
    required double lng,
  }) async {
    try {
      final now = DateTime.now();
      final todayKey = formatDateKey(now);

      final docRef = _db.collection('attendance').doc(uid).collection('days').doc(todayKey);
      final doc = await docRef.get();
      Map<String, dynamic> data = {};
      String? duration;
      int? durationSeconds;
      int? durationMinutes;
      if (doc.exists) {
        final existing = doc.data();
        if (existing != null) {
          data = Map.from(existing);

        data['checkOutTime'] = formatDateTime(now);
        data['checkOutTimestamp'] = Timestamp.fromDate(now);
        data['user_id'] = uid;

        if (existing['checkInTime'] != null && existing['checkInTime'] != 'Not checked in') {
          try {
            final checkInTime = DateFormat('dd-MM-yyyy HH:mm:ss').parse(existing['checkInTime']);
            final diff = now.difference(checkInTime);
            if (!diff.isNegative) {
              final hours = diff.inHours;
              final minutes = diff.inMinutes % 60;
              final seconds = diff.inSeconds % 60;
              durationSeconds = diff.inSeconds;
              durationMinutes = diff.inMinutes;
              if (hours > 0) {
                duration = '${hours}h ${minutes}m ${seconds}s';
              } else if (minutes > 0) {
                duration = '${minutes}m ${seconds}s';
              } else {
                duration = '${seconds}s';
              }
            }
          } catch (e) {
            print('Failed to parse check-in time for duration: $e');
          }
        }
          data['duration'] = duration;
          data['durationSeconds'] = durationSeconds;
          data['durationMinutes'] = durationMinutes;
        }
      } else {

        data = {
          'checkInTime': 'Not checked in',
          'checkInTimestamp': null,
          'checkOutTime': formatDateTime(now),
          'checkOutTimestamp': Timestamp.fromDate(now),
          'lat': lat,
          'lng': lng,
          'user_id': uid,
          'duration': null,
          'durationSeconds': null,
          'durationMinutes': null,
        };
      }
      await docRef.set(data);
      return {
        'success': true,
        'checkOutTime': now,
        'checkOutId': uid,
        'duration': duration,
      };
    } catch (e) {
      throw Exception('Error saving check-out: $e');
    }
  }

  static Future<Map<String, dynamic>> getTodayAttendance(String uid) async {
    try {
      final todayKey = formatDateKey(DateTime.now());
      final docRef = _db.collection('attendance').doc(uid).collection('days').doc(todayKey);
      final doc = await docRef.get();
      if (doc.exists) {
        return {
          'date': todayKey,
          'data': doc.data() ?? {},
        };
      }
      return {
        'date': todayKey,
        'data': null,
      };
    } catch (e) {
      throw Exception('Error getting today attendance: $e');
    }
  }

  static Future<Map<String, dynamic>> getAttendanceByDate(String uid, String date) async {
    try {
      final docRef = _db.collection('attendance').doc(uid).collection('days').doc(date);
      final doc = await docRef.get();
      if (doc.exists) {
        return {
          'date': date,
          'data': doc.data() ?? {},
        };
      }
      return {
        'date': date,
        'data': null,
      };
    } catch (e) {
      throw Exception('Error getting attendance for date: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserAttendanceHistory(String uid, {int limit = 30}) async {
    try {

      Map<String, dynamic> history = await _fetchAttendanceFromPath(uid);

      if (history.isEmpty && uid.length > 20) {
        try {

          final userDoc = await _db.collection('users').doc(uid).get();
          if (userDoc.exists) {
            final userData = userDoc.data()!;
            final email = userData['email'] as String?;
            if (email != null) {
              final emailPrefix = email.split('@').first;
              final fallbackHistory = await _fetchAttendanceFromPath(emailPrefix);
              if (fallbackHistory.isNotEmpty) {

                final verifiedHistory = await _verifyAttendanceOwnership(fallbackHistory, uid, email);
                if (verifiedHistory.isNotEmpty) {
                  history = verifiedHistory;

                  await _migrateAttendanceData(emailPrefix, uid, verifiedHistory);
                }
              }
            }
          }
        } catch (e) {
          print('Error in email prefix fallback: $e');
        }
      }

      final sortedHistory = _sortAttendanceByDate(history, limit);
      return {
        'success': true,
        'uid': uid,
        'history': sortedHistory,
        'source': history.isEmpty ? 'none' : (uid.length > 20 ? 'uid' : 'email_prefix'),
      };
    } catch (e) {
      print('Error getting user history for $uid: $e');
      return {
        'success': false,
        'uid': uid,
        'history': {},
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> _verifyAttendanceOwnership(
    Map<String, dynamic> fallbackHistory, 
    String currentUid, 
    String currentEmail
  ) async {
    Map<String, dynamic> verifiedHistory = {};
    for (final entry in fallbackHistory.entries) {
      final dateKey = entry.key;
      final dayData = entry.value as Map<String, dynamic>;

      final dataUserId = dayData['user_id'] as String?;
      final dataEmail = dayData['email'] as String?;
      bool isOwner = false;
      if (dataUserId != null && dataUserId == currentUid) {

        isOwner = true;
      } else if (dataEmail != null && dataEmail == currentEmail) {

        isOwner = true;
      } else if (dataUserId == null && dataEmail == null) {

        continue;
      } else {

        continue;
      }
      if (isOwner) {
        verifiedHistory[dateKey] = dayData;
      }
    }
    return verifiedHistory;
  }

  static Future<Map<String, dynamic>> _fetchAttendanceFromPath(String path) async {
    try {
      final querySnapshot = await _db
          .collection('attendance')
          .doc(path)
          .collection('days')
          .get();
      Map<String, dynamic> history = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        history[doc.id] = data;
      }
      return history;
    } catch (e) {
      print('Error fetching from path $path: $e');
      return {};
    }
  }

  static Map<String, dynamic> _sortAttendanceByDate(Map<String, dynamic> history, int limit) {
    List<MapEntry<String, dynamic>> entries = [];
    for (var entry in history.entries) {
      entries.add(MapEntry(entry.key, entry.value));
    }

    entries.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.key);
        final dateB = DateTime.parse(b.key);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    final limitedEntries = entries.take(limit).toList();
    Map<String, dynamic> sortedHistory = {};
    for (var entry in limitedEntries) {
      sortedHistory[entry.key] = entry.value;
    }
    return sortedHistory;
  }

  static Future<void> _migrateAttendanceData(String fromPath, String toPath, Map<String, dynamic> verifiedHistory) async {
    try {

      final sourceSnapshot = await _db
          .collection('attendance')
          .doc(fromPath)
          .collection('days')
          .get();
      if (sourceSnapshot.docs.isEmpty) {
        return;
      }

      for (var doc in sourceSnapshot.docs) {
        final data = doc.data();
        final dateKey = doc.id;

        if (verifiedHistory.containsKey(dateKey)) {
          await _db
              .collection('attendance')
              .doc(toPath)
              .collection('days')
              .doc(dateKey)
              .set(data);
        }
      }


    } catch (e) {
      print('Error during migration: $e');
    }
  }

  static Future<bool> hasCheckedInToday(String uid) async {
    try {
      final todayKey = formatDateKey(DateTime.now());
      final docRef = _db.collection('attendance').doc(uid).collection('days').doc(todayKey);
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return data.containsKey('checkInTime') && data['checkInTime'] != 'Not checked in';
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasCheckedOutToday(String uid) async {
    try {
      final todayKey = formatDateKey(DateTime.now());
      final docRef = _db.collection('attendance').doc(uid).collection('days').doc(todayKey);
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data();
        return data?.containsKey('checkOutTime') ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
