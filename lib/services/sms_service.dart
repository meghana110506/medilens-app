import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsService {
  static const _channel = MethodChannel('com.example.medilens/sms');

  /// Sends an SMS silently in the background without opening any UI.
  /// Returns true on success, false on failure.
  static Future<bool> sendSilent({
    required String phone,
    required String message,
  }) async {
    try {
      final status = await Permission.sms.request();
      if (!status.isGranted) return false;

      await _channel.invokeMethod('sendSMS', {
        'phone': phone,
        'message': message,
      });
      return true;
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('SmsService error: ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('SmsService unexpected error: $e');
      return false;
    }
  }

  /// Sends SMS to multiple recipients silently.
  /// Returns the count of successful sends.
  static Future<int> sendToMultiple({
    required List<String> phones,
    required String message,
  }) async {
    int successCount = 0;
    for (final phone in phones) {
      final success = await sendSilent(phone: phone, message: message);
      if (success) successCount++;
    }
    return successCount;
  }
}
