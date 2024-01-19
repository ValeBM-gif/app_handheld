class Country{
   String partId;
   String partPath;
   String name;
   String color;
   bool seleccionado;

   Country({
     required this.partId,
     required this.partPath,
     required this.name,
     required this.color,
     this.seleccionado = false,
  });

}