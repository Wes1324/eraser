# eraser

A Flutter plugin that allows notifications and iOS badge counts to be dismissed programmatically.

<img src="Android-eraser.gif" width="360" height="640" />

## Getting Started

The `clearAllAppNotifications` method can be invoked to clear all notifications received by your Flutter app.<br />

In order to dismiss notifications selectively, the notification needs to include a tag (for Android) and an apns-collapse-id header (for iOS). The below code snippet shows how to do this using a Google Cloud Function written in node.js:

```javascript
const notificationTag: string = 'notificationTag';

await admin.messaging().sendMulticast({
        tokens: deviceTokens,
        notification: {
            title: 'Notification Title',
            body: 'Notification message',
        },
        android: {
            notification: {
                tag: notificationTag,
            },
        },
        apns: {
            headers: {
                'apns-collapse-id': notificationTag,
            },
        },
    });
```

The `clearAppNotificationsByTag` method can then be used to clear all notifications with that notificationTag.

## Badge count
Upon receiving push notifications, iOS devices typically display a red dot on top of the app icon with a number inside. If iOS notifications are dismissed, this badge count remains, so it was necessary to provide some functionality to remove this badge count.<br />
By default, dismissing the badge count also dismisses all notifications from the iOS notification center. If this is acceptable, use the `resetBadgeCountAndRemoveNotificationsFromCenter` method.<br />
If however you require the notifications to remain in the notification center after dismissing the badge count, then the `resetBadgeCountButKeepNotificationsInCenter` method should be used.<br />

Android 8.0 introduced similar 'badge count' functionality. However Android calls this functionality 'notification badges', and the number inside the badge is known as a 'notification count'. When notifications are dismissed, Android automatically gets rid of the notification count. For this reason, the `resetBadgeCount...` methods do nothing when called on an Android device.

## iOS compatibility
This plugin is only capable of clearing notifications on iOS devices running iOS 10 or above. The methods will return silently without dismissing notifications if running on devices with iOS 9 or lower. This was deemed acceptable because it seems that the Firebase plugins themselves only support iOS 10 and above.

## Tests
This plugin is quite simple and just delegates to platform-specific code in order to provide its functionality. This platform-specific code should already be tested by Google and Apple. For that reason, there isn't really anything to test and the plugin has no unit tests.<br />
If anyone can think of any possible unit tests, then feel free to suggest them, or open a pull request.
