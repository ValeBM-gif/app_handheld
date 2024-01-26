import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Sucursal {
  int id;
  String nombre;
  bool tieneLayout;

  Sucursal({
    required this.id,
    required this.nombre,
    required this.tieneLayout,
  });

  factory Sucursal.fromJson(Map json) {
    return Sucursal(
      id: json['Id'],
      nombre: json['Nombre'],
      tieneLayout: json['EsCedis'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Sucursal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

Future<List<Sucursal>?> getSucursalesFromJson()async{
  final t = await SharedPreferences.getInstance();
  var token = t.getString('token') ?? 'null';
  final headers = {HttpHeaders.authorizationHeader: token};
  var response = await http.get(Uri.parse("$api/Sucursal/Sucursales"), headers: headers);

  if(response.statusCode==200){
    print('respuesta sucursales ${response.body}');
    List<Sucursal> sucursales = (jsonDecode(response.body) as List<dynamic>)
        .map((sucursal) =>
        Sucursal(id: sucursal['Id'], nombre: sucursal['Nombre'], tieneLayout: sucursal['EsCedis']),)
        .toList();
    return sucursales;
  }else{
    return null;
  }
}