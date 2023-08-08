// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:architecture_proposal_domain/architecture_proposal_domain.dart';
import 'package:rxdart/rxdart.dart';

class DerivApi implements DataSource, AppConnectionProvider {
  static DerivApi? _instance;
  static DerivApi get instance => _instance ??= DerivApi._();

  final StreamController _dataController = StreamController.broadcast();
  final BehaviorSubject<bool> _connectionStatusController =
      BehaviorSubject.seeded(true);

  WebSocket? _webSocket;

  Stream<dynamic>? get _dataStream => _dataController.stream;

  @override
  Stream<bool> get isConnectedStream =>
      _connectionStatusController.stream.skip(1).distinct();

  @override
  Future<Map<String, dynamic>> request({
    required Map<String, dynamic> request,
    bool holdOnOffline = true,
  }) {
    final reqId = Object().hashCode.toString();
    request['req_id'] = reqId;

    _sendData(request, holdOnOffline: holdOnOffline);

    return _getResponseFor(reqId, holdOnOffline: holdOnOffline);
  }

  @override
  Future<Stream<Map<String, dynamic>>> requestStream({
    required Map<String, dynamic> request,
    bool holdOnOffline = true,
  }) async {
    final reqId = Object().hashCode.toString();
    request['req_id'] = reqId;

    _sendData(request, holdOnOffline: holdOnOffline);

    final stream = await _getStreamFor(reqId, holdOnOffline: holdOnOffline);

    return stream;
  }

  Future<Stream<Map<String, dynamic>>> _getStreamFor(
    String reqId, {
    bool holdOnOffline = true,
  }) async {
    while (!_connectionStatusController.value && holdOnOffline) {
      await Future.delayed(Duration(seconds: 1));
    }

    final streamResp = _dataStream!
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
    String reqId, {
    bool holdOnOffline = true,
  }) async {
    final stream = await _getStreamFor(reqId, holdOnOffline: holdOnOffline);

    return stream.first;
  }

  Future<void> _sendData(
    Map<String, dynamic> data, {
    bool holdOnOffline = true,
  }) async {
    while (!_connectionStatusController.value && holdOnOffline) {
      await Future.delayed(Duration(seconds: 1));
    }

    _webSocket?.add(json.encode(data));
  }

  void _setupConnectionListener() {
    Stream.periodic(Duration(seconds: 3)).listen(
      (_) => _pingServer().on(onData: _connectionStatusController.add),
    );
  }

  DerivApi._() {
    _initWebSocket();
    _setupConnectionListener();
  }

  Future<bool> _pingServer() async =>
      request(request: {'ping': 1}, holdOnOffline: false)
          .timeout(Duration(seconds: 3))
          .then((value) => true)
          .catchError((_) => false);

  void _initWebSocket() =>
      WebSocket.connect('wss://ws.binaryws.com/websockets/v3?app_id=1089').then(
          (value) {
        value.listen(
          _dataController.add,
          onDone: () => retryWSConnection(),
          onError: (_) => retryWSConnection,
        );
        _webSocket = value;
      }).catchError((_) =>
          retryWSConnection()); // TODO: this might throw exceptionas we're not returning future data. but it has no effect on app.

  Future<void> retryWSConnection() async {
    await Future.delayed(Duration(seconds: 1));
    _initWebSocket();
  }
}
