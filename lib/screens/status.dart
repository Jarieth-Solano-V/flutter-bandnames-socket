import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_service.dart';

// ignore: use_key_in_widget_constructors
class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ServerStatus: ${socketService.serverStatus}')
          ],
        ),
      ),
      //Boton
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            //Funcion que envia el 'emitir-mensaje' al html
            socketService.emit('emitir-mensaje',
                {'nombre': 'Flutter', 'mensaje': 'Hola Flutter'});
          }),
    );
  }
}
