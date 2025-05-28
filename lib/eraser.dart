import 'dart:io';

import 'package:flutter/services.dart';

class Eraser {
  static const MethodChannel _channel = const MethodChannel('eraser');

  /// Clears all push notifications that have been received by your Flutter app.
  ///
  /// On Android this causes the small icon(s) to be removed from the status bar,
  /// and the notifications to be removed from the notification drawer.
  /// On iOS, this causes the notification(s) to be removed from the notification center.
  /// This does not affect the notifications received by other apps running on the device.
  static Future<void> clearAllAppNotifications() async {
    try {
      await _channel.invokeMethod('clearAllAppNotifications');
    } on PlatformException catch (e) {
      print(
          'Failed to clear all app notifications for following reason: ${e.message}');
    }
  }

  /// Clears all push notifications that have been received by your Flutter app that have the specified [tag].
  ///
  /// The tag is specified in the payload of the notification.
  /// Android notification payloads have a 'tag' property where this should be specified.
  /// While on iOS, the tag should be placed in the apns-collapse-id header.
  static Future<void> clearAppNotificationsByTag(String tag) async {
    try {
      await _channel
          .invokeMethod('clearAppNotificationsByTag', <String, dynamic>{
        'tag': tag,
      });
    } on PlatformException catch (e) {
      print(
          'Failed to clear app notifications for tag ($tag) for following reason: ${e.message}');
    }
  }

  /// Clears all push notifications that have been received by your Flutter app that container the specified pattern in their [tag].
  ///
  /// The tag is specified in the payload of the notification.
  /// Android notification payloads have a 'tag' property where this should be specified.
  /// While on iOS, the tag should be placed in the apns-collapse-id header.
  static Future<void> clearAppNotificationsByTagThatContains(
      String pattern) async {
    try {
      await _channel.invokeMethod(
          'clearAppNotificationsByTagThatContains', <String, dynamic>{
        'pattern': pattern,
      });
    } on PlatformException catch (e) {
      print(
          'Failed to clear app notifications for pattern ($pattern) for following reason: ${e.message}');
    }
  }

  /// Sets the iOS applicationIconBadgeNumber to 0, thus removing the badge count from the app icon.
  /// Doing this also means that the notifications are removed from the iOS notifications center at the same time.
  ///
  /// This is iOS-specific, as Android clears the 'notification count' automatically when notifications are dismissed.
  static Future<void> resetBadgeCountAndRemoveNotificationsFromCenter() async {
    if (Platform.isIOS) {
      try {
        await _channel
            .invokeMethod('resetBadgeCountAndRemoveNotificationsFromCenter');
      } on PlatformException catch (e) {
        print('Failed to reset badge count for following reason: ${e.message}');
      }
    }
  }

  /// Sets the iOS applicationIconBadgeNumber to -1, which causes the badge count to be removed from the app icon.
  /// However, setting to -1 means that the notifications remain in the iOS notifications center.
  ///
  /// This is iOS-specific, as Android clears the 'notification count' automatically when notifications are dismissed.
  static Future<void> resetBadgeCountButKeepNotificationsInCenter() async {
    if (Platform.isIOS) {
      try {
        await _channel
            .invokeMethod('resetBadgeCountButKeepNotificationsInCenter');
      } on PlatformException catch (e) {
        print('Failed to reset badge count for following reason: ${e.message}');
      }
    }
  }
}
