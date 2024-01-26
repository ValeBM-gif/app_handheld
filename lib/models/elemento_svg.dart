class ElementoDeSVG {
  String id;
  String partPath;
  String? pasilloId;
  String? rackId;
  String tipoElemento;
  bool resaltado;
  //1 = rack principal
  //2 = sub división rack
  //3 = otro elemento

  ElementoDeSVG(
      {required this.id,
        required this.partPath,
        required this.tipoElemento,
         this.rackId,
         this.pasilloId,
        this.resaltado = false,
      });
}
