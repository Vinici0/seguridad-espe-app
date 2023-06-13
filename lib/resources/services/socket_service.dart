import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
