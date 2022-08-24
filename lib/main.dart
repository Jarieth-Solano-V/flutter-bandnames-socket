import 'package:band_names/screens/status.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:band_names/screens/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

//Snippets "Mateapp" para crear esta estructura
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Inicializar cuantas intancias quiero de mis modelos
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',

        //Llamamos a la ruta inicial mediante su instacia
        initialRoute: 'home',

        //Establecemos las rutas con una instancia
        routes: {
          'home': (_) => HomeScreen(),
          'status': (_) => StatusScreen(),
        },
      ),
    );
  }
}
