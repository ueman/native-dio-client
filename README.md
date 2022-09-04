# Native Dio Client

----

> Note: Experimental

The underlying technology is still considered experimental, therefore this
is also considered experimental.

----


A client for [Dio](https://pub.dev/packages/dio) which makes use of [`cupertino_http`](https://pub.dev/packages/cupertino_http) and [`cronet_http`](https://pub.dev/packages/cronet_http) to delegate HTTP requests to the native platform instead of the `dart:io` platforms.

Inspired by the [Dart 2.18 release blog](https://medium.com/dartlang/dart-2-18-f4b3101f146c).

# Motivation

Using the native platform implementation, rather than the socket-based [`dart:io` HttpClient](https://api.dart.dev/stable/dart-io/HttpClient-class.html) implemententation, has several advantages:

- It automatically supports platform features such VPNs and HTTP proxies.
- It supports many more configuration options such as only allowing access through WiFi and blocking cookies.
- It supports more HTTP features such as HTTP/3 and custom redirect handling.

# Example

```dart
final dioClient = Dio();
if (Platform.isIOS || Platform.isMacOS || Platform.isAndroid) {
  dioClient.httpClientAdapter = NativeAdapter();
}
```