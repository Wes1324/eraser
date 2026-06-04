import 'dart:io';

import 'package:eraser/eraser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _notifications.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ),
  );

  runApp(const EraserExampleApp());
}

class EraserExampleApp extends StatelessWidget {
  const EraserExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eraser example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const EraserHomePage(),
    );
  }
}

class EraserHomePage extends StatefulWidget {
  const EraserHomePage({super.key});

  @override
  State<EraserHomePage> createState() => _EraserHomePageState();
}

class _EraserHomePageState extends State<EraserHomePage> {
  final TextEditingController _tagController =
      TextEditingController(text: '1');

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Posts a delivered notification whose identifier equals [tag], so that
  /// [Eraser.clearAppNotificationsByTag] can target it. On iOS the notification
  /// identifier is the integer id; on Android the tag is set explicitly.
  Future<void> _postNotification() async {
    await _requestPermissions();
    final tag = _tagController.text.trim().isEmpty
        ? '1'
        : _tagController.text.trim();
    final id = int.tryParse(tag) ?? tag.hashCode;

    await _notifications.show(
      id: id,
      title: 'Eraser test notification',
      body: 'Tag "$tag" — clear it with the buttons below.',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'eraser_demo',
          'Eraser demo',
          channelDescription: 'Test notifications for the eraser example',
          tag: tag,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentList: true,
          badgeNumber: 1,
        ),
      ),
    );
    _notify('Posted notification with tag "$tag".');
  }

  Future<void> _clearAll() async {
    await Eraser.clearAllAppNotifications();
    _notify('Cleared all app notifications.');
  }

  Future<void> _clearByTag() async {
    final tag = _tagController.text.trim();
    if (tag.isEmpty) {
      _notify('Enter a tag first.');
      return;
    }
    await Eraser.clearAppNotificationsByTag(tag);
    _notify('Cleared notifications with tag "$tag".');
  }

  Future<void> _resetBadgeAndRemove() async {
    await Eraser.resetBadgeCountAndRemoveNotificationsFromCenter();
    _notify('Reset badge count and removed notifications.');
  }

  Future<void> _resetBadgeKeep() async {
    await Eraser.resetBadgeCountButKeepNotificationsInCenter();
    _notify('Reset badge count, kept notifications.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eraser example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FilledButton(
              onPressed: _postNotification,
              child: const Text('Post test notification'),
            ),
            const Divider(height: 32),
            FilledButton.tonal(
              onPressed: _clearAll,
              child: const Text('Clear all notifications'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: 'Notification tag',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: _clearByTag,
              child: const Text('Clear notifications by tag'),
            ),
            if (Platform.isIOS) ...[
              const Divider(height: 32),
              const Text(
                'iOS badge count',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: _resetBadgeAndRemove,
                child: const Text('Reset badge & remove notifications'),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: _resetBadgeKeep,
                child: const Text('Reset badge, keep notifications'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
