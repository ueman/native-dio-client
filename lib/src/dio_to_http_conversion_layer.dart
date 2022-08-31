import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

class DioToHttpConversionLayer extends HttpClientAdapter {
  final Client client;

  DioToHttpConversionLayer(this.client);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    final response =
        await client.send(await _fromOptionsAndStream(options, requestStream));
    return response.toDioResponseBody();
  }

  @override
  void close({bool force = false}) => client.close();

  Future<BaseRequest> _fromOptionsAndStream(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
  ) async {
    final request = StreamedRequest(
      options.method,
      options.uri,
    );

    request.headers.addAll(Map.fromEntries(options.headers.entries
        .map((e) => MapEntry(e.key, e.value.toString()))));
    request.followRedirects = options.followRedirects;
    request.maxRedirects = options.maxRedirects;
    if (requestStream != null) {
      request.sink.add(List<int>.from(await requestStream.toList()));
    }

    return request;
  }
}

extension on StreamedResponse {
  ResponseBody toDioResponseBody() {
    final dioHeaders = headers.entries.map((e) => MapEntry(e.key, [e.value]));

    return ResponseBody(
      Stream.fromFuture(stream.toBytes()),
      statusCode,
      headers: Map.fromEntries(dioHeaders),
      isRedirect: isRedirect,
      statusMessage: reasonPhrase,
    );
  }
}
