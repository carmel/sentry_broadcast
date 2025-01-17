# `sentry_broadcast` Flutter Library

`sentry_broadcast` is a Flutter library designed to facilitate the reporting of crash information from your Flutter app. It uses WebSocket to send crash data in a specific message format to a remote server for logging and monitoring purposes.

## Features

- **Crash Reporting**: Automatically captures crash data from your Flutter app.
- **WebSocket Integration**: Sends crash data to a remote server in real-time via WebSocket.
- **Customizable Format**: The crash information is sent in the format `{data: crash_info, typ: 'text'}`, allowing easy integration with server-side monitoring solutions.

## Installation

To use `sentry_broadcast`, add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  sentry_broadcast: ^1.0.0
```

## Usage

```dart
import 'package:sentry_broadcast/sentry_broadcast.dart';

void main() async {
  // Initialize sentry_broadcast with the WebSocket server URL
  final cli = BroadcastClient('ws://yourserver.com/crash-reports');
  await cli.connect();
  FlutterError.onError = (errorDetails) {
    cli.report(errorDetails.exceptionAsString());
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    cli.report(error.toString());
    cli.report(stack.toString());
    return true;
  };
  runApp(MyApp());
}
```
