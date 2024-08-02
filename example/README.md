# eraser_example

Demonstrates the Eraser plugin in action.<br />
In terms of Android, this example can run either on an Android emulator or a physical Android device.<br />
In terms of iOS, this example must be run on a physical device, as push notifications can not be received by the Apple Simulator.

## Running the example

### Firebase integration

In order for the example to work, integration with Firebase is necessary. Basically, this consists of:
- Installing the Firebase CLI
- Running `flutterfire configure` command in this example project's directory
More detailed instructions of the firebase integration process, can be found at the following locations on the Firebase website for [Android](https://firebase.google.com/docs/flutter/setup?platform=android) and [iOS](https://firebase.google.com/docs/flutter/setup?platform=ios)

### Firebase Cloud Messaging (FCM) REST API

This example uses the newer v1 FCM REST API, as opposed to the older legacy REST API. For that reason, authentication requires a private key file.<br />
This can be downloaded by navigating the Project Settings, clicking the 'Service Accounts' tab and clicking the 'Generate new private key' button.<br />
Once downloaded, this file must be added to the 'privateKey' directory in the example.<br />
The name of the private key file also needs to be added to the main.dart file. There is a TODO comment in the main.dart file indicating where this must go.<br />
Additionally, there is another TODO comment in the main.dart file indicating where the project-id must be added.

### Running on iOS

In addition to the above setup, running this example on an iOS device requires further setup. Basically, this consists of:
- Adding your Apple Developer certificate to Firebase
- Creating an app id for the example app in your Apple developer account
- Creating a Provisioning Profile
More detailed instructions of the firebase integration process, can be found in the [official FlutterFire FCM docs](https://firebase.flutter.dev/docs/messaging/apple-integration)

### Behaviour of example app

Note that upon clicking either the `Send "testOne" notification` or `send "testTwo" notification` button, the app will be moved to the background. This is necessary because by default push notifications received when the app is in the foreground do nothing.