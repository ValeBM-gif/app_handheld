import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/locacion.dart';
import '../models/producto.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  String result = '';
  Producto? foundProduct;
  bool verificacionExitosa = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print("Lo que tiene el input es: ${_controller.text}");
    });

    _focusNode.requestFocus();
  }

  void searchProduct() {
    String inputCode = _controller.text;

    List<Producto> productos = mapaProductosBase['Productos']
        .map<Producto>((json) => Producto.fromJson(json, 'seccion'))
        .toList();

    foundProduct = productos.firstWhere(
      (product) => product.codigoBarras == inputCode,
      orElse: () => Producto(
        id: '',
        cantidadStock: 0,
        nombre: '',
        pathFoto: '',
        idSeccion: '',
        codigoBarras: '',
        locacion: '',
      ),
    );

    if (foundProduct!.id.isNotEmpty) {
      setState(() {
        result =
            'ID: ${foundProduct!.id}, Stock: ${foundProduct!.cantidadStock}, Nombre: ${foundProduct!.nombre}, Url de imagen: ${foundProduct!.pathFoto}, Locacion: ${foundProduct!.locacion}';
        _controller.clear();
      });
    } else {
      setState(() {
        result = 'Producto no encontrado';
      });
    }
  }

  void onTextChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        result = '';
      });
    } else {
      searchProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const SizedBox(
            width: 60,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Scan Product',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      //controller: _controller,
                      focusNode: _focusNode,
                      onChanged: onTextChanged,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Codigo de ubicacion',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: onTextChanged,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Codigo',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchProduct();
                      _controller.clear();
                    },
                    color: kPrimaryColor,
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (result.isNotEmpty)
                if (foundProduct!.id.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        foundProduct!.pathFoto,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${foundProduct!.id}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Stock: ${foundProduct!.cantidadStock}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Nombre: ${foundProduct!.nombre}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Locación: ${foundProduct!.locacion}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              if (result.isNotEmpty && foundProduct!.id.isEmpty)
                Text(
                  'Producto no encontrado',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
