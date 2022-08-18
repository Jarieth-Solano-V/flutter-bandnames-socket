import 'package:flutter/material.dart';
import 'package:band_names/screens/home.dart';

void main() => runApp(MyApp());

//Snippets "Mateapp" para crear esta estructura
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',

      //Enrutamos la primera pagina a mostrar, desde nuestro archivo "main"
      initialRoute: 'home',
      routes: {'home': (_) => HomeScreen()},
    );
  }
}
