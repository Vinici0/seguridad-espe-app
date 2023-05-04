import 'dart:async';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/resources/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  //El StreamController va a fluir  el estado del servidor

  StreamController<ServerStatus> _serverStatusController =
      new StreamController<ServerStatus>.broadcast();

  Stream<ServerStatus> get serverStatusStream =>
      this._serverStatusController.stream;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  void connect() async {
    final token = await AuthService.getToken();

    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true, //Para que use el ultimo token
      'extraHeaders': {
        //Se enviará el token en el header de la petición
        'x-token': token,
      }
    });

    this._socket.on('connect', (_) {
      print('connect');
      _serverStatusController.add(ServerStatus.Online);
      this._serverStatus = ServerStatus.Online;
    });

    this._socket.on('disconnect', (_) {
      print('disconnect');
      _serverStatusController.add(ServerStatus.Offline);
      this._serverStatus = ServerStatus.Offline;
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}

final socketService = new SocketService();
