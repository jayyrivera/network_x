

# `network_x` Plugin Usage Guide

`network_x` is a Flutter plugin that provides a highly configurable network client using the Dio package. This guide will walk you through how to install, configure, and use the `network_x` plugin in your Flutter project.

## 1. Installation

To install the `network_x` plugin in your Flutter project, follow these steps:

### Step 1: Add the Plugin to Your Project

Add the `network_x` plugin to your `pubspec.yaml` file under the `dependencies` section:

```yaml
dependencies:
  flutter:
    sdk: flutter
  network_x:
    git:
      url: https://github.com/jayyrivera/network_x.git
```

Then, run `flutter pub get` to install the plugin.

## 2. Configuration

### Step 2: Import the Plugin

In the Dart file where you want to use the network client, import the `network_x` package:

```dart
import 'package:network_x/flutter_network_client.dart';
import 'package:network_x/src/config/network_config.dart';
import 'package:network_x/src/interceptors/logging_interceptor.dart';
import 'package:network_x/src/utils/dialog_utils.dart';
import 'package:network_x/src/models/error_response.dart';
```

### Step 3: Configure the Network Client

Create an instance of `FlutterNetworkClient` with your desired configuration:

```dart
final networkClient = FlutterNetworkClient(
  config: NetworkConfig(
    baseUrl: 'https://yourapi.com',
    headers: {'Authorization': 'Bearer your_token'},
    connectTimeout: 5000,
    receiveTimeout: 3000,
    interceptors: [
      LoggingInterceptor(),
      // Add more interceptors if needed
    ],
  ),
);
```

- **baseUrl:** The base URL for all network requests.
- **headers:** Global headers for all requests, such as authorization tokens.
- **connectTimeout, receiveTimeout:** Set timeouts for requests.
- **interceptors:** Optionally add interceptors for logging, handling responses, etc.

## 3. Usage

### Step 4: Make Network Requests

Use the `networkClient` instance to make network requests. The plugin supports various HTTP methods such as `GET`, `POST`, `PUT`, and `DELETE`.

```dart
Future<void> fetchData(BuildContext context) async {
  try {
    final response = await networkClient.request(
      '/endpoint',
      method: HttpMethod.get,
      data: {},  // If no data, pass an empty map
    );
    // Handle the successful response
    print(response?.data);
  } on ErrorResponse catch (error) {
    // Handle the error and show a dialog
    DialogUtils.showErrorDialog(context, error);
  }
}
```

### Step 5: Handle Errors

The plugin automatically throws `ErrorResponse` for various error scenarios, including network timeouts, server errors, and unknown errors.

Use the provided `DialogUtils.showErrorDialog` method to display error messages to the user:

```dart
try {
  final response = await networkClient.request(
    '/endpoint',
    method: HttpMethod.get,
    data: {},
  );
  print(response?.data);
} on ErrorResponse catch (error) {
  DialogUtils.showErrorDialog(context, error);
}
```

### Example Integration in a Flutter Widget

Here is a complete example of how to integrate the `network_x` plugin into a Flutter widget:

```dart
import 'package:flutter/material.dart';
import 'package:network_x/flutter_network_client.dart';
import 'package:network_x/src/config/network_config.dart';
import 'package:network_x/src/interceptors/logging_interceptor.dart';
import 'package:network_x/src/models/error_response.dart';
import 'package:network_x/src/utils/dialog_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterNetworkClient networkClient;

  MyApp()
      : networkClient = FlutterNetworkClient(
          config: NetworkConfig(
            baseUrl: 'https://jsonplaceholder.typicode.com',
            headers: {'Custom-Header': 'value'},
            connectTimeout: 5000,
            receiveTimeout: 3000,
            interceptors: [
              LoggingInterceptor(),
              // Add more interceptors if needed
            ],
          ),
        );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Network Client Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: fetchData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Response: ${snapshot.data}');
              }
            },
          ),
        ),
      ),
    );
  }

  Future<String> fetchData(BuildContext context) async {
    try {
      final response = await networkClient.request(
        '/posts/1',
        method: HttpMethod.get,
        data: {},
      );
      return response?.data.toString() ?? 'No data';
    } on ErrorResponse catch (error) {
      DialogUtils.showErrorDialog(context, error);
      return 'Error: ${error.message}';
    }
  }
}
```

## 4. Contributing

If you would like to contribute to this plugin, you can fork the repository and submit a pull request. Contributions are welcome!

Repository: [network_x](https://github.com/jayyrivera/network_x.git)

## 5. License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/jayyrivera/network_x/blob/main/LICENSE) file for details.

