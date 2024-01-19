import 'package:flutter/material.dart';

class Product {
  final String id;
  final int stock;
  final String name;
  final String imageUrl;

  Product({
    required this.id,
    required this.stock,
    required this.name,
    required this.imageUrl,
  });
}

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<Product> products = [
    Product(
      id: '812256024194',
      stock: 20,
      name: 'Body Mist',
      imageUrl:
          'https://culturaskin.com/cdn/shop/products/2598496_1200x1200.png?v=1670101288',
    ),
    Product(
      id: '7501161502028',
      stock: 35,
      name: 'Leche León ',
      imageUrl: 'https://lecheleon.com/img/pm2a.png',
    ),
    Product(
      id: '7501008038208',
      stock: 100,
      name: 'Rice Krispies',
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0566/4391/1854/products/7501008006450_a88581df-5e23-4ed8-a642-d818be73e6b5.png?v=1646619118',
    ),
    Product(
      id: 'OS6348US',
      stock: 1,
      name: 'Handheld',
      imageUrl:
          'https://m.media-amazon.com/images/I/71y5mIfRfPL._AC_SL1500_.jpg',
    ),
    // Agrega más productos según sea necesario
  ];

  String result = '';
  Product? foundProduct;

  @override
  void initState() {
    super.initState();
    // Para imprimir lo que tiene el input en la consola
    _controller.addListener(() {
      print("Lo que tiene el input es: ${_controller.text}");
    });

    // Hacer que el cursor ya este listo
    _focusNode.requestFocus();
  }

  void searchProduct() {
    String inputCode = _controller.text;

    foundProduct = products.firstWhere(
      (product) => product.id == inputCode,
      orElse: () => Product(id: '', stock: 0, name: '', imageUrl: ''),
    );

    if (foundProduct!.id.isNotEmpty) {
      setState(() {
        result =
            'ID: ${foundProduct!.id}, Stock: ${foundProduct!.stock}, Nombre: ${foundProduct!.name}, Url de imagen: ${foundProduct!.imageUrl}';
        // Limpiar el input
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
        backgroundColor: Colors.blue,
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
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: onTextChanged,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Codigo',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
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
                    color: Colors.blue,
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
                        foundProduct!.imageUrl,
                        width: 100, // Ajusta el tamaño según sea necesario
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
                              'Stock: ${foundProduct!.stock}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Nombre: ${foundProduct!.name}',
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
