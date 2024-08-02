import 'dart:convert';

import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';

import 'firebase_options.dart';

const String _testOneTag = "testOne";
const String _testTwoTag = "testTwo";
const List<String> _scopes = [
  "https://www.googleapis.com/auth/firebase.messaging"
];
http.Client _httpClient = http.Client();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _deviceToken;
  String? _googleFcmOauthAccessToken;
  int _testOneNotificationCount = 0;
  int _testTwoNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    getDeviceToken();
    getFCMOauthToken();
  }

  getDeviceToken() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    setState(() => _deviceToken = deviceToken);
  }

  getFCMOauthToken() async {
    // TODO: Place Firebase private key file into privateKey directory and paste filename below
    String privateKeyFileAsString = await rootBundle
        .loadString('privatekey/YOUR-PRIVATE-KEY-FILE-NAME.json');
    var privateKeyObject = json.decode(privateKeyFileAsString);
    ServiceAccountCredentials serviceAccountCredentials =
        ServiceAccountCredentials.fromJson(privateKeyObject);
    AccessCredentials accessCredentials =
        await obtainAccessCredentialsViaServiceAccount(
            serviceAccountCredentials, _scopes, _httpClient);
    setState(
        () => _googleFcmOauthAccessToken = accessCredentials.accessToken.data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Eraser plugin example app'),
        ),
        body: _deviceToken == null || _googleFcmOauthAccessToken == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                        'Number of testOne notifications sent so far: $_testOneNotificationCount'),
                    Text(
                        'Number of testTwo notifications sent so far: $_testTwoNotificationCount'),
                    Divider(
                      height: 25.0,
                      color: Colors.black,
                    ),
                    Text(
                      'Push the button below to send a notification with the "testOne" tag',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: Text('Send "testOne" notification'),
                      onPressed: () async {
                        // Need to move app to background in order for firebase messaging to handle the push notification.
                        // Push notifications received while app is in foreground do nothing.
                        MoveToBackground.moveTaskToBack();

                        setState(() => _testOneNotificationCount++);

                        // Wait 1 second before actually creating push notification to ensure that app is in background
                        await Future.delayed(
                          Duration(seconds: 1),
                          () => createPushNotification(
                              _testOneTag, _testOneNotificationCount),
                        );
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Push the button below to send a notification with the "testTwo" tag',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: Text('Send "testTwo" notification'),
                      onPressed: () async {
                        // Need to move app to background in order for firebase messaging to handle the push notification.
                        // Push notifications received while app is in foreground do nothing.
                        MoveToBackground.moveTaskToBack();

                        setState(() => _testTwoNotificationCount++);

                        // Wait 1 second before actually creating push notification to ensure that app is in background
                        await Future.delayed(
                          Duration(seconds: 1),
                          () => createPushNotification(
                              _testTwoTag, _testTwoNotificationCount),
                        );
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Push the button below to clear all notifications',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: Text('Clear all notifications'),
                      onPressed: () {
                        setState(() {
                          _testOneNotificationCount = 0;
                          _testTwoNotificationCount = 0;
                        });
                        Eraser.clearAllAppNotifications();
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Push the button below to clear notifications with the "testOne" tag',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: Text('Clear all "testOne" notifications'),
                      onPressed: () {
                        setState(() => _testOneNotificationCount = 0);
                        Eraser.clearAppNotificationsByTag(_testOneTag);
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Push the button below to clear notifications with the "testTwo" tag',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: Text('Clear all "testTwo" notifications'),
                      onPressed: () {
                        setState(() => _testTwoNotificationCount = 0);
                        Eraser.clearAppNotificationsByTag(_testTwoTag);
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      '(iOS only) Push the button below to reset the badge count and delete all notifications from notification center',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: Text('Reset badge count, remove notifications'),
                      onPressed: () {
                        Eraser
                            .resetBadgeCountAndRemoveNotificationsFromCenter();
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      '(iOS only) Push the button below to reset the badge count but keep all notifications in the notification center',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: Text('Reset badge count, keep notifications'),
                      onPressed: () {
                        Eraser.resetBadgeCountButKeepNotificationsInCenter();
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  createPushNotification(String tag, int notificationCount) async {
    // TODO: Place your project id into the URL below
    String firebaseCloudMessagingUrl =
        'https://fcm.googleapis.com/v1/projects/YOUR-PROJECT-ID/messages:send';
    Uri fcmUri = Uri.parse(firebaseCloudMessagingUrl);
    http.Response result = await http.post(
      fcmUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_googleFcmOauthAccessToken',
      },
      body: jsonEncode({
        'message': {
          'token': _deviceToken,
          'notification': {
            'title': 'Eraser',
            'body': 'This notification has the $tag tag',
          },
          'android': {
            'notification': {
              'tag': tag,
              // Android remembers previous notification count and simply adds the value to the previous cumulative notification count value.
              // This is different to the iOS behaviour (see comment below on 'apns.payload.aps.badge' field)
              'notification_count': notificationCount,
            },
          },
          'apns': {
            'headers': {
              'apns-collapse-id': tag,
            },
            'payload': {
              'aps': {
                // In contrast to Android (see comment above on 'android.notification.notification_count' field'), iOS disregards
                // previous notification counts and simple displays what is in the payload.
                'badge': _testOneNotificationCount + _testTwoNotificationCount,
              },
            }
          }
        }
      }),
    );
    if (result.statusCode != 200) {
      print(
          'Request to FCM failed with code ${result.statusCode} and body ${result.body}');
    }
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
