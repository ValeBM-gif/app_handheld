import 'package:flutter/material.dart';

Color kPrimaryColor = const Color(0xff00AFD6);
String svg='assets/almacen3.svg';
Padding HomeIcon(icono){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
    child: Container(child: Icon(icono, color: kPrimaryColor, size: 200,), decoration: BoxDecoration(border: Border.all(color: kPrimaryColor, width: 2), borderRadius: BorderRadius.all(Radius.circular(10),),),),
  );
}

TextStyle greyTextStyle = const TextStyle(
    color: Colors.black38,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    backgroundColor: Colors.transparent);

String svgRackDetalle='assets/estante.svg';