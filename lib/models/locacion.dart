class Locacion {
  String id;
  String locacion;
  String claveCifrada;
  String keySecret;

  Locacion(
      {required this.id,
      required this.locacion,
      required this.keySecret,
      required this.claveCifrada});

  factory Locacion.fromJson(Map<String, dynamic> json) {
    print("JSON de locacion: $json");
    return Locacion(
        id: json['Id'],
        locacion: json['Locacion'],
        keySecret: json['keySecret'],
        claveCifrada: json['claveCifrada']);
  }
}

Map<String, dynamic> clavesUbicaciones = {
  'Productos': [
    {
      //Ubicacion 1
      'Id': '1',
      'Locacion': 'AB-03-02',
      'keySecret': '80',
      'claveCifrada': '80'
    },
  ]
};
// HBV9E8Kwyqss0c/daSSzGc19TDUF2SdoqQ9xWpLi2wt1anFUBNANb8UT7S7O1ifs
