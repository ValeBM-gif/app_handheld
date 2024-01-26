import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xff00AFD6);
const Color kPrimaryColorNoTransparent = Color(0xff45BBFF);
const Color kYellow = Color(0xffE0B263);
const Color kGreen = Color(0xffA5CFB7);
const Color kPrimaryColorDark = Color(0xbf0054D1);
const Color kSecondaryColor = Color(0xffEB746A);
const Color kSecondaryColorDark = Color(0xffAB554D);
String svg='assets/almacen4.svg';
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