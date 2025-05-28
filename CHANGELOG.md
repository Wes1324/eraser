## 3.0.1

Add the option to clear multiple notifications that their tag contains given pattern

## 3.0.0

- Update compileSdk for Android to 34
- Use Gradle's declarative plugins block
- Upgrade dependencies

## 2.0.2

- Fix a NullPointerException when trying to clear notifications by tag when there are also notifications that do not have the tag attribute set. Credit to
  mschudt for submitting the PR.

## 2.0.1

- Remove hardcoded notification id so that all notifications with a certain tag are removed, regardless of their id

## 2.0.0

- Migrate to null-safety

## 1.0.2

- Add more information and examples to the README.md file

## 1.0.1

- Use the dartfmt command to format all Dart source code
- Add some documentation to Dart source code
- Change src attribute of GIF in readme in an attempt to show GIF correctly on Pub website

## 1.0.0

Initial version of the plugin.

- Clear all notifications received by your Flutter app, or selected notifications based on a tag
- Clear the iOS badge count, with the option to remove or retain notifications in the notification center
