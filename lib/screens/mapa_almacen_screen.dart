import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:xml/xml.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import '../constants.dart';
import '../models/clipper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:textfield_search/textfield_search.dart';
import '../models/elemento_svg.dart';
import '../models/producto.dart';
import '../models/rack.dart';

class MapaAlmacenScreen extends StatefulWidget {
  const MapaAlmacenScreen({Key? key}) : super(key: key);

  @override
  State<MapaAlmacenScreen> createState() => _MapaAlmacenScreenState();
}

class _MapaAlmacenScreenState extends State<MapaAlmacenScreen> {
  List<ElementoDeSVG>? elementosDeSVG;

  ElementoDeSVG? currentSelectionPrincipal;
  ElementoDeSVG? currentSelectionSubdivision;
  ElementoDeSVG? currentSelectionSeccion;

  ElementoDeSVG? lastSelectionPrincipal;
  ElementoDeSVG? lastSelectionSubdivision;
  ElementoDeSVG? lastSelectionSeccion;

  dynamic objetoSeleccionado;
  Producto? productoSeleccionado;

  bool mapaCargado = false;
  bool mostrarSubidivisiones = false;
  bool mostrarDetalleRack = false;
  String vista = "1";
  PanelController panelController = PanelController();
  TextEditingController textEditingController = TextEditingController();

  List<Producto> totalProductos = [];
  List<Producto> productosAMostrar = [];
  List<Producto> prodcutosBase = [];
  List<Producto> coincidencias = [];

  List<Rack> racks=[];

  bool mostrarListaCoincidencias = false;

  final key =
  LabeledGlobalKey<CustomRadioButtonState<dynamic>>('debug label? idk');

  @override
  void initState() {
    super.initState();
    racks=getRacksFromJson(mapaRacks);
    totalProductos = getAllProducts(racks);
    prodcutosBase = getProdcutosFromJson(mapaProductosBase);
    loadSvgImage(svgImg: svg);
    textEditingController.addListener(_printLatestValue);
  }

  List<Rack>getRacksFromJson(json){
    var mapaRacks = json['Racks'] as List;
    return mapaRacks.map((r) => Rack.fromJson(r)).toList();
  }

  List<Producto>getProdcutosFromJson(json){
    var mapProductos = json['Productos'] as List;
    return mapProductos.map((p) => Producto.fromJson(p, null)).toList();
  }

  _printLatestValue() {
    print("Textfield value: ${textEditingController.text}");
  }

  List<Producto> getAllProducts(List<Rack> allRacks) {
    List<Producto> prods = [];
    for (var r in allRacks) {
      for (var s in r.subidivisiones) {
        for (var se in s.secciones) {
          if (se.productos != null) {
            for (var p in se.productos!) {
              prods.add(p);
            }
          }
        }
      }
    }
    return prods;
  }

  Future<void> loadSvgImage({required String svgImg}) async {
    elementosDeSVG?.clear();
    elementosDeSVG =await getElementSVG(svgImg);
    for (var e in elementosDeSVG!) {
      print('${e.nombre}');
    }
    setState(() {
      mapaCargado = true;
    });
  }

  Future<List<ElementoDeSVG>> getElementSVG(svgImg)async{
    List<ElementoDeSVG> elementosACargar = [];
    String generalString = await rootBundle.loadString(svgImg);
    XmlDocument doc = XmlDocument.parse(generalString);
    final paths = doc.findAllElements('path');
    print('paths.length ${paths.length}, ${paths.runtimeType}');
    for (var path in paths) {
      if (vista == "1") {
        if (path.getAttribute('elementType').toString() != '2' &&
            path.getAttribute('elementType').toString() != '2.5') {
          String partId = path.getAttribute('id').toString();
          String partPath = path.getAttribute('d').toString();
          String name = path.getAttribute('name').toString();
          String type = path.getAttribute('elementType').toString();
          elementosACargar.add(ElementoDeSVG(
              id: partId,
              partPath: partPath,
              nombre: name,
              tipoElemento: type));
        }
      } else if (vista == "2") {
        if (path.getAttribute('elementType').toString() != '1' &&
            path.getAttribute('elementType').toString() != '2.5') {
          String partId = path.getAttribute('id').toString();
          String partPath = path.getAttribute('d').toString();
          String name = path.getAttribute('name').toString();
          String type = path.getAttribute('elementType').toString();
          elementosACargar.add(ElementoDeSVG(
              id: partId,
              partPath: partPath,
              nombre: name,
              tipoElemento: type));
        }
      } else if (vista == "2.5") {
        if (path.getAttribute('elementType').toString() != '2' &&
            path.getAttribute('elementType').toString() != '1') {
          String partId = path.getAttribute('id').toString();
          String partPath = path.getAttribute('d').toString();
          String name = path.getAttribute('name').toString();
          String type = path.getAttribute('elementType').toString();
          String parent = path.getAttribute('parent').toString();
          elementosACargar.add(ElementoDeSVG(
              id: partId,
              partPath: partPath,
              nombre: name,
              tipoElemento: type,
              parent: parent ?? null));
        }
      }
    }
    print('elementosACargar.length ${elementosACargar.length}');
    return elementosACargar;
  }

  Widget _getClippedImage({
    required Clipper clipper,
    required Color color,
    required ElementoDeSVG? element,
  }) {
    return ClipPath(
      clipper: clipper,
      child: GestureDetector(
        onTap: () => element != null
            ? onElementSelected(element, true)
            : () {
          print('element nulo');
        },
        child: Container(
          color: color,
        ),
      ),
    );
  }

  void onElementSelected(ElementoDeSVG svgElement, bool vieneDeTap) {
    if (svgElement.tipoElemento != '3') {
      if (vista == '1') {
        if (currentSelectionPrincipal == null ||
            svgElement.id != lastSelectionPrincipal?.id) {
          objetoSeleccionado =
              racks.firstWhere((rack) => rack.id == svgElement.id);

          currentSelectionPrincipal =
              elementosDeSVG?.firstWhere((c) => c.id == svgElement.id);
          lastSelectionPrincipal = currentSelectionPrincipal;
        } else {
          objetoSeleccionado = null;
          currentSelectionPrincipal = null;
        }
      } else if (vista == "2") {
        if (currentSelectionSubdivision == null ||
            svgElement.id != lastSelectionSubdivision?.id) {
          for (var rack in racks) {
            for (var subdivision in rack.subidivisiones) {
              if (subdivision.id == svgElement.id) {
                objetoSeleccionado = subdivision;
              }
            }
          }

          currentSelectionSubdivision =
              elementosDeSVG?.firstWhere((c) => c.id == svgElement.id);
          lastSelectionSubdivision = currentSelectionSubdivision;
        } else {
          objetoSeleccionado = null;
          currentSelectionSubdivision = null;
        }
      } else {
        if (currentSelectionSeccion == null ||
            svgElement.id != lastSelectionSeccion?.id) {
          for (var rack in racks) {
            for (var subdivision in rack.subidivisiones) {
              for (var seccion in subdivision.secciones) {
                if (seccion.id == svgElement.id) {
                  objetoSeleccionado = seccion;
                }
              }
            }
          }

          currentSelectionSeccion =
              elementosDeSVG?.firstWhere((c) => c.id == svgElement.id);
          lastSelectionSeccion = currentSelectionSeccion;
        } else {
          objetoSeleccionado = null;
          currentSelectionSeccion = null;
        }
      }

      if (objetoSeleccionado != null) {
        getProductosAMostrar(objetoSeleccionado);
        if(vieneDeTap){
          panelController.open();
        }
      }
    }

    setState(() {});
  }

  void getProductosAMostrar(dynamic objeto) {
    productosAMostrar.clear();
    if (vista == '1') {
      for (var r in racks) {
        if (r.id == objeto.id) {
          for (var s in r.subidivisiones) {
            for (var se in s.secciones) {
              if (se.productos != null) {
                for (var p in se.productos!) {
                  productosAMostrar.add(p);
                }
              }
            }
          }
        }
      }
    } else if (vista == '2') {
      for (var r in racks) {
        if (r.id == objeto.parent) {
          for (var s in r.subidivisiones) {
            if (s.id == objeto.id) {
              for (var se in s.secciones) {
                if (se.productos != null) {
                  for (var p in se.productos!) {
                    productosAMostrar.add(p);
                  }
                }
              }
            }
          }
        }
      }
    } else if (vista == '2.5') {
      for (var r in racks) {
        for (var s in r.subidivisiones) {
          if (s.id == objeto.parent) {
            for (var se in s.secciones) {
              if (se.id == objeto.id) {
                if (se.productos != null) {
                  for (var p in se.productos!) {
                    productosAMostrar.add(p);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  void getCoincidencias() async {
    coincidencias.clear();
    String inputText = textEditingController.text;
    for (var p in totalProductos) {
      if (p.nombre.toLowerCase().contains(
        inputText.toLowerCase(),
      )) {
        coincidencias.add(p);
      }
    }
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
        backdropOpacity: 0.28,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        snapPoint: .8,
        maxHeight: screenSize.height * .4,
        minHeight: screenSize.height * 0,
        controller: panelController,
        color: Theme.of(context).canvasColor,
        panel: Column(
          children: [
            GestureDetector(
              onTap: () {
                mostrarDetalleRack = !mostrarDetalleRack;
                loadSvgImage(svgImg: svgRackDetalle);
                setState(() {});
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
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Ver más',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            mostrarDetalleRack
                ? SizedBox(
              height: screenSize.height * .2,
              width: screenSize.width * .8,
              child: InteractiveViewer(
                maxScale: 2,
                minScale: .1,
                child: Stack(
                  children: [
                    _getClippedImage(
                      clipper: Clipper(
                        svgPath: svgRackDetalle,
                      ),
                      color: kPrimaryColor,
                      element: null,
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox(),
            SizedBox(
              height: mostrarDetalleRack
                  ? screenSize.height * .2
                  : screenSize.height * .326,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: productosAMostrar.length,
                    itemBuilder: (context, index) {
                      Producto producto = productosAMostrar[index];
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 18.0),
                        child: ListTile(
                          key: UniqueKey(),
                          leading: Image.asset(
                            producto.pathFoto,
                            height: 40,
                            width: 40,
                          ),
                          title: Text(
                            producto.nombre,
                            style: greyTextStyle,
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
                const SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      floatingLabelStyle:
                      MaterialStateTextStyle.resolveWith(
                            (Set<MaterialState> states) {
                          return greyTextStyle;
                        },
                      ),
                      contentPadding:
                      const EdgeInsets.only(left: 9, right: 9),
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
                        getCoincidencias();
                        mostrarListaCoincidencias = true;
                      }
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                    'Sección: ${vista == '1' ? currentSelectionPrincipal?.nombre : vista == "2" ? currentSelectionSubdivision?.nombre : currentSelectionSeccion?.nombre}',
                    style: greyTextStyle.copyWith(
                        fontWeight: FontWeight.w900, fontSize: 16),
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
                          for (var elemento in elementosDeSVG!)
                            _getClippedImage(
                              clipper: Clipper(
                                svgPath: elemento.partPath,
                              ),
                              color: vista == '1'
                                  ? kPrimaryColor
                              //Color(int.parse('FF${country.color}', radix: 16))
                                  .withOpacity(
                                  currentSelectionPrincipal ==
                                      null
                                      ? 1.0
                                      : currentSelectionPrincipal
                                      ?.id ==
                                      elemento.id
                                      ? 0.5
                                      : 1)
                                  : vista == '2'
                                  ? kPrimaryColor
                              //Color(int.parse('FF${country.color}', radix: 16))
                                  .withOpacity(
                                  currentSelectionSubdivision ==
                                      null
                                      ? 1.0
                                      : currentSelectionSubdivision
                                      ?.id ==
                                      elemento.id
                                      ? 0.5
                                      : 1)
                                  : kPrimaryColor
                              //Color(int.parse('FF${country.color}', radix: 16))
                                  .withOpacity(
                                  currentSelectionSeccion ==
                                      null
                                      ? 1.0
                                      : currentSelectionSeccion
                                      ?.id ==
                                      elemento.id
                                      ? 0.5
                                      : 1),
                              element: elemento,
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
                          vista = '1';
                          loadSvgImage(svgImg: svg);
                          setState(() {});
                        },
                        child: Container(
                          width: 85,
                          decoration: BoxDecoration(
                            color: vista == '1'
                                ? kPrimaryColor
                                : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                                  'Principal',
                                  style: vista == '1'
                                      ? greyTextStyle.copyWith(
                                      color: Colors.white, fontSize: 12)
                                      : greyTextStyle.copyWith(fontSize: 12),
                                )),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          vista = '2';
                          loadSvgImage(svgImg: svg);
                          setState(() {});
                        },
                        child: Container(
                          width: 85,
                          decoration: BoxDecoration(
                            color: vista == '2'
                                ? kPrimaryColor
                                : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                                  'Subdivisión',
                                  style: vista == '2'
                                      ? greyTextStyle.copyWith(
                                      color: Colors.white, fontSize: 12)
                                      : greyTextStyle.copyWith(fontSize: 12),
                                )),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          vista = '2.5';
                          loadSvgImage(svgImg: svg);
                          setState(() {});
                        },
                        child: Container(
                          width: 85,
                          decoration: BoxDecoration(
                            color: vista == '2.5'
                                ? kPrimaryColor
                                : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                                  'Secciones',
                                  style: vista == '2.5'
                                      ? greyTextStyle.copyWith(
                                      color: Colors.white, fontSize: 12)
                                      : greyTextStyle.copyWith(fontSize: 12),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),),
              ],
            ),
            mostrarListaCoincidencias
                ? Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 63),
              child: Container(
                height: 100,
                color: Colors.grey.shade200,
                child: ListView.builder(
                    itemCount: coincidencias.length,
                    itemBuilder: (context, index) {
                      var coincidencia = coincidencias[index];
                      return GestureDetector(
                        onTap: ()async {
                          textEditingController.text=coincidencia.nombre;
                          mostrarListaCoincidencias = false;
                          productoSeleccionado = coincidencia;
                          vista = '2.5';
                          loadSvgImage(svgImg: svg);
                          List<ElementoDeSVG> elementos =await getElementSVG(svg);
                          print('tut');
                          print(elementos?.length);
                          for (var elemento in elementos!){
                            if(elemento.id==productoSeleccionado!.idSeccion){
                              print('lo encontró');
                              onElementSelected(elemento, false);
                            }
                          }
                          setState(() {});
                        },
                        child: ListTile(
                          key: UniqueKey(),
                          leading: Image.asset(
                            coincidencia.pathFoto,
                            height: 40,
                            width: 40,
                          ),
                          title: Text(
                            coincidencia.nombre,
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
        child: CircularProgressIndicator(),
      ),
    );
  }
}
