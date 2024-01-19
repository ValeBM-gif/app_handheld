
import 'package:app_handheld/models/subdivision.dart';

class Rack {
  String id;
  String nombre;
  String codigoBarras;
  List<Subdivision> subidivisiones;

  Rack(
      {required this.id,
        required this.nombre,
        required this.codigoBarras,
        required this.subidivisiones});

  factory Rack.fromJson(Map<String, dynamic> json) {
    var mapaSubdivisiones = json['Subdivisiones'] as List;
    List<Subdivision> listaSubdivisiones = mapaSubdivisiones.map((s) => Subdivision.fromJson(s)).toList();
    return Rack(
        id: json['Id'],
        nombre: json['Nombre'],
        codigoBarras: json['CodigoDeBarras'],
        subidivisiones: listaSubdivisiones);
  }
}

Map<String, dynamic> mapaRacks = {
  'Racks': [
    {
      'Id': 'A',
      'Nombre': 'A',
      'CodigoDeBarras': '111',
      'Subdivisiones': [
        {
          'Id': 'A1',
          'Nombre': 'A1',
          'CodigoDeBarras': '111',
          'Parent': 'A',
          'Secciones': [
            {
              'Id': 'A1.1',
              'Nombre': 'A1.1',
              'CodigoDeBarras': '111',
              'Parent': 'A1',
              'Productos': [
                {
                  //PRODUCTO 1
                  'Id': '1',
                  'Nombre': 'Producto 1',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
            {
              'Id': 'A1.2',
              'Nombre': 'A1.2',
              'CodigoDeBarras': '111',
              'Parent': 'A1',
              'Productos': [
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [3],
                }
              ]
            },
            {
              'Id': 'A1.3',
              'Nombre': 'A1.3',
              'CodigoDeBarras': '111',
              'Parent': 'A1',
              'Productos': [
                {
                  //PRODUCTO 4
                  'Id': '4',
                  'Nombre': 'Producto 4',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila4.png',
                  'Nivel': [1],
                },
                {
                  //PRODUCTO 5
                  'Id': '5',
                  'Nombre': 'Producto 5',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila5.png',
                  'Nivel': [2],
                },
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
              ]
            },
            {
              'Id': 'A1.4',
              'Nombre': 'A1.4',
              'CodigoDeBarras': '111',
              'Parent': 'A1',
              'Productos': [
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
          ]
        },
        {
          'Id': 'A2',
          'Nombre': 'A2',
          'CodigoDeBarras': '111',
          'Parent': 'A',
          'Secciones': [
            {
              'Id': 'A2.1',
              'Nombre': 'A2.1',
              'CodigoDeBarras': '111',
              'Parent': 'A2',
              'Productos': [
                {
                  //PRODUCTO 1
                  'Id': '1',
                  'Nombre': 'Producto 1',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
            {
              'Id': 'A2.2',
              'Nombre': 'A2.2',
              'CodigoDeBarras': '111',
              'Parent': 'A2',
              'Productos': [
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [3],
                }
              ]
            },
            {
              'Id': 'A2.3',
              'Nombre': 'A2.3',
              'CodigoDeBarras': '111',
              'Parent': 'A2',
              'Productos': [
                {
                  //PRODUCTO 4
                  'Id': '4',
                  'Nombre': 'Producto 4',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila4.png',
                  'Nivel': [1],
                },
                {
                  //PRODUCTO 5
                  'Id': '5',
                  'Nombre': 'Producto 5',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila5.png',
                  'Nivel': [2],
                },
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
              ]
            },
            {
              'Id': 'A2.4',
              'Nombre': 'A2.4',
              'CodigoDeBarras': '111',
              'Parent': 'A2',
              'Productos': [
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
          ]
        },
      ]
    },
    {
      'Id': 'B',
      'Nombre': 'B',
      'CodigoDeBarras': '111',
      'Subdivisiones': [
        {
          'Id': 'B1',
          'Nombre': 'B1',
          'CodigoDeBarras': '111',
          'Parent': 'B',
          'Secciones': [
            {
              'Id': 'B1.1',
              'Nombre': 'B1.1',
              'CodigoDeBarras': '111',
              'Parent': 'B1',
              'Productos': [
                {
                  //PRODUCTO 1
                  'Id': '1',
                  'Nombre': 'Producto 1',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
            {
              'Id': 'B1.2',
              'Nombre': 'B1.2',
              'CodigoDeBarras': '111',
              'Parent': 'B1',
              'Productos': [
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [3],
                }
              ]
            },
            {
              'Id': 'B1.3',
              'Nombre': 'B1.3',
              'CodigoDeBarras': '111',
              'Parent': 'B1',
              'Productos': [
                {
                  //PRODUCTO 4
                  'Id': '4',
                  'Nombre': 'Producto 4',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila4.png',
                  'Nivel': [1],
                },
                {
                  //PRODUCTO 5
                  'Id': '5',
                  'Nombre': 'Producto 5',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila5.png',
                  'Nivel': [2],
                },
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
              ]
            },
            {
              'Id': 'B1.4',
              'Nombre': 'B1.4',
              'CodigoDeBarras': '111',
              'Parent': 'B1',
              'Productos': [
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
          ]
        },
        {
          'Id': 'B2',
          'Nombre': 'B2',
          'CodigoDeBarras': '111',
          'Parent': 'B',
          'Secciones': [
            {
              'Id': 'B2.1',
              'Nombre': 'B2.1',
              'CodigoDeBarras': '111',
              'Parent': 'B2',
              'Productos': [
                {
                  //PRODUCTO 1
                  'Id': '1',
                  'Nombre': 'Producto 1',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
            {
              'Id': 'B2.2',
              'Nombre': 'B2.2',
              'CodigoDeBarras': '111',
              'Parent': 'B2',
              'Productos': [
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [3],
                }
              ]
            },
            {
              'Id': 'B2.3',
              'Nombre': 'B2.3',
              'CodigoDeBarras': '111',
              'Parent': 'B2',
              'Productos': [
                {
                  //PRODUCTO 4
                  'Id': '4',
                  'Nombre': 'Producto 4',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila4.png',
                  'Nivel': [1],
                },
                {
                  //PRODUCTO 5
                  'Id': '5',
                  'Nombre': 'Producto 5',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila5.png',
                  'Nivel': [2],
                },
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
              ]
            },
            {
              'Id': 'B2.4',
              'Nombre': 'B2.4',
              'CodigoDeBarras': '111',
              'Parent': 'B2',
              'Productos': [
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
          ]
        },
      ]
    },
    {
      'Id': 'C',
      'Nombre': 'C',
      'CodigoDeBarras': '111',
      'Subdivisiones': [
        {
          'Id': 'C1',
          'Nombre': 'C1',
          'CodigoDeBarras': '111',
          'Parent': 'C',
          'Secciones': [
            {
              'Id': 'C1.1',
              'Nombre': 'C1.1',
              'CodigoDeBarras': '111',
              'Parent': 'C1',
              'Productos': [
                {
                  //PRODUCTO 1
                  'Id': '1',
                  'Nombre': 'Producto 1',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
            {
              'Id': 'C1.2',
              'Nombre': 'C1.2',
              'CodigoDeBarras': '111',
              'Parent': 'C1',
              'Productos': [
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [3],
                }
              ]
            },
            {
              'Id': 'C1.3',
              'Nombre': 'C1.3',
              'CodigoDeBarras': '111',
              'Parent': 'C1',
              'Productos': [
                {
                  //PRODUCTO 4
                  'Id': '4',
                  'Nombre': 'Producto 4',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila4.png',
                  'Nivel': [1],
                },
                {
                  //PRODUCTO 5
                  'Id': '5',
                  'Nombre': 'Producto 5',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila5.png',
                  'Nivel': [2],
                },
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
              ]
            },
            {
              'Id': 'C1.4',
              'Nombre': 'C1.4',
              'CodigoDeBarras': '111',
              'Parent': 'C1',
              'Productos': [
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
          ]
        },
        {
          'Id': 'C2',
          'Nombre': 'C2',
          'CodigoDeBarras': '111',
          'Parent': 'C',
          'Secciones': [
            {
              'Id': 'C2.1',
              'Nombre': 'C2.1',
              'CodigoDeBarras': '111',
              'Parent': 'C2',
              'Productos': [
                {
                  //PRODUCTO 1
                  'Id': '1',
                  'Nombre': 'Producto 1',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
            {
              'Id': 'C2.2',
              'Nombre': 'C2.2',
              'CodigoDeBarras': '111',
              'Parent': 'C2',
              'Productos': [
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [3],
                }
              ]
            },
            {
              'Id': 'C2.3',
              'Nombre': 'C2.3',
              'CodigoDeBarras': '111',
              'Parent': 'C2',
              'Productos': [
                {
                  //PRODUCTO 4
                  'Id': '4',
                  'Nombre': 'Producto 4',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila4.png',
                  'Nivel': [1],
                },
                {
                  //PRODUCTO 5
                  'Id': '5',
                  'Nombre': 'Producto 5',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila5.png',
                  'Nivel': [2],
                },
                {
                  //PRODUCTO 2
                  'Id': '2',
                  'Nombre': 'Producto 2',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila2.png',
                  'Nivel': [1, 2],
                },
              ]
            },
            {
              'Id': 'C2.4',
              'Nombre': 'C2.4',
              'CodigoDeBarras': '111',
              'Parent': 'C2',
              'Productos': [
                {
                  //PRODUCTO 3
                  'Id': '3',
                  'Nombre': 'Producto 3',
                  'CodigoDeBarras': '111',
                  'ImgPath': 'assets/pila3.png',
                  'Nivel': [1, 2, 3],
                }
              ]
            },
          ]
        },
      ]
    },
  ]
};