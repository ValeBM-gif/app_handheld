import 'package:app_handheld/main.dart';
import 'package:app_handheld/models/producto.dart';
import 'package:app_handheld/screens/productos_screen.dart';
import 'package:app_handheld/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'login_screen.dart';
import 'mapa_almacen_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdownValue = sucursales.map((e) => e.nombre).first;

  @override
  void initState() {
    super.initState();
    print('Usuario logeado: ${widget.userName}');
    productosGlobal = getProdcutosFromJson(mapaProductosBase);
  }

  void _logout() async {
    final login = await SharedPreferences.getInstance();
    login.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Menú',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 130,
                    child: const Card(
                      elevation: 3.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.0),
                          Icon(Icons.qr_code, size: 40.0),
                          SizedBox(height: 8.0),
                          Text(
                            'Auditoría',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Container(
                              height: screenSize.height * .3,
                              width: screenSize.width * .85,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(screenSize.width * .03),
                                      child: Text('Selecciona la sucursal:', style: greyTextStyle.copyWith(fontSize: 16),),
                                    ),
                                    Container(
                                      width: screenSize.width * .7,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey.shade300.withAlpha(150),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: screenSize.width * .03),
                                          child: DropdownMenu<String>(
                                            initialSelection: sucursales
                                                .map((s) => s.nombre)
                                                .first,
                                            inputDecorationTheme:
                                                const InputDecorationTheme(
                                                    border: InputBorder.none),
                                            onSelected: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                            dropdownMenuEntries: sucursales
                                                .map((s) => s.nombre)
                                                .map<DropdownMenuEntry<String>>(
                                                    (String value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value, label: value);
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(screenSize.width * .03),
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          //todo: servicio para obtener productos dependiendo de la sucursal y almacen
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductosScreen(
                                                sucursal: sucursales.firstWhere(
                                                    (sucursal) =>
                                                        sucursal.nombre ==
                                                        dropdownValue),
                                                tieneLayout: sucursales
                                                    .firstWhere((sucursal) =>
                                                        sucursal.nombre ==
                                                        dropdownValue)
                                                    .tieneLayout,
                                              ),
                                            ),
                                          );
                                          dropdownValue = sucursales
                                              .map((e) => e.nombre)
                                              .first;
                                        },
                                        child: Container(
                                          width: screenSize.width * .25,
                                          decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(13),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: screenSize.width * .03, vertical: screenSize.width * .03),
                                            child: Center(
                                              child: Text(
                                                'Continuar',
                                                style: greyTextStyle.copyWith(
                                                    color: Colors.white, fontSize:16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 130,
                    child: const Card(
                      elevation: 3.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.0),
                          Icon(Icons.format_list_numbered, size: 40.0),
                          SizedBox(height: 8.0),
                          Text(
                            'Consulta existencias',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapaAlmacenScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 130,
                    child: const Card(
                      elevation: 3.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.0),
                          Icon(Icons.search, size: 40.0),
                          SizedBox(height: 8.0),
                          Text(
                            'Búsqueda',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapaAlmacenScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 130,
                    child: const Card(
                      elevation: 3.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.0),
                          Icon(Icons.icecream, size: 40.0),
                          SizedBox(height: 8.0),
                          Text(
                            'Shalala',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
