import 'package:app_handheld/main.dart';
import 'package:app_handheld/screens/detalle_screen.dart';
import 'package:app_handheld/screens/mapa_almacen_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/producto.dart';
import '../models/sucursal.dart';

class ProductosScreen extends StatefulWidget {
  final Sucursal sucursal;
  final bool tieneLayout;
  ProductosScreen({
    super.key,
    required this.sucursal, required this.tieneLayout,
  });

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
        actions: [
          false?Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MapaAlmacenScreen();
                  }),
                );
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ):const SizedBox(),
        ],
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Productos Disponibles',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: screenSize.height * .8,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: productosGlobal.length,
                itemBuilder: (context, index) {
                  Producto producto = productosGlobal[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return DetalleProductoScreen(producto: producto, mostrarDatosLocacion: widget.tieneLayout,);
                        }),
                      );
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width*.044),
                      child: ListTile(
                        trailing: Text(
                          producto.cantidadStock.toString(),
                          style: greyTextStyle,
                        ),
                        key: UniqueKey(),
                        leading: Image.network(
                          producto.pathFoto,
                          height: screenSize.width*.098,
                          width: screenSize.width*.098,
                        ),
                        title: Text(
                          producto.nombre,
                          style: greyTextStyle,
                        ),
                        subtitle:widget.tieneLayout? Text(producto.locacion!=null?
                          'Locación: ${producto.locacion}-0${producto.nivel}-01':'Locación no asignada',
                          style: greyTextStyle.copyWith(fontSize: 12),
                        ):Text(
                          'Detalles idk',
                          style: greyTextStyle.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      )),
    );
  }
}
