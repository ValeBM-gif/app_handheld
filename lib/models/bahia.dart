
import 'package:app_handheld/models/producto.dart';

class Bahia {
  String id;
  String pasilloId;
  String rackId;
  String codigoBarras;
  List<Producto>? productos;

  Bahia({
    required this.id,
    required this.pasilloId,
    required this.codigoBarras,
    required this.rackId,
    this.productos,
  });

  factory Bahia.fromJson(Map<String, dynamic> json) {
    return Bahia(
        id: json['Id'],
        pasilloId: json['Pasillo'],
        rackId: json['Rack'],
        codigoBarras: json['CodigoDeBarras'],
    );
  }
}