import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../background.dart';
import '../constants.dart';
import '../main.dart';
import 'home_screen.dart';

late SharedPreferences loginData;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool mostrarCargando = false;

  late bool isNewUser;
  late String password = '';
  final uri = Uri.parse("$api/Auth/Authenticate");

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin().then((loggedIn) {
      if (loggedIn) {
        openPage();
      }
    });
    print('con que usuario llegamos a login? $user');
  }

  void checkTokenExpiration() {
    int? tokenTimeInMillis = loginData.getInt('tokenTime');
    if (tokenTimeInMillis != null) {
      DateTime tokenTime =
          DateTime.fromMillisecondsSinceEpoch(tokenTimeInMillis);
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(tokenTime);

      const Duration tokenExpiration = Duration(hours: 8);

      if (difference > tokenExpiration) {
        print('Token expirado, intentando renovar...');
        getToken();
      }
    }
  }

  Future<bool> checkIfAlreadyLogin() async {
    loginData = await SharedPreferences.getInstance();
    isNewUser = (loginData.getBool('login') ?? true);
    if (!isNewUser) {
      checkTokenExpiration();
      if (loginData != null) {
        user = loginData.getString('username')!;
      }
      return true; // Usuario logueado
    }
    return false; // Usuario no logueado
  }

  void getToken() async {
    user = loginData.getString('username')!;
    password = loginData.getString('password')!;
    DateTime tokenTime = DateTime.now();
    print('en get token que usuario tenemos? $user');
    if (await internet()) {
      try {
        var res = await http.post(
          uri,
          body: {"username": user, "password": password},
        );

        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          final token = body['access_token'];
          loginData.setString('usuario', user);
          loginData.setString('token', token);
          loginData.setInt('tokenTime', tokenTime.millisecondsSinceEpoch);
          print('Datos de usuario y token guardados en SharedPreferences');
        } else if (res.statusCode == 401) {
          print('Token expirado, intentando renovar...');
          // Intentar obtener el token nuevamente después de renovar
          getToken();
        } else {
          print('Error al obtener token: ${res.statusCode}');
        }
      } catch (e) {
        print('Error al obtener token: $e');
      }
    } else {
      print('No hay conexión a Internet');
      // Utilizar las credenciales almacenadas en SharedPreferences
      user = loginData.getString('username')!;
      password = loginData.getString('password')!;
      getToken();
    }
  }

  void openPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(userName: user),
      ),
      (route) => false,
    );
  }

  Future<bool> internet() async {
    try {
      final connection = await InternetAddress.lookup('google.com');
      if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> validate() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      if (!isLoading) {
        print('isloading es falso');
        isLoading = true;
        if (await internet()) {
          print('cuando');
          login();
        } else {
          isLoading = false;
          showNoInternetBottomSheet();
        }
      } else {
        print('isloading es true');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showNoInternetBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/nowifi.jpeg',
                  height: 40, // Ajusta el alto según tus necesidades
                  width: 40, // Ajusta el ancho según tus necesidades
                ),
                const SizedBox(height: 8),
                const Text(
                  '¡Sin conexión a Internet!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade800,
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void login() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      mostrarCargando = true;
      user = usernameController.text;
      var res = await http.post(uri,
          body: ({
            'username': usernameController.text,
            'password': passwordController.text,
          }));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        loginData.setBool('login', false);
        loginData.setString('username', usernameController.text);
        loginData.setString('password', passwordController.text);
        loginData.setString('token', body['access_token']);
        print('logueado $user, ${body['access_token']}');
        print('Datos de usuario y token guardados en SharedPreferences');

        openPage();
      } else {
        setState(() {
          isLoading = false;
          mostrarCargando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('El usuario o contraseña son incorrectos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Background(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                FadeInDown(
                  duration: Duration(seconds: 1),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/logo.png",
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                FadeInLeftBig(
                  duration: Duration(seconds: 1),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                FadeInUp(
                  duration: Duration(seconds: 1),
                  child: SizedBox(
                    height: 120,
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          margin: const EdgeInsets.only(
                            right: 30,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(80),
                              bottomRight: Radius.circular(80),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 16, right: 32),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade700),
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade700),
                                    border: InputBorder.none,
                                    icon: Icon(
                                        color: Colors.grey.shade700,
                                        Icons.account_circle_rounded),
                                    hintText: "Usuario",
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 16, right: 32),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade700),
                                  controller: passwordController,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade700),
                                    border: InputBorder.none,
                                    icon: Icon(
                                        color: Colors.grey.shade700,
                                        Icons.password),
                                    hintText: "Contraseña",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: FadeInRightBig(
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      kPrimaryColorNoTransparent,
                                      kPrimaryColorDark,
                                    ],
                                  ),
                                ),
                                child: !mostrarCargando
                                    ? IconButton(
                                        iconSize: 24,
                                        icon: const Icon(
                                            Icons.arrow_forward_outlined),
                                        color: Colors.white,
                                        onPressed: () async {
                                          await validate();
                                          setState(() {});
                                        },
                                      )
                                    : Container(
                                        height: 24,
                                        width: 24,
                                        margin: const EdgeInsets.only(left: 0),
                                        child: const CircularProgressIndicator(
                                          color: kPrimaryColorDark,
                                        ),
                                      ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "v 1.0.0",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
