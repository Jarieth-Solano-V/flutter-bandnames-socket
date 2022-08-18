class Band {
  //Creamos las propiedades
  String id;
  String name;
  int votes;

  //Creamos el constructor
  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  //En backend va responder un mapa, debido aque se va trabajar con sockets

  /*Creamos un factory constructor, este factory recibe ciertos tipos de argumentos y
  regresa una nueva instancia de la clase, podemos utilizar "=>" para simular un return*/
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        //Definimos la propiedades
        id: obj['id'],
        name: obj['name'],
        votes: obj['votes'],
      );
}
