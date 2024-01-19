class Producto {
  String id;
  String nombre;
  String pathFoto;
  List<int>? niveles;
  String? idSeccion;
  String codigoBarras;

  Producto({
    required this.id,
    required this.nombre,
    required this.pathFoto,
    required this.niveles,
    required this.idSeccion,
    required this.codigoBarras,
  });

  factory Producto.fromJson(Map<String, dynamic> json, idDeSecciones) {
    return Producto(
        id: json['Id'],
        nombre: json['Nombre'],
        pathFoto: json['ImgPath'],
        niveles: json['Nivel'],
        idSeccion: idDeSecciones,
        codigoBarras: json['CodigoDeBarras']);
  }

}


Map<String, dynamic> mapaProductosBase = {
  'Productos':[
    {
      //PRODUCTO 1
      'Id': '1',
      'Nombre': 'Producto 1',
      'CodigoDeBarras': '111',
      'ImgPath': 'assets/pila.png',
    },
    {
      //PRODUCTO 2
      'Id': '2',
      'Nombre': 'Producto 2',
      'CodigoDeBarras': '111',
      'ImgPath': 'assets/pila2.png',
    },
    {
      //PRODUCTO 3
      'Id': '3',
      'Nombre': 'Producto 3',
      'CodigoDeBarras': '111',
      'ImgPath': 'assets/pila3.png',
    },
    {
      //PRODUCTO 4
      'Id': '4',
      'Nombre': 'Producto 4',
      'CodigoDeBarras': '111',
      'ImgPath': 'assets/pila4.png',
    },
    {
      //PRODUCTO 5
      'Id': '5',
      'Nombre': 'Producto 5',
      'CodigoDeBarras': '111',
      'ImgPath': 'assets/pila5.png',
    },
  ]
};
