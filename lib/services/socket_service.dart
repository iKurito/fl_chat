// ignore_for_file: avoid_print, library_prefixes
import 'package:fl_chat/global/environment.dart';
import 'package:fl_chat/services/services.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  Function get emit => _socket.emit;

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(
      //'http://192.168.1.18:3000', 
      //'https://fl-band-names-server.herokuapp.com/',
      Environment.socketUrl,
      IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .enableAutoConnect()  // enable auto-connection
        .enableForceNew()
        .setExtraHeaders({
          'x-token': token
        })
        .build()
    );

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) => {
      _serverStatus = ServerStatus.offline,
      notifyListeners()
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mensaje:');
    //   print('nombre: ${payload['nombre']}');
    //   print('nombre: ${payload['mensaje']}');
    // });
  }

  void disconnect() {
    _socket.disconnect();
  }
}