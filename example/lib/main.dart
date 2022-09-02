import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:native_dio_client/native_dio_client.dart';
import 'package:cupertino_http/cupertino_client.dart';
import 'package:cupertino_http/cupertino_http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
            onPressed: _doGetRequest,
            child: const Text('make get request'),
          ),
          ElevatedButton(
            onPressed: _doPostRequest,
            child: const Text('make post request'),
          ),
          ElevatedButton(
            onPressed: _doClientRequest,
            child: const Text('make client request'),
          ),
        ],
      ),
    );
  }

  void _doGetRequest() async {
    final dio = Dio();

    dio.httpClientAdapter = NativeAdapter(
      configuration: URLSessionConfiguration.ephemeralSessionConfiguration()
        ..allowsCellularAccess = false
        ..allowsConstrainedNetworkAccess = false
        ..allowsExpensiveNetworkAccess = false,
    );
    final response = await dio.get<String>('https://flutter.dev');

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Response ${response.statusCode}'),
          content: SingleChildScrollView(
            child: Text(response.data ?? 'No response'),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  void _doPostRequest() async {
    final dio = Dio();

    dio.httpClientAdapter = NativeAdapter(
      configuration: URLSessionConfiguration.ephemeralSessionConfiguration()
        ..allowsCellularAccess = false
        ..allowsConstrainedNetworkAccess = false
        ..allowsExpensiveNetworkAccess = false,
    );
    final response = await dio.post<String>('https://httpbin.org/post');

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Response ${response.statusCode}'),
          content: SingleChildScrollView(
            child: Text(response.data ?? 'No response'),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  void _doClientRequest() async {
    final config = URLSessionConfiguration.ephemeralSessionConfiguration()
      ..allowsCellularAccess = false
      ..allowsConstrainedNetworkAccess = false
      ..allowsExpensiveNetworkAccess = false;
    final client = CupertinoClient.fromSessionConfiguration(config);
    final response = await client.get(Uri.parse('https://flutter.dev/'));
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Response ${response.statusCode}'),
          content: SingleChildScrollView(
            child: Text(response.body),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }
}
