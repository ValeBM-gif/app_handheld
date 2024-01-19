
import 'package:app_handheld/models/producto.dart';

class Seccion {
  String id;
  String nombre;
  String parent;
  String codigoBarras;
  List<Producto>? productos;

  Seccion({
    required this.id,
    required this.nombre,
    required this.parent,
    required this.codigoBarras,
    this.productos,
  });

  factory Seccion.fromJson(Map<String, dynamic> json) {
    var mapaProductos = json['Productos'] as List;
    List<Producto> listaProductos = mapaProductos.map((e) => Producto.fromJson(e, json['Id'])).toList();
    return Seccion(
        id: json['Id'],
        nombre: json['Nombre'],
        parent: json['Parent'],
        codigoBarras: json['CodigoDeBarras'],
        productos: listaProductos
    );
  }
}