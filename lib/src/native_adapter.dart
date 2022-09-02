import 'dart:io';
import 'dart:typed_data';

import 'package:cronet_http/cronet_client.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:native_dio_client/src/cronet_adapter.dart';
import 'package:native_dio_client/src/cupertino_adapter.dart';

class NativeAdapter extends HttpClientAdapter {
  NativeAdapter({
    CronetClient? cronetClient,
    URLSessionConfiguration? configuration,
  }) {
    if (Platform.isAndroid) {
      _adapter = CronetAdapter(cronetClient ?? CronetClient());
    } else if (Platform.isIOS || Platform.isMacOS) {
      _adapter = CupertinoAdapter(
        configuration ?? URLSessionConfiguration.defaultSessionConfiguration(),
      );
    } else {
      _adapter = DefaultHttpClientAdapter();
    }
  }
  late final HttpClientAdapter _adapter;
  @override
  void close({bool force = false}) => _adapter.close(force: force);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) =>
      _adapter.fetch(options, requestStream, cancelFuture);
}
