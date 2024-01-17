import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  SocketService() {
    _initConfig();
  }
  _initConfig() {
    IO.Socket socket = IO.io('http://192.168.0.91:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) {
      socket.emit('mensaje', 'test');
    });
  }
}