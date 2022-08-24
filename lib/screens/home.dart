import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../models/band.dart';
import '../services/socket_service.dart';

//Snippets "fl-page" para crear esta estructura
// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Lista de bandas, esto se sacara de la base datos
  List<Band> bands = [
    //Band(id: '1', name: 'Metallica', votes: 13),
    //Band(id: '2', name: 'Iron Maiden', votes: 9),
    //Band(id: '3', name: 'Guns and Roses', votes: 11),
    //Band(id: '4', name: 'Queen', votes: 15),
    //Band(id: '5', name: 'Megadeth', votes: 10),
  ];

  //Escuchamos la data
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBand);

    super.initState();
  }

  //
  _handleActiveBand(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();

    setState(() {});
  }

  //Hacemos la limpieza
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Nombre de las Bandas',
          style: TextStyle(color: Colors.black87),
        )),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            /*Establcemos un ternario para esocger el icono segun su estado 
            "Online" o "Offline", si el estado es online: */
            child: (socketService.serverStatus == ServerStatus.Online)
                //Entonces retornar este icono:
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                //Si no, retornar este icono:
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          //Este expanded va tomar todo el espacio disponible para mostrar la columna
          Expanded(
            child: ListView.builder(
              //El contador de las bandas, establece de que tamano va ser la lista cotando cada banda
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i]),
              //Separamos la lista de bandas, recibimos por parametos el index = i
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  ///Modulado de lista de bandas
  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    //Gesto para eliminar una banda de la lista
    return Dismissible(
      //Definimos un id unico mediante el key.
      key: Key(band.id),
      //Direccion desde donde se puede empezar a deslizar
      direction: DismissDirection.startToEnd,
      //Al deslizar
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      //Parte de atras al deslizar
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
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
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
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
          builder: (_) => CupertinoAlertDialog(
                title: const Text('Agregar nueva banda:'),
                content: CupertinoTextField(
                  controller: textContoller,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('Agregar'),
                    onPressed: () => addBandToList(textContoller.text),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }

    //Android
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Agregar nueva banda: '),
              content: TextField(
                controller: textContoller,
              ),
              actions: <Widget>[
                MaterialButton(
                  child: const Text('Agregar'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textContoller.text),
                ),
                MaterialButton(
                  child: const Text('Cancelar'),
                  elevation: 5,
                  textColor: Colors.red,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }

  ///Funcion para agregar una nueva banda a la lista
  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    //Mientras el textController sea mayor a un caracter, crear una nueva banda.
    if (name.length > 1) {
      //Funcion add
      socketService.socket.emit('add-band', {'name': name});
    }
    //Retroceder.
    Navigator.pop(context);
  }

  //Mostrar graficas
  Widget _showGraph() {
    Map<String, double> dataMap = {};

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    /*bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });*/

    final List<Color> colorList = [
      Colors.blue.shade50,
      Colors.blue.shade200,
      Colors.pink.shade50,
      Colors.pink.shade200,
      Colors.yellow.shade50,
      Colors.yellow.shade200
    ];
    //import PieChart
    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "HYBRID",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );
    /*return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "HYBRID",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );*/
  }
}
