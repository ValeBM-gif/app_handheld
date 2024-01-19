
import 'package:app_handheld/models/seccion.dart';

class Subdivision {
  String id;
  String nombre;
  String parent;
  String codigoBarras;
  List<Seccion> secciones;

  Subdivision({
    required this.id,
    required this.nombre,
    required this.secciones,
    required this.codigoBarras,
    required this.parent,
  });

  factory Subdivision.fromJson(Map<String, dynamic> json) {
    var mapaSecciones = json['Secciones'] as List;
    List<Seccion> listaSecciones = mapaSecciones.map((s) => Seccion.fromJson(s)).toList();
    return Subdivision(
        id: json['Id'],
        nombre: json['Nombre'],
        secciones: listaSecciones,
        codigoBarras: json['CodigoDeBarras'],
        parent: json['Parent']);
  }
}