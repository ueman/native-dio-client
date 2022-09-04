import 'dart:typed_data';

import 'package:cupertino_http/cupertino_client.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:dio/dio.dart';
import 'package:native_dio_client/src/conversion_layer_adapter.dart';

class CupertinoAdapter extends HttpClientAdapter {
  CupertinoAdapter(URLSessionConfiguration configuration)
      : _conversionLayer = ConversionLayerAdapter(
            CupertinoClient.fromSessionConfiguration(configuration));

  final ConversionLayerAdapter _conversionLayer;
  @override
  void close({bool force = false}) => _conversionLayer.close(force: force);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) =>
      _conversionLayer.fetch(options, requestStream, cancelFuture);
}
