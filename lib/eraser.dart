import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class Eraser {
  static const MethodChannel _channel = const MethodChannel('eraser');

  static Future<void> clearAllAppNotifications() async {
    try {
      await _channel.invokeMethod('clearAllAppNotifications');
    } on PlatformException catch (e) {
      print('Failed to clear all app notifications for following reason: ${e.message}');
    }
  }

  static Future<void> clearAppNotificationsByTag(String tag) async {
    try {
      await _channel.invokeMethod('clearAppNotificationsByTag', <String, dynamic>{
        'tag': tag,
      });
    } on PlatformException catch (e) {
      print('Failed to clear app notifications for tag ($tag) for following reason: ${e.message}');
    }
  }

  static Future<void> resetBadgeCountAndRemoveNotificationsFromCenter() async {
    if (Platform.isIOS) {
      try {
        await _channel.invokeMethod('resetBadgeCountAndRemoveNotificationsFromCenter');
      } on PlatformException catch (e) {
        print('Failed to reset badge count for following reason: ${e.message}');
      }
    }
  }

  static Future<void> resetBadgeCountButKeepNotificationsInCenter() async {
    if (Platform.isIOS) {
      try {
        await _channel.invokeMethod('resetBadgeCountButKeepNotificationsInCenter');
      } on PlatformException catch (e) {
        print('Failed to reset badge count for following reason: ${e.message}');
      }
    }
  }
}
