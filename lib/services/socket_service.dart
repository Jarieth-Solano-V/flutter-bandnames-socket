import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//Enumeracion para manejar los estados del server
enum ServerStatus {
  // ignore: constant_identifier_names
  Online,
  // ignore: constant_identifier_names
  Offline,
  // ignore: constant_identifier_names
  Connecting,
}

//El changeNotifier me ayuda a decirle al provider cuando tiene que realizar un cambio de mi interes
//El changeNotifier esta asociado a un nivel global en la aplicacion, puede redibujar en cualquier lugar que lo esten llamando
class SocketService with ChangeNotifier {
  //Es privado debido a que se quiere controlar la manera  de como se quiere utilizar
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  //Para utilizarlo en otras pantallas
  ServerStatus get serverStatus => _serverStatus;

  //Para poder ser uitilizado en otras pantalllas
  IO.Socket get socket => _socket;

  //Generamos un emit multifuncional
  Function get emit => _socket.emit;

  //Constructor
  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client:

    //Establecemos la conexion con el servidor
    _socket = IO.io('http://192.168.0.25:3001', {
      //Conexiones mediantes sockets
      'transports': ['websocket'],
      'autoConnect': true,
    });

    //Si el socket (al servidor) se logra conectar mostrar "Online"
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      //Esuchamos cuando el servidor se conecta
      notifyListeners();
    });

    //Si el scoket (al servidor) no se logra conectar mortrar "Offline"
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      //Esuchamos cuando el servidor se desconecta
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //print('nuevo-mensaje:');
    //print('nombre:' + payload['nombre']);
    //print('mensaje' + payload['mensaje']);
    //Pregunta si viene el mensaje2 y si no, mostrar "no hay"
    //print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    //});
  }
}
