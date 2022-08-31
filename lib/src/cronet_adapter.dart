import 'dart:typed_data';

import 'package:cronet_http/cronet_client.dart';
import 'package:dio/dio.dart';
import 'package:native_dio_client/src/dio_to_http_conversion_layer.dart';

class CronetAdapter extends HttpClientAdapter {
  CronetAdapter(CronetClient client)
      : _conversionLayer = DioToHttpConversionLayer(client);

  final DioToHttpConversionLayer _conversionLayer;

  @override
  void close({bool force = false}) => _conversionLayer.close(force: force);

  @override
  Future<ResponseBody> fetch(RequestOptions options,
          Stream<Uint8List>? requestStream, Future<dynamic>? cancelFuture) =>
      _conversionLayer.fetch(options, requestStream, cancelFuture);
}
