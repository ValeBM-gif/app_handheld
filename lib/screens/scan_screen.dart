import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../constants.dart';
import '../main.dart';
import '../models/locacion.dart';
import '../models/producto.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  TextEditingController codigoCifradoController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  FocusNode ubicacionFocusNode = FocusNode();
  FocusNode _focusNode = FocusNode();
  String claveCifrada = "Hola"; // Valor original hardcodeado
  bool verificacionExitosa = true;
  String valorVisible = "";
  List<String> nombresSucursales =
      sucursales.map((sucursal) => sucursal.nombre).toList();
  String selectedLocation = '';
  String selectedProduct = '';

  String result = '';
  Producto? foundProduct;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ubicacionFocusNode.requestFocus();
      // Abre el teclado automáticamente
      FocusScope.of(context).requestFocus(ubicacionFocusNode);
    });
    _controller.addListener(() {
      print("Lo que tiene el input es: ${_controller.text}");
    });

    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    ubicacionFocusNode.dispose();
    _controller.dispose();
    super.dispose();
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
        nivel: 1,
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
                    child: Column(
                      children: [
                        DropdownButton<String>(
                          value: selectedLocation.isNotEmpty
                              ? selectedLocation
                              : nombresSucursales.first,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLocation = newValue!;
                            });
                          },
                          items: nombresSucursales
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text('Selecciona una ubicación'),
                        ),
                        TextField(
                          controller: codigoCifradoController,
                          focusNode: ubicacionFocusNode,
                          onChanged: (value) {
                            verificarCifradoAES(value);
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Código de Ubicación",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.cleaning_services),
                              onPressed: () {
                                setState(() {
                                  codigoCifradoController.clear();
                                  _controller.clear();
                                  verificacionExitosa = true;
                                  valorVisible = "";
                                });
                                _focusNode.requestFocus();
                              },
                            ),
                          ),
                        ),
                        if (!verificacionExitosa)
                          Text(
                            "Ubicacion Correcta",
                            style:
                                TextStyle(color: Colors.green, fontSize: 16.0),
                          ),
                      ],
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
                      enabled: !verificacionExitosa,
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

  void verificarCifradoAES(String valorCifrado) {
    // Clave utilizada para el cifrado AES
    String claveAES = "y80Ib8dG48SsHqU6";

    // Decodificar la cadena Base64
    String cleanedBase64 = valorCifrado.trim();
    cleanedBase64 =
        cleanedBase64.replaceAll(' ', '+'); // Reemplazar espacios con '+'

    try {
      // Decodificar la cadena Base64
      Uint8List encryptedBytes = base64.decode(cleanedBase64);

      final key = encrypt.Key.fromUtf8(claveAES);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));

      // Desencriptar usando AES
      String resultadoDesencriptado;

      resultadoDesencriptado =
          encrypter.decrypt64(cleanedBase64, iv: encrypt.IV.fromUtf8(''));

      print('Resultado: $resultadoDesencriptado');

      // Comparar con el valor original
      if (resultadoDesencriptado == claveCifrada) {
        setState(() {
          verificacionExitosa = false;
          ubicacionFocusNode.unfocus();
          Future.delayed(Duration(milliseconds: 100), () {
            // Espera 100 milisegundos antes de solicitar el foco en el segundo TextField
            _focusNode.requestFocus();
          });
          codigoCifradoController.text = resultadoDesencriptado;
        });
      } else {
        setState(() {
          verificacionExitosa = true;
        });
        mostrarMensaje("Ubicacion Incorrecta");
      }
    } catch (e) {
      print('Ubicacion Incorrecta: $e');
      mostrarMensaje("Ubicacion Incorrecta");
    }
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
