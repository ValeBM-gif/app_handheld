class Locacion {
  String id;
  String locacion;
  String claveCifrada;

  Locacion(
      {required this.id, required this.locacion, required this.claveCifrada});

  factory Locacion.fromJson(Map<String, dynamic> json) {
    print("JSON de locacion: $json");
    return Locacion(
        id: json['Id'],
        locacion: json['Locacion'],
        claveCifrada: json['claveCifrada']);
  }
}

Map<String, dynamic> clavesUbicaciones = {
  'Productos': [
    {
      //Ubicacion 1
      'Id': '1',
      'Locacion': 'AB-03-02',
      'claveCifrada': '35'
    },
    {
      //Ubicacion 2
      'Id': '2',
      'Locacion': 'AB-02-03',
      'claveCifrada': '80'
    },
  ]
};
//35= 1c383cd30b7c298ab50293adfecb7b18
//80= f033ab37c30201f73f142449d037028d
