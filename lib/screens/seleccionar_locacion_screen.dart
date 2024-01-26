import 'package:app_handheld/models/bahia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import '../constants.dart';
import '../main.dart';
import '../models/clipper.dart';
import '../models/elemento_svg.dart';

class SeleccionarLocacionScreen extends StatefulWidget {
  final String? locacionActual;
   SeleccionarLocacionScreen({super.key, this.locacionActual});

  @override
  State<SeleccionarLocacionScreen> createState() =>
      _SeleccionarLocacionScreenState();
}

class _SeleccionarLocacionScreenState extends State<SeleccionarLocacionScreen> {

  List<ElementoDeSVG>? elementosDeSVG;
  Bahia? bahiaSeleccionada;
  Bahia? ultimaBahiaSeleccionada;
  bool mapaCargado = false;
  String? locacionSeleccionada;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    funcionesIniciales();
  }

  void funcionesIniciales()async{
    await loadSvgImage(svgImg: svg);
    print('¿ ${widget.locacionActual}');
    buscarLocacionActual(widget.locacionActual);
  }

  Future<void> loadSvgImage({required String svgImg}) async {
    elementosDeSVG?.clear();
    elementosDeSVG = await getElementSVG(svgImg);
    setState(() {
      mapaCargado = true;
    });
  }

  void buscarLocacionActual(loc){
    for(var r in racks){
      for(var b in r.bahias){
        if(b.id==loc){
          print('encuentra');
          bahiaSeleccionada = b;
          ultimaBahiaSeleccionada=bahiaSeleccionada;
          locacionSeleccionada = loc;
        }
      }
    }
    if(bahiaSeleccionada!=null){
      for(var e in elementosDeSVG!){
        if(e.id==bahiaSeleccionada!.id){
          elementosDeSVG?.firstWhere((element) => element.id == e.id).resaltado = true;
        }
      }
    }
    setState(() {});
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
            ? onElementSelected(element)
            : () {
                print('element nulo');
              },
        child: Container(
          color: color,
        ),
      ),
    );
  }

  Future<void> onElementSelected(
      ElementoDeSVG svgElement) async {
    for (var e in elementosDeSVG!) {
      e.resaltado = false;
      bahiaSeleccionada = null;
    }
    if (svgElement.tipoElemento == '1') {
      if(ultimaBahiaSeleccionada != null){
        if (ultimaBahiaSeleccionada!.id == svgElement.id) {
          bahiaSeleccionada = null;
          elementosDeSVG
              ?.firstWhere((element) => element.id == svgElement.id)
              .resaltado = false;
          ultimaBahiaSeleccionada = null;
          locacionSeleccionada=null;
        } else {
          for (var rack in racks) {
            for (var bahia in rack.bahias) {
              if (bahia.id == svgElement.id) {
                bahiaSeleccionada = bahia;
                elementosDeSVG
                    ?.firstWhere((element) => element.id == svgElement.id)
                    .resaltado = true;
                ultimaBahiaSeleccionada=bahiaSeleccionada;
              }
            }
          }
        }
      }else{
        for (var rack in racks) {
          for (var bahia in rack.bahias) {
            if (bahia.id == svgElement.id) {
              bahiaSeleccionada = bahia;
              elementosDeSVG
                  ?.firstWhere((element) => element.id == svgElement.id)
                  .resaltado = true;
              ultimaBahiaSeleccionada=bahiaSeleccionada;
            }
          }
        }
      }
    }
    if(bahiaSeleccionada!=null){
      locacionSeleccionada=bahiaSeleccionada!.id;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, locacionSeleccionada);
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
          'Selecciona una ubicación',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text('Locación: ${locacionSeleccionada??''}', style: greyTextStyle,),
          ),
          mapaCargado?
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
                          scale: .79,
                          svgPath: elemento.partPath,
                        ),
                        color: elemento.tipoElemento == '3'
                            ? Theme.of(context).scaffoldBackgroundColor
                            : kPrimaryColor
                                .withOpacity(elemento.resaltado ? .5 : 1),
                        element: elemento,
                      ),
                  ],
                ),
              ),
            ),
          ):const Center(child: CircularProgressIndicator(color: kPrimaryColor,)),
        ],
      ),
    );
  }
}
