import 'dart:math';

import 'package:app_handheld/screens/productos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import '../constants.dart';
import '../main.dart';
import '../models/clipper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/elemento_svg.dart';
import '../models/producto.dart';
import '../models/rack.dart';

class MapaAlmacenScreen extends StatefulWidget {
  const MapaAlmacenScreen({Key? key}) : super(key: key);

  @override
  State<MapaAlmacenScreen> createState() => _MapaAlmacenScreenState();
}

class _MapaAlmacenScreenState extends State<MapaAlmacenScreen> {
  int? selectedIndex;

  List<ElementoDeSVG>? elementosDeSVGPrincipal = [];
  List<ElementoDeSVG>? elementosDeSVGDetalle = [];

  ElementoDeSVG? rackResaltado;
  List<ElementoDeSVG> bahiasResaltadas = [];

  ElementoDeSVG? ultimoRackResaltado;
  List<ElementoDeSVG> ultimasBahiasResaltadas = [];

  dynamic objetoSeleccionado;
  Producto? productoABuscar;

  PanelController panelController = PanelController();
  TextEditingController textEditingController = TextEditingController();

  List<Producto> productosRack = [];
  List<Producto> productosAMostrar = [];

  bool mostrarListaCoincidencias = false;
  bool mapaCargado = false;
  bool mostrarDetalleBahia = false;

  String vista = "2";
  //vista 1: rack
  //vista 2: bahía

  @override
  void initState() {
    super.initState();
    productosRack = getAllProductsFromRacks(racks);
    loadSvgImagePrincipal(svgImg: svg);
    loadSvgImageDetalle(svgImg: svgRackDetalle);
    print('tipo de ultim... ${ultimasBahiasResaltadas.runtimeType}');
  }

  List<Producto> getAllProductsFromRacks(List<Rack> allRacks) {
    List<Producto> prods = [];
    List<String> locs = getLocacionesFromRacks(allRacks);
    for (var p in productosGlobal) {
      for (var l in locs) {
        if (p.locacion == l) {
          prods.add(p);
        }
      }
    }
    return prods;
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

  Future<void> loadSvgImagePrincipal({required String svgImg}) async {
    elementosDeSVGPrincipal?.clear();
    elementosDeSVGPrincipal = await getElementSVG(svgImg);
    setState(() {
      mapaCargado = true;
    });
  }

  Future<void> loadSvgImageDetalle({required String svgImg}) async {
    elementosDeSVGDetalle?.clear();
    elementosDeSVGDetalle = await getElementSVG(svgImg);
    setState(() {
      mapaCargado = true;
    });
  }

  Future<List<ElementoDeSVG>> getElementSVG(svgImg) async {
    List<ElementoDeSVG> elementosACargar = [];
    String generalString = await rootBundle.loadString(svgImg);
    XmlDocument doc = XmlDocument.parse(generalString);
    final paths = doc.findAllElements('path');

    print('paths.length ${paths.length}, runtime type: ${paths.runtimeType}');
    for (var path in paths) {
      if (path.getAttribute('tipo').toString() == '5' ||
          path.getAttribute('tipo').toString() == '4') {
        String partId = path.getAttribute('id').toString();
        String partPath = path.getAttribute('d').toString();
        String type = path.getAttribute('tipo').toString();
        elementosACargar.add(
            ElementoDeSVG(id: partId, partPath: partPath, tipoElemento: type));
      }
    }
    for (var path in paths) {
      if (path.getAttribute('tipo').toString() == '3') {
        String partId = path.getAttribute('id').toString();
        String partPath = path.getAttribute('d').toString();
        String type = path.getAttribute('tipo').toString();
        elementosACargar.add(
            ElementoDeSVG(id: partId, partPath: partPath, tipoElemento: type));
      }
    }
    for (var path in paths) {
      if (vista == '2') {
        if (path.getAttribute('tipo').toString() == '2') {
          String partId = path.getAttribute('id').toString();
          String partPath = path.getAttribute('d').toString();
          String type = path.getAttribute('tipo').toString();
          elementosACargar.add(ElementoDeSVG(
              id: partId, partPath: partPath, tipoElemento: type));
        }
      } else {
        if (path.getAttribute('tipo').toString() == '1') {
          String partId = path.getAttribute('id').toString();
          String partPath = path.getAttribute('d').toString();
          String type = path.getAttribute('tipo').toString();
          String rack = path.getAttribute('rack').toString();
          String aisle = path.getAttribute('pasillo').toString();
          elementosACargar.add(ElementoDeSVG(
              id: partId,
              partPath: partPath,
              pasilloId: aisle,
              rackId: rack,
              tipoElemento: type));
        }
      }
    }
    for (var path in paths) {
      if (path.getAttribute('tipo').toString() == '6') {
        String partId = path.getAttribute('id').toString();
        String partPath = path.getAttribute('d').toString();
        String type = path.getAttribute('tipo').toString();
        elementosACargar.add(
          ElementoDeSVG(id: partId, partPath: partPath, tipoElemento: type),
        );
      }
    }

    print('elementosACargar.length ${elementosACargar.length}');
    return elementosACargar;
  }

  Widget _getClippedImage({
    required Clipper clipper,
    required Color color,
    required ElementoDeSVG? element,
    required bool abrirPanel,
    required bool tapEnDetalle,
  }) {
    return ClipPath(
      clipper: clipper,
      child: GestureDetector(
        onTap: () => element != null
            ? onElementSelected(element, abrirPanel, tapEnDetalle, false)
            : () {
                print('element nulo');
              },
        child: Container(
          color: color,
        ),
      ),
    );
  }

  Future<void> onElementSelected(ElementoDeSVG svgElement,
      bool tapEnMapaPrincipal, bool tapEnMapaDetalle, bool seleccionDeCoincidencia) async {
    if(!seleccionDeCoincidencia){
      if (!mostrarDetalleBahia) {
        for (var e in elementosDeSVGPrincipal!) {
          e.resaltado = false;
          objetoSeleccionado = null;
        }
        if (svgElement.tipoElemento == '2') {
          if (rackResaltado == null || svgElement.id != ultimoRackResaltado?.id) {
            objetoSeleccionado =
                racks.firstWhere((rack) => rack.id == svgElement.id);
            elementosDeSVGPrincipal
                ?.firstWhere((element) => element.id == svgElement.id)
                .resaltado = true;
            rackResaltado =
                elementosDeSVGPrincipal?.firstWhere((c) => c.id == svgElement.id);
            ultimoRackResaltado = rackResaltado;
          } else {
            objetoSeleccionado = null;
            elementosDeSVGPrincipal
                ?.firstWhere((element) => element.id == svgElement.id)
                .resaltado = false;
            rackResaltado = null;
          }
        } else if (svgElement.tipoElemento == '1') {
          if (ultimasBahiasResaltadas.length <= 1) {
            if (ultimasBahiasResaltadas.length == 1) {
              if (ultimasBahiasResaltadas[0].id == svgElement.id) {
                objetoSeleccionado = null;
                elementosDeSVGPrincipal
                    ?.firstWhere((element) => element.id == svgElement.id)
                    .resaltado = false;
                bahiasResaltadas.clear();
              } else {
                bahiasResaltadas.clear();
                for (var rack in racks) {
                  for (var bahia in rack.bahias) {
                    if (bahia.id == svgElement.id) {
                      objetoSeleccionado = bahia;
                      elementosDeSVGPrincipal
                          ?.firstWhere((element) => element.id == svgElement.id)
                          .resaltado = true;
                      bahiasResaltadas.add(elementosDeSVGPrincipal!
                          .firstWhere((element) => element.id == svgElement.id));
                      ultimasBahiasResaltadas = bahiasResaltadas;
                    }
                  }
                }
              }
            } else {
              bahiasResaltadas.clear();
              for (var rack in racks) {
                for (var bahia in rack.bahias) {
                  if (bahia.id == svgElement.id) {
                    objetoSeleccionado = bahia;
                    elementosDeSVGPrincipal
                        ?.firstWhere((element) => element.id == svgElement.id)
                        .resaltado = true;
                    bahiasResaltadas.add(elementosDeSVGPrincipal!
                        .firstWhere((element) => element.id == svgElement.id));
                    ultimasBahiasResaltadas = bahiasResaltadas;
                  }
                }
              }
            }
          } else if (ultimasBahiasResaltadas.length > 1) {
            bahiasResaltadas.clear();
            for (var rack in racks) {
              for (var bahia in rack.bahias) {
                if (bahia.id == svgElement.id) {
                  objetoSeleccionado = bahia;
                  elementosDeSVGPrincipal
                      ?.firstWhere((element) => element.id == svgElement.id)
                      .resaltado = true;
                  bahiasResaltadas.add(elementosDeSVGPrincipal!
                      .firstWhere((element) => element.id == svgElement.id));
                }
              }
            }
            ultimasBahiasResaltadas = bahiasResaltadas;
          }
        } else if (svgElement.tipoElemento == '3') {
          bahiasResaltadas.clear();
          vista = '1';
          await loadSvgImagePrincipal(svgImg: svg);
          for (var rack in racks) {
            for (var bahia in rack.bahias) {
              if (bahia.pasilloId == svgElement.id) {
                print('coincide');
                objetoSeleccionado = null;
                print(elementosDeSVGPrincipal?.length);
                elementosDeSVGPrincipal
                    ?.firstWhere((element) => element.id == bahia.id)
                    .resaltado = true;
                bahiasResaltadas.add(elementosDeSVGPrincipal!
                    .firstWhere((element) => element.id == bahia.id));
              } else {
                print('no coincide');
              }
            }
          }
          ultimasBahiasResaltadas = bahiasResaltadas;
        }
        if (objetoSeleccionado != null) {
          getProductosAMostrar(objetoSeleccionado);
          if (tapEnMapaPrincipal) {
            panelController.open();
          }
        }
      } else {
        if (!tapEnMapaDetalle) {
          for (var e in elementosDeSVGDetalle!) {
            e.resaltado = false;
            print(e.id);
          }
          print('print ${svgElement.id}');
          elementosDeSVGDetalle
              ?.firstWhere((element) => element.id == svgElement.id)
              .resaltado = true;
        }
      }
    }else{
      for (var e in elementosDeSVGPrincipal!) {
        e.resaltado = false;
        objetoSeleccionado = null;
        bahiasResaltadas.clear();
        for (var rack in racks) {
          for (var bahia in rack.bahias) {
            if (bahia.id == svgElement.id) {
              objetoSeleccionado = bahia;
              elementosDeSVGPrincipal
                  ?.firstWhere((element) => element.id == svgElement.id)
                  .resaltado = true;
              bahiasResaltadas.add(elementosDeSVGPrincipal!
                  .firstWhere((element) => element.id == svgElement.id));
              ultimasBahiasResaltadas = bahiasResaltadas;
            }
          }
        }
      }
    }

    setState(() {});
  }

  void getProductosAMostrar(dynamic objeto) {
    productosAMostrar.clear();

    for (var p in productosRack) {
      if (vista == '2') {
        for (var r in racks) {
          if (r.id == objeto.id) {
            for (var b in r.bahias) {
              if (b.id == p.locacion) {
                productosAMostrar.add(p);
              }
            }
          }
        }
      } else {
        for (var r in racks) {
          for (var b in r.bahias) {
            if (b.id == objeto.id) {
              if (b.id == p.locacion) {
                productosAMostrar.add(p);
              }
            }
          }
        }
      }
    }
  }

  List<Producto> getCoincidencias() {
    List<Producto> coincidencias = [];
    String inputText = textEditingController.text;
    print('productos en el rack ${productosRack.length}');
    for (var p in productosRack) {
      if (p.nombre.toLowerCase().contains(
            inputText.toLowerCase(),
          )) {
        coincidencias.add(p);
      }
    }
    if (coincidencias.isEmpty) {
      mostrarListaCoincidencias = false;
    }
    return coincidencias;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
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
          'Mapa de almacén',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: mapaCargado
          ? SlidingUpPanel(
              onPanelClosed: () {
                mostrarDetalleBahia = false;
                selectedIndex=null;
              },
              backdropOpacity: 0.28,
              backdropEnabled: true,
              backdropTapClosesPanel: true,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              snapPoint: .84,
              maxHeight: screenSize.height * .52,
              minHeight: screenSize.height * 0,
              controller: panelController,
              color: Theme.of(context).canvasColor,
              panel: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // mostrarDetalleBahia = !mostrarDetalleBahia;
                      // loadSvgImage(svgImg: svgRackDetalle);
                      // setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenSize.width*.02),
                        child: const Center(
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  vista == '1'
                      ?productosAMostrar.isNotEmpty? GestureDetector(
                          onTap: () {
                            mostrarDetalleBahia = !mostrarDetalleBahia;
                            setState(() {});
                          },
                          child: Icon(!mostrarDetalleBahia
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up),
                        )
                      : const SizedBox(): const SizedBox(),
                  mostrarDetalleBahia
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: screenSize.width * .365,
                                right: screenSize.width * .365,
                                top: screenSize.height * .01),
                            child: Container(
                              //color: Colors.pink,
                              height: screenSize.height * .134,
                              width: screenSize.width * .8,
                              child: InteractiveViewer(
                                maxScale: 2,
                                minScale: .1,
                                child: Stack(
                                  children: [
                                    for (var elemento in elementosDeSVGDetalle!)
                                      _getClippedImage(
                                          clipper: Clipper(
                                            scale: .35,
                                            svgPath: elemento.partPath,
                                          ),
                                          color: kPrimaryColor.withOpacity(
                                              elemento.resaltado ? .5 : 1),
                                          element: elemento,
                                          abrirPanel: false,
                                          tapEnDetalle: true),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: mostrarDetalleBahia
                        ? screenSize.height * .29
                        : vista=='2'?screenSize.height * .48:screenSize.height * .43,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListView.builder(

                          itemCount:productosAMostrar.isNotEmpty? productosAMostrar.length:1,
                          itemBuilder: (context, index) {
                            var producto;
                            if(productosAMostrar.isNotEmpty){
                               producto =productosAMostrar[index];
                            }

                            return Container(
                              color: selectedIndex==index?Colors.black12:Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: GestureDetector(
                                  onTap: () async {


                                    if(productosAMostrar.isNotEmpty){
                                      if(vista=='1'){
                                        mostrarDetalleBahia = true;
                                        for (var e in elementosDeSVGDetalle!) {
                                          if (e.id == '0${producto.nivel}') {
                                            onElementSelected(e, false, false, false);
                                          }
                                        }
                                        if(index==selectedIndex){
                                          selectedIndex=null;
                                          for (var e in elementosDeSVGDetalle!) {
                                            e.resaltado = false;
                                          }
                                        }else{
                                          selectedIndex=index;
                                        }
                                      }else{
                                        panelController.close();
                                        vista='1';
                                        loadSvgImagePrincipal(svgImg: svg);
                                        List<ElementoDeSVG> elementos =
                                            await getElementSVG(svg);
                                        for (var elemento in elementos!) {
                                          if (elemento.id ==
                                              producto.locacion) {
                                            print('lo encontró');
                                            onElementSelected(
                                                elemento, false, false, true);
                                          } else {
                                            print('no lo encontro');
                                          }
                                        }
                                      }
                                    }
                                    setState(() {});
                                  },
                                  child: ListTile(
                                    key: UniqueKey(),
                                    leading:productosAMostrar.isNotEmpty? Image.network(
                                      producto.pathFoto,
                                      height: 40,
                                      width: 40,
                                    ):const SizedBox(),
                                    title: Text(productosAMostrar.isNotEmpty?
                                      producto.nombre:'No hay productos en esta ubicación',
                                      style: greyTextStyle,
                                    ),
                                    subtitle: Text(productosAMostrar.isNotEmpty?
                                      'Locación: ${producto.locacion ?? 'no asignada'}':'',
                                      style:
                                          greyTextStyle.copyWith(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                       SizedBox(
                        height: screenSize.height*.007,
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenSize.width * .022),
                        child: TextFormField(
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            suffix: GestureDetector(
                              onTap: (){
                                textEditingController.text='';
                                mostrarListaCoincidencias=false;
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
                                 EdgeInsets.symmetric(horizontal: screenSize.width * .022),
                            labelText: 'Búsqueda de productos',
                            labelStyle: const TextStyle(color: Colors.black26),
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
                              mostrarListaCoincidencias = false;
                            } else {
                              mostrarListaCoincidencias = true;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: screenSize.width * .03),
                        child: Text(
                          'Sección: ${objetoSeleccionado != null ? objetoSeleccionado.id : ''}',
                          style: greyTextStyle.copyWith(
                              fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: screenSize.height * .5,
                          width: screenSize.width * .8,
                          child: InteractiveViewer(
                            maxScale: 2,
                            minScale: .1,
                            child: Stack(
                              children: [
                                for (var elemento in elementosDeSVGPrincipal!)
                                  _getClippedImage(
                                    clipper: Clipper(
                                      scale: .79,
                                      svgPath: elemento.partPath,
                                    ),
                                    color: elemento.tipoElemento == '3'
                                        ? Theme.of(context)
                                            .scaffoldBackgroundColor
                                        : kPrimaryColor.withOpacity(
                                            elemento.resaltado ? .5 : 1),
                                    element: elemento,
                                    abrirPanel: true,
                                    tapEnDetalle: false,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                vista = '2';
                                loadSvgImagePrincipal(svgImg: svg);
                                setState(() {});
                              },
                              child: Container(
                                width: screenSize.width * .4,
                                decoration: BoxDecoration(
                                  border: Border.all(color:vista == '2'?kPrimaryColor: Colors.black26, width: 2, strokeAlign: BorderSide.strokeAlignInside),
                                  color: vista == '2'
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(screenSize.width * .022),
                                  child: Center(
                                      child: Text(
                                    'Racks',
                                    style: vista == '2'
                                        ? greyTextStyle.copyWith(
                                            color: Colors.white, fontSize: 16)
                                        : greyTextStyle.copyWith(fontSize: 16),
                                  )),
                                ),
                              ),
                            ),
                             SizedBox(width: screenSize.width*.01,),
                            GestureDetector(
                              onTap: () {
                                vista = '1';
                                loadSvgImagePrincipal(svgImg: svg);
                                setState(() {});
                              },
                              child: Container(
                                width: screenSize.width * .4,
                                decoration: BoxDecoration(
                                  border: Border.all(color:vista == '1'?kPrimaryColor: Colors.black26, width: 2, strokeAlign: BorderSide.strokeAlignInside),
                                  color: vista == '1'
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(screenSize.width * .022),
                                  child: Center(
                                      child: Text(
                                    'Bahías',
                                    style: vista == '1'
                                        ? greyTextStyle.copyWith(
                                            color: Colors.white, fontSize: 16)
                                        : greyTextStyle.copyWith(fontSize: 16),
                                  )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 38.0),
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       await Navigator.push(
                      //         context,
                      //         MaterialPageRoute(builder: (context) {
                      //           return ProductosScreen(
                      //             productos: prodcutosJson,
                      //           );
                      //         }),
                      //       );
                      //       productosRack = getAllProductsFromRacks(racks);
                      //     },
                      //     child: Container(
                      //       width: 50,
                      //       decoration: BoxDecoration(
                      //         color: Colors.transparent,
                      //         border:
                      //             Border.all(color: kPrimaryColor, width: 3),
                      //         borderRadius: const BorderRadius.all(
                      //           Radius.circular(12),
                      //         ),
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(8.0),
                      //         child: Center(
                      //           child: Icon(
                      //             Icons.battery_6_bar,
                      //             color: kPrimaryColor,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  mostrarListaCoincidencias
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: 0.0,
                              right: 0,
                              top: screenSize.height * .08),
                          child: Container(
                            //height: 100,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: ListView.builder(
                                itemCount: getCoincidencias().isNotEmpty
                                    ? getCoincidencias().length
                                    : 1,
                                itemBuilder: (context, index) {
                                  var coincidencia;
                                  if (getCoincidencias().isNotEmpty) {
                                    coincidencia = getCoincidencias()[index];
                                  }
                                  return GestureDetector(
                                    onTap: () async {
                                      if (getCoincidencias().isNotEmpty) {
                                        textEditingController.text =
                                            coincidencia.nombre;
                                        mostrarListaCoincidencias = false;
                                        productoABuscar = coincidencia;
                                        vista = '1';
                                        loadSvgImagePrincipal(svgImg: svg);
                                        List<ElementoDeSVG> elementos =
                                            await getElementSVG(svg);
                                        for (var elemento in elementos!) {
                                          if (elemento.id ==
                                              productoABuscar!.locacion) {
                                            print('lo encontró');
                                            onElementSelected(
                                                elemento, false, false, true);
                                          } else {
                                            print('no lo encontro');
                                          }
                                        }
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      } else {
                                        mostrarListaCoincidencias = false;
                                      }
                                      setState(() {});
                                    },
                                    child: ListTile(
                                      key: UniqueKey(),
                                      leading: getCoincidencias().isNotEmpty
                                          ? Image.network(
                                              coincidencia.pathFoto,
                                              height: 40,
                                              width: 40,
                                            )
                                          : const SizedBox(),
                                      title: Text(
                                        getCoincidencias().isNotEmpty
                                            ? coincidencia.nombre
                                            : 'No hay coincidencias en el almacen',
                                        style: greyTextStyle,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: kPrimaryColor,),
            ),
    );
  }
}
