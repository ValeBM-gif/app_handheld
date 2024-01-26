import 'package:app_handheld/screens/seleccionar_locacion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:xml/xml.dart';

import '../constants.dart';
import '../main.dart';
import '../models/clipper.dart';
import '../models/elemento_svg.dart';
import '../models/producto.dart';
import '../models/rack.dart';

class DetalleProductoScreen extends StatefulWidget {
  final Producto producto;
  final bool mostrarDatosLocacion;
  DetalleProductoScreen({super.key, required this.producto, required this.mostrarDatosLocacion});

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  List<String> locacionesBahiasExistentes = [];
  List<ElementoDeSVG>? elementosDeSVGDetalle = [];

  bool mostrarListaLocaciones = false;
  bool mostrarEditorDeLocacion = false;
  bool mapaCargado = false;
  bool tecladoEsVisible=false;

  int nivel = 1;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    locacionesBahiasExistentes = getLocacionesFromRacks(racks);
    nivel = widget.producto.nivel;
    super.initState();
  }

  List<String> getLocacionesFromRacks(List<Rack> allRacks) {
    List<String> locs = [];
    for (var r in allRacks) {
      for (var b in r.bahias) {
        locs.add(b.id);
      }
    }
    return locs;
  }

  List<String> getCoincidencias(allLocations) {
    List<String> locacionesFiltradas = [];
    String inputText = textEditingController.text;
    for (var l in allLocations) {
      if (l.toLowerCase().contains(
            inputText.toLowerCase(),
          )) {
        locacionesFiltradas.add(l);
      }
    }
    return locacionesFiltradas;
  }

  @override
  Widget build(BuildContext context) {
    print('? ${widget.producto.locacion}');
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            //productosGlobal.firstWhere((p) => p.id==widget.producto.id).locacion=loc;
            productosGlobal.firstWhere((p) => p.id==widget.producto.id).nivel=nivel;
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
        title: Text(
          widget.producto.nombre,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: KeyboardVisibility(
        onChanged: (visible){
          tecladoEsVisible=visible;
          setState(() {});
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [!tecladoEsVisible?
              Image.network(
                widget.producto.pathFoto,
                height: 150,
                width: 150,
              ):const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Detalles: shalalala shalalala',
                  style: greyTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Cantidad: 32',
                  style: greyTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenSize.width * .3,
                    right: screenSize.width * .3,
                    top: 8,
                    bottom: 8),
                child: widget.mostrarDatosLocacion?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Nivel: ',
                      style: greyTextStyle,
                    ),
                    NumberPicker(
                      selectedTextStyle: greyTextStyle.copyWith(
                          color: kPrimaryColor, fontSize: 22),
                      textStyle: greyTextStyle,
                      itemHeight: 25,
                      itemWidth: 25,
                      zeroPad: true,
                      axis: Axis.horizontal,
                      value: nivel,
                      minValue: 1,
                      maxValue: 4,
                      onChanged: (value) {
                        nivel = value;
                        widget.producto.nivel=nivel;
                        setState(() {});
                      },
                    ),
                  ],
                ):const SizedBox(),
              ),
              widget.mostrarDatosLocacion?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Locación: ${widget.producto.locacion}',
                      style: greyTextStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      mostrarEditorDeLocacion = !mostrarEditorDeLocacion;
                      setState(() {});
                    },
                    child: Icon(
                      Icons.edit,
                      color:
                          mostrarEditorDeLocacion ? kPrimaryColor : Colors.grey,
                    ),
                  ),
                ],
              ):const SizedBox(),
              mostrarEditorDeLocacion
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenSize.width * .7,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                suffix: GestureDetector(
                                  onTap: (){
                                    textEditingController.text='';
                                    mostrarListaLocaciones=false;
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.close_sharp,
                                    color: Colors.grey,
                                  ),),
                                floatingLabelStyle:
                                    MaterialStateTextStyle.resolveWith(
                                  (Set<MaterialState> states) {
                                    return greyTextStyle;
                                  },
                                ),
                                contentPadding:
                                    const EdgeInsets.only(left: 9, right: 9),
                                labelText: 'Ingrese una locación',
                                labelStyle:
                                    const TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.grey.shade300.withAlpha(150),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(11),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                //fontWeight: FontWeight.bold,
                              ),
                              controller: textEditingController,
                              onChanged: (val) {
                                textEditingController.text = val;
                                if (val == null || val == '') {
                                  mostrarListaLocaciones = false;
                                } else {
                                    mostrarListaLocaciones = true;

                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 5),
                          child: GestureDetector(
                            onTap: () async {
                              var locacion = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return SeleccionarLocacionScreen(
                                    locacionActual: widget.producto.locacion,
                                  );
                                }),
                              );

                              textEditingController.text = locacion ?? '';
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: kPrimaryColor,
                                    width: 3,
                                    strokeAlign: BorderSide.strokeAlignInside),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Icon(
                                    Icons.map,
                                    color: kPrimaryColor,
                                    size: 20,
                                  ),
                                  // Text(
                                  //   'Ver productos disponibles',
                                  //   style: greyTextStyle.copyWith(
                                  //       color: Colors.white, fontSize: 12),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              mostrarListaLocaciones
                  ? Container(
                      height: 150,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: ListView.builder(
                          itemCount:getCoincidencias(locacionesBahiasExistentes).isNotEmpty
                              ? getCoincidencias(locacionesBahiasExistentes).length
                              : 1,
                          itemBuilder: (context, index) {
                            var coincidencia;
                            if(getCoincidencias(locacionesBahiasExistentes).isNotEmpty){
                              coincidencia = getCoincidencias(
                                  locacionesBahiasExistentes)[index];
                            }
                            return GestureDetector(
                              onTap: () async {
                                if(getCoincidencias(locacionesBahiasExistentes).isNotEmpty){
                                  textEditingController.text = coincidencia;
                                }else{
                                  textEditingController.text = '';
                                }
                                FocusManager.instance.primaryFocus?.unfocus();
                                mostrarListaLocaciones = false;
                                setState(() {});
                              },
                              child: ListTile(
                                key: UniqueKey(),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 28.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0),
                                        child: Text(getCoincidencias(locacionesBahiasExistentes).isNotEmpty?
                                          coincidencia:'Locación no encontrada',
                                          style: greyTextStyle,
                                        ),
                                      ),
                                    ),
                                    Container(color: Colors.grey, height: .5,)
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : const SizedBox(),
              mostrarEditorDeLocacion
                  ? Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          var locacionExiste = false;
                          for (var l in locacionesBahiasExistentes) {
                            if (textEditingController.text == l) {
                              locacionExiste = true;
                            }
                          }
                          if (locacionExiste) {
                            productosGlobal.firstWhere((p) => p.id==widget.producto.id).locacion=textEditingController.text;
                            productosGlobal.firstWhere((p) => p.id==widget.producto.id).nivel=nivel;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Locación guardada:)'),
                              backgroundColor: Colors.green,
                              elevation: 10,
                              duration: Duration(seconds: 3),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Locación no encontrada'),
                              backgroundColor: Colors.red,
                              elevation: 10,
                              duration: Duration(seconds: 3),
                            ));
                          }
                          textEditingController.text = '';
                          setState(() {});
                        },
                        child: Container(
                          width: 85,
                          decoration: BoxDecoration(
                            color: tecladoEsVisible?Colors.transparent:kPrimaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Guardar',
                                style: greyTextStyle.copyWith(
                                    color: Colors.white, fontSize: tecladoEsVisible?0:12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
