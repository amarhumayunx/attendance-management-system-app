import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
class UserService {
  static String? _currentUid;



  static Future<String> getCurrentUid() async {
    if (_currentUid != null) {
      return _currentUid!;
    }
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {

        _currentUid = user.uid;
        return _currentUid!;
      }

      final deviceInfo = DeviceInfoPlugin();
      String deviceId = '';
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceId = '${info.manufacturer}_${info.model}_${info.id}';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceId = '${info.utsname.machine}_${info.identifierForVendor}';
      } else {
        deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
      }
      _currentUid = 'user_${deviceId.hashCode.abs()}';
      return _currentUid!;
    } catch (e) {

      _currentUid = 'user_${DateTime.now().millisecondsSinceEpoch}';
      return _currentUid!;
    }
  }

  static void clearUid() {
    _currentUid = null;
  }
}
