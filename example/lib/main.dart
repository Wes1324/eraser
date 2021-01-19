import 'package:eraser/eraser.dart';
import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';

const String _testOneTag = "testOne";
const String _testTwoTag = "testTwo";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _notificationCount = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Eraser plugin example app'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('The badge count on the next notification will be: ${_notificationCount.toString()}'),
              Divider(
                height: 25.0,
                color: Colors.black,
              ),
              Text(
                'Push the button below to send a notification with the "testOne" tag',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                child: Text('Send "testOne" notification'),
                onPressed: () {
                  MoveToBackground.moveTaskToBack();
                  // Send notification
                  setState(() => _notificationCount++);
                },
              ),
              SizedBox(height: 12.0),
              Text(
                'Push the button below to send a notification with the "testTwo" tag',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                child: Text('Send "testTwo" notification'),
                onPressed: () {
                  MoveToBackground.moveTaskToBack();
                  // Send notification
                  setState(() => _notificationCount++);
                },
              ),
              SizedBox(height: 12.0),
              Text(
                'Push the button below to clear all notifications',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                child: Text('Clear all notifications'),
                onPressed: () {
                  setState(() => _notificationCount = 1);
                  Eraser.clearAllAppNotifications();
                },
              ),
              SizedBox(height: 12.0),
              Text(
                'Push the button below to clear notifications with the "testOne" tag',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                child: Text('Clear all "testOne" notifications'),
                onPressed: () {
                  setState(() => _notificationCount = 1);
                  Eraser.clearAppNotificationsByTag(_testOneTag);
                },
              ),
              SizedBox(height: 12.0),
              Text(
                'Push the button below to clear notifications with the "testTwo" tag',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                child: Text('Clear all "testTwo" notifications'),
                onPressed: () {
                  setState(() => _notificationCount = 1);
                  Eraser.clearAppNotificationsByTag(_testTwoTag);
                },
              ),
              SizedBox(height: 12.0),
              Text(
                '(iOS only) Push the button below to reset the badge count and delete all notifications from notification center',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                child: Text('Reset badge count, remove notifications'),
                onPressed: () {
                  Eraser.resetBadgeCountAndRemoveNotificationsFromCenter();
                },
              ),
              SizedBox(height: 12.0),
              Text(
                '(iOS only) Push the button below to reset the badge count but keep all notifications in the notification center',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
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
}
