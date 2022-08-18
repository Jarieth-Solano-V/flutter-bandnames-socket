import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

//Snippets "fl-page" para crear esta estructura
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Lista de bandas, esto se sacara de la base datos
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 13),
    Band(id: '2', name: 'Iron Maiden', votes: 9),
    Band(id: '3', name: 'Guns and Roses', votes: 11),
    Band(id: '4', name: 'Queen', votes: 15),
    Band(id: '5', name: 'Megadeth', votes: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nombre de las Bandas',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        //El contador de las bandas, establece de que tamano va ser la lista
        itemCount: bands.length,
        itemBuilder: (BuildContext context, i) => _bandTile(bands[i]),
        //Separamos la lista de bandas, recibimos por parametos el index = i
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  ///Modulado de lista de bandas
  Widget _bandTile(Band band) {
    //Gesto para eliminar una banda de la lista
    return Dismissible(
      //Definimos un id unico mediante el key.
      key: Key(band.id),
      //Direccion desde donde se puede empezar a deslizar
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('direction: $direction');
      },
      //Parte de atras al deslizar
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Eliminar banda',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        //Circulo como avatar
        leading: CircleAvatar(
          //El substring extraer las letras que deseamos
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        //Agregamos el nombre de la banda
        title: Text(band.name),
        //Agregamos los votos de la banda
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  ///Muestra el mensaje de dialogo para agregar una nueva banda
  addNewBand() {
    //Definimos un nuevo controlador de texto.
    final textContoller = TextEditingController();

    //Si NO es una plataforma "Android" que muestre el mensaje de esta forma.
    if (!Platform.isAndroid) {
      showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Agregar nueva banda:'),
            content: CupertinoTextField(
              controller: textContoller,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Agregar'),
                onPressed: () => addBandToList(textContoller.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
    }

    //Android
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar nueva banda: '),
          content: TextField(
            controller: textContoller,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Agregar'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textContoller.text),
            ),
            MaterialButton(
              child: Text('Cancelar'),
              elevation: 5,
              textColor: Colors.red,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  ///Funcion para agregar una nueva banda a la lista
  void addBandToList(String name) {
    print(name);
    //Mientras el textController sea mayor a un caracter, crear una nueva banda.
    if (name.length > 1) {
      //Funcion add
      bands.add(
        Band(
          id: DateTime.now().toString(),
          //Nombre = textController
          name: name,
          votes: 0,
        ),
      );
      setState(() {});
    }
    //Retroceder.
    Navigator.pop(context);
  }
}
