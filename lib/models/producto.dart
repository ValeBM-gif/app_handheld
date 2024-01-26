class Producto {
  String id;
  String nombre;
  String pathFoto;
  int nivel;
  String? idSeccion;
  String? codigoBarras;
  int? cantidadStock;
  String? locacion;

  Producto(
      {required this.id,
      required this.nombre,
      required this.pathFoto,
      required this.nivel,
      required this.idSeccion,
      required this.codigoBarras,
      required this.cantidadStock,
      required this.locacion});

  factory Producto.fromJson(Map<String, dynamic> json, idDeSecciones) {
    print("JSON recibido: $json");
    return Producto(
        id: json['Id'],
        nombre: json['Nombre'],
        cantidadStock: json['cantidadStock'],
        pathFoto: json['ImgPath'],
        nivel: json['Nivel']??1,
        idSeccion: idDeSecciones,
        codigoBarras: json['CodigoDeBarras'],
        locacion: json['Locacion']);
  }
}

List<Producto> getProdcutosFromJson(json) {
  var mapProductos = json['Productos'] as List;
  return mapProductos.map((p) => Producto.fromJson(p, null)).toList();
}

Map<String, dynamic> mapaProductosBase = {
  'Productos': [
    {
      //PRODUCTO 1
      'Id': '1',
      'Nombre': 'Body Mist by Ariana Grande',
      'cantidadStock': 20,
      'CodigoDeBarras': '812256024194',
      'Locacion': '03-BE-03',
      'ImgPath':
          'https://culturaskin.com/cdn/shop/products/2598496_1200x1200.png?v=1670101288',
    },
    {
      //PRODUCTO 2
      'Id': '2',
      'Nombre': 'Nito',
      'cantidadStock': 10,
      'CodigoDeBarras': '7501030409854',
      'Locacion': '03-AB-03',
      'ImgPath':
          'https://farmaciacalderon.com/cdn/shop/products/7501000112784_1200x1200.png?v=1605546431',
    },
    {
      //PRODUCTO 3
      'Id': '3',
      'Nombre': 'Producto 3',
      'cantidadStock': 20,
      'CodigoDeBarras': '1112',
      'Locacion': '03-BE-03',
      'ImgPath':
          'https://culturaskin.com/cdn/shop/products/2598496_1200x1200.png?v=1670101288',
    },
    {
      //PRODUCTO 4
      'Id': '4',
      'Nombre': 'Producto 4',
      'cantidadStock': 20,
      'CodigoDeBarras': '1113',
      'Locacion': '03-BE-03',
      'ImgPath':
          'https://culturaskin.com/cdn/shop/products/2598496_1200x1200.png?v=1670101288',
    },
    {
      //PRODUCTO 5
      'Id': '5',
      'Nombre': 'Producto 5',
      'cantidadStock': 20,
      'CodigoDeBarras': '1114',
      'Locacion': '03-BE-03',
      'ImgPath':
          'https://culturaskin.com/cdn/shop/products/2598496_1200x1200.png?v=1670101288',
    },
  ]
};
