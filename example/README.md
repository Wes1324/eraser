# eraser_example

Demonstrates the Eraser plugin in action. It runs on an Android emulator/device
or an iOS simulator/device — no Firebase or remote-push setup required.

## Running the example

```sh
flutter pub get
flutter run
```

## What it shows

- **Post test notification** — uses `flutter_local_notifications` to deliver a
  local notification (and set the iOS badge), so there is something for the
  eraser methods to clear. The notification's identifier matches the value in
  the tag field. On iOS, the badge appears on the home-screen app icon.
- **Clear all notifications** — `Eraser.clearAllAppNotifications()`
- **Clear notifications by tag** — `Eraser.clearAppNotificationsByTag(tag)`
- **Reset badge & remove notifications** (iOS) — `Eraser.resetBadgeCountAndRemoveNotificationsFromCenter()`
- **Reset badge, keep notifications** (iOS) — `Eraser.resetBadgeCountButKeepNotificationsInCenter()`

Typical flow: tap **Post test notification** (allow notifications when
prompted), then use a clear/reset button to dismiss it. On iOS, send the app to
the background to see the badge on the app icon. The local notifications here
stand in for the remote push notifications this plugin is designed to clear.
