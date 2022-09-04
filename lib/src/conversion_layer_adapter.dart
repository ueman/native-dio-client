import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

class ConversionLayerAdapter extends HttpClientAdapter {
  final Client client;

  ConversionLayerAdapter(this.client);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    final request = await _fromOptionsAndStream(options, requestStream);
    final response = await client.send(request);
    return response.toDioResponseBody();
  }

  @override
  void close({bool force = false}) => client.close();

  Future<BaseRequest> _fromOptionsAndStream(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
  ) async {
    final request = Request(
      options.method,
      options.uri,
    );

    request.headers.addAll(Map.fromEntries(options.headers.entries
        .map((e) => MapEntry(e.key, e.value.toString()))));

    request.followRedirects = options.followRedirects;
    request.maxRedirects = options.maxRedirects;

    if (requestStream != null) {
      var completer = Completer<Uint8List>();
      var sink = ByteConversionSink.withCallback(
        (bytes) => completer.complete(Uint8List.fromList(bytes)),
      );
      requestStream.listen(
        sink.add,
        onError: completer.completeError,
        onDone: sink.close,
        cancelOnError: true,
      );
      var bytes = await completer.future;

      request.bodyBytes = bytes;
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
