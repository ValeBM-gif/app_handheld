class ElementoDeSVG {
  String id;
  String partPath;
  String nombre;
  String? parent;
  String tipoElemento;
  //1 = rack principal
  //2 = sub división rack
  //3 = otro elemento

  ElementoDeSVG(
      {required this.id,
        required this.partPath,
        required this.tipoElemento,
        required this.nombre,
        this.parent,
      });
}
