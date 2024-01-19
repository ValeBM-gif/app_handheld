import 'package:flutter/material.dart';

import '../constants.dart';
import 'mapa_almacen_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('Menú',style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 24),),
            ),
            GestureDetector(
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>MapaAlmacenScreen()));},
                child: HomeIcon(Icons.fire_truck, )),
             HomeIcon(Icons.alternate_email),
          ],
        ),
      ),
    );
  }
}
