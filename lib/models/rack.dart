import 'bahia.dart';

class Rack {
  String id;
  String codigoBarras;
  List<Bahia> bahias;
  int niveles;

  Rack({required this.id, required this.codigoBarras, required this.bahias, required this.niveles});

  factory Rack.fromJson(Map<String, dynamic> json) {
    var mapaBahias = json['Bahias'] as List;
    List<Bahia> listaBahias = mapaBahias.map((b) => Bahia.fromJson(b)).toList();
    return Rack(
        id: json['Id'],
        codigoBarras: json['CodigoDeBarras'],
        niveles: json['Niveles'],
        bahias: listaBahias,
    );
  }
}

Map<String, dynamic> mapaRacks = {
  'Racks': [
    {
      'Id': 'Rack-A',
      'Niveles': 4,
      'CodigoDeBarras': '111',
      'Bahias': [
        {
          'Id': 'A-01',
          'CodigoDeBarras': '111',
          'Pasillo': 'A',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'A-02',
          'CodigoDeBarras': '111',
          'Pasillo': 'A',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'A-03',
          'CodigoDeBarras': '111',
          'Pasillo': 'A',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'A-04',
          'CodigoDeBarras': '111',
          'Pasillo': 'A',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'A-05',
          'CodigoDeBarras': '111',
          'Pasillo': 'A',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'AB-01',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'AB-03',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'AB-05',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'AB-07',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-A',
        },
        {
          'Id': 'AB-09',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-A',
        },
      ]
    },
    {
      'Id': 'Rack-B',
      'Niveles': 4,
      'CodigoDeBarras': '111',
      'Bahias': [
        {
          'Id': 'AB-02',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'AB-04',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'AB-06',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'AB-08',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'AB-10',
          'CodigoDeBarras': '111',
          'Pasillo': 'AB',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'BC-01',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'BC-03',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'BC-05',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'BC-07',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-B',
        },
        {
          'Id': 'BC-09',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-B',
        },
      ]
    },
    {
      'Id': 'Rack-C',
      'Niveles': 4,
      'CodigoDeBarras': '111',
      'Bahias': [
        {
          'Id': 'BC-02',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'BC-04',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'BC-06',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'BC-08',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'BC-10',
          'CodigoDeBarras': '111',
          'Pasillo': 'BC',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'C-01',
          'CodigoDeBarras': '111',
          'Pasillo': 'C',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'C-02',
          'CodigoDeBarras': '111',
          'Pasillo': 'C',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'C-03',
          'CodigoDeBarras': '111',
          'Pasillo': 'C',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'C-04',
          'CodigoDeBarras': '111',
          'Pasillo': 'C',
          'Rack': 'Rack-C',
        },
        {
          'Id': 'C-05',
          'CodigoDeBarras': '111',
          'Pasillo': 'C',
          'Rack': 'Rack-C',
        },
      ]
    },
  ]
};
