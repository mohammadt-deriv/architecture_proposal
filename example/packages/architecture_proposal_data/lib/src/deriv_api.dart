// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:rxdart/rxdart.dart';

class DerivApi implements DataSource {
  static DerivApi? _instance;
  static DerivApi get instance => _instance ??= DerivApi._();

  final StreamController _controller = StreamController.broadcast();

  WebSocket? _webSocket;
  bool isConnected = false;

  Stream<dynamic>? get stream => _controller.stream;

  DerivApi._() {
    _initWebSocket();
  }

  void _initWebSocket() =>
      WebSocket.connect('wss://ws.binaryws.com/websockets/v3?app_id=1089')
          .then((value) {
        _webSocket = value;

        _webSocket!.listen(
          (event) {
            _controller.add(event);
          },
          onDone: retryWSConnection,
          onError: (_) => retryWSConnection,
        );

        isConnected = true;
      }).catchError((_) => retryWSConnection());

  Future<void> retryWSConnection() async {
    isConnected = false;

    await Future.delayed(Duration(seconds: 1));
    _initWebSocket();
  }

  @override
  Future<Map<String, dynamic>> request({
    required Map<String, dynamic> request,
  }) {
    final reqId = Object().hashCode.toString();
    request['req_id'] = reqId;

    _sendData(request);

    return _getResponseFor(reqId);
  }

  @override
  Future<Stream<Map<String, dynamic>>> requestStream(
      {required Map<String, dynamic> request}) async {
    final reqId = Object().hashCode.toString();
    request['req_id'] = reqId;

    _sendData(request);

    final stream = await _getStreamFor(reqId);

    return stream;
  }

  Future<Stream<Map<String, dynamic>>> _getStreamFor(
    String reqId,
  ) async {
    while (!isConnected) {
      await Future.delayed(Duration(seconds: 1));
    }

    final streamResp = stream!
        .map((event) => json.decode(event))
        .whereType<Map<String, dynamic>>()
        .where((message) => message['req_id'].toString() == reqId);

    final firstData = await streamResp.first;

    final hasError = firstData.containsKey('error');

    if (hasError) {
      throw DataException(
        DataExceptionType.server,
        message: firstData['error']['message'],
        code: firstData['error']['code'],
      );
    }

    return (streamResp.startWith(firstData));
  }

  Future<Map<String, dynamic>> _getResponseFor(
    String reqId,
  ) async {
    final stream = await _getStreamFor(reqId);

    return stream.first;
  }

  Future<void> _sendData(Map<String, dynamic> data) async {
    while (!isConnected) {
      await Future.delayed(Duration(seconds: 1));
    }

    _webSocket?.add(json.encode(data));
  }
}
