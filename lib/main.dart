import 'package:app_handheld/screens/home_screen.dart';
import 'package:app_handheld/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';
import 'models/producto.dart';
import 'models/rack.dart';
import 'models/sucursal.dart';

var api = "https://enersisuat.azurewebsites.net/api";
late String user = 'vacio';

List<Rack> racks = [];
List<Sucursal> sucursales = [];
List<Producto> productosGlobal = [];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    racks = getRacksFromJson(mapaRacks);
    _controller = VideoPlayerController.asset('assets/LogoAnimation.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();

    // Repetir el video
    _controller.setLooping(false);

    // Iniciar la reproducción una vez que el video esté inicializado
    _controller.play();

    // Esperar unos segundos y luego navegar a la pantalla principal
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });

    super.initState();
  }

  List<Rack> getRacksFromJson(json) {
    var mapaRacks = json['Racks'] as List;
    return mapaRacks.map((r) => Rack.fromJson(r)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Center(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Si el video está listo, muestra el reproductor de video con zoom
                  return Transform.scale(
                    scale:
                        1.5, // Ajusta este valor para cambiar el nivel de zoom
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  // Mientras el video se está inicializando, muestra un indicador de carga
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
