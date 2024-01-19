import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Para imprimir lo que tengo el input en la consola
    _controller.addListener(() {
      print("Lo que tiene el input es: ${_controller.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            //autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Lo que sea...',
            ),
          ),
        ),
      ),
    );
  }
}