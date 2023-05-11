import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService
    with ChangeNotifier
    implements StateStreamableSource<ServerStatus> {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket = IO.io(Environment.socketUrl);

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  final _statusController = StreamController<ServerStatus>.broadcast();

  Stream<ServerStatus> get statusStream => this._statusController.stream;

  void connect() async {
    final token = await AuthService.getToken();

    this._socket = IO.io(
      Environment.socketUrl,
      {
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': true,
        'extraHeaders': {
          'x-token': token,
        }
      },
    );

    this._socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      _statusController.add(ServerStatus.Online);
    });

    this._socket.on('disconnect', (_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      _statusController.add(ServerStatus.Offline);
    });
  }

  void disconnect() {
    this._socket.disconnect();
    this._statusController.close();
  }

  @override
  FutureOr<void> close() {
    _socket.disconnect();
    _statusController.close();
  }

  @override
  bool get isClosed => _statusController.isClosed;

  @override
  ServerStatus get state => _serverStatus;

  @override
  Stream<ServerStatus> get stream => _statusController.stream;
}
