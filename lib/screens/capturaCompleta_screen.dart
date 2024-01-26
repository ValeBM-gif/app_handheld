import 'package:flutter/material.dart';

class CapturaCompletaScreen extends StatefulWidget {
  @override
  _CapturaCompletaScreenState createState() => _CapturaCompletaScreenState();
}

class _CapturaCompletaScreenState extends State<CapturaCompletaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completa'),
      ),
      body: Container(
        child: Text('Contenido aquí'),
      ),
    );
  }
}
