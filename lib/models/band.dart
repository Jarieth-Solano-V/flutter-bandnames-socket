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
  //Recibe un mapa emitido por el back-end String = 'nombre-funcion' y dinamic lo que se trae
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
      //Definimos las propiedades, tambien le realizamos una validacion
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes');
}
