import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unl_race/methods/common_methods.dart';

import 'package:unl_race/widgets/loading_dialog.dart';

import 'package:unl_race/authentication/login_screen.dart';
import 'package:unl_race/global/global_var.dart';

class ArbitroHomePage extends StatefulWidget {
  final bool? isReset;
  const ArbitroHomePage({super.key, this.isReset});

  @override
  State<ArbitroHomePage> createState() => _ArbitroHomePageState();
}

class _ArbitroHomePageState extends State<ArbitroHomePage> {
  String version = "";
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpened = true;
  CommonMethods cMethods = CommonMethods();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String _tiempo = "00:00:00.00";
  List<Map<String, dynamic>> resultados = [];
  bool _bonificacionUsada = false;
  int _numResultados = 0;
  int nroTeam = 0;
  String _sumatoriaTiempos = "00:00:00.000";

  Future getNroTeam() async {
    final DatabaseReference database = FirebaseDatabase.instance
        .ref()
        .child("teams")
        .child(idTeam)
        .child("nro");

    DataSnapshot snap = await database.get();

    if (snap.exists) {
      setState(() {
        nroTeam = snap.value as int;
      });
    }
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  getUserInfoAndCheckBlockStatus() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await userRef.once().then(
      (snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["nombres"];

            userRole = (snap.snapshot.value as Map)["role"];

            setState(() {});
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar(
                "Estás bloqueado. Ponte en contacto con soporte para mayor información.",
                context);

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ), (route) => false);
          }
        } else {
          FirebaseAuth.instance.signOut();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfoAndCheckBlockStatus();
    initPackageInfo();
    getNroTeam();

    _database
        .child('competencia/$idCompetition/tiempo')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          _tiempo = event.snapshot.value as String;
        });
      }
    });

    _database
        .child('resultados/$idCompetition/$idTeam/')
        .onChildAdded
        .listen((event) {
      final Map data = event.snapshot.value as Map;

      resultados.add({
        'key': event.snapshot.key,
        'tiempo': data["tiempo"],
        'timestamp': data['timestamp'],
        'bonificacion': data['bonificacion'] ?? false,
      });

      if (data['bonificacion']) {
        _bonificacionUsada = true;
      }

      _numResultados = resultados.length;
      _sumatoriaTiempos = calcularSumatoria();

      setState(() {});
    });

    _database
        .child('competencia/$idCompetition/bonificaciones/$idTeam')
        .onValue
        .listen((event) {
      setState(() {
        _bonificacionUsada = event.snapshot.value != null;
        _sumatoriaTiempos = calcularSumatoria();
      });
    });
  }

  void guardarResultado(bool bonificacion) {
    if (_numResultados < 15) {
      final DatabaseReference resultadosRef =
          _database.child('resultados/$idCompetition/$idTeam').push();
      resultadosRef.set({
        'tiempo': _tiempo,
        'timestamp': DateTime.now().toIso8601String(),
        'bonificacion': false,
      });

      if (bonificacion == true) {
        setState(() {
          _bonificacionUsada = true;
          _numResultados++;
          _sumatoriaTiempos = calcularSumatoria();
        });
      } else {
        setState(() {
          _numResultados++;
          _sumatoriaTiempos = calcularSumatoria();
        });
      }
    } else if (!_bonificacionUsada && bonificacion) {
      _database.child('competencia/$idCompetition/bonificaciones/$idTeam').set({
        'aplicada': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
      setState(() {
        _bonificacionUsada = true;
        _sumatoriaTiempos = calcularSumatoria();
      });
    }
  }

  String calcularSumatoria() {
    Duration total = Duration.zero;
    bool hayBonificacion = false;
    for (var resultado in resultados) {
      final partes = resultado['tiempo'].split(':');
      final hours = int.parse(partes[0]);
      final minutes = int.parse(partes[1]);
      final secondsMilliseconds = partes[2].split('.');
      final seconds = int.parse(secondsMilliseconds[0]);
      final milliseconds = int.parse(secondsMilliseconds[1]);
      final tiempo = Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
      );
      total += tiempo;
      if (resultado['bonificacion'] == true) {
        hayBonificacion = true;
      }
    }
    if (hayBonificacion) {
      total -= const Duration(seconds: 30);
    }
    return total.toString().split('.').first;
  }

  void eliminarUltimoResultado() {
    if (resultados.isNotEmpty) {
      final ultimoResultado = resultados.removeLast();
      _database
          .child('resultados/$idCompetition/$idTeam/${ultimoResultado['key']}')
          .remove()
          .then((_) {
        setState(() {
          _numResultados--;
          _sumatoriaTiempos = calcularSumatoria();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: primary,
        key: sKey,
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          color: Colors.black87,
          child: Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              children: [
                // header
                SizedBox(
                  height: 130,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: primary,
                    ),
                    child: Row(
                      children: [
                        imageUser == null
                            ? const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 207, 207, 207),
                                radius: 20,
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Color.fromRGBO(105, 104, 104, 1),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 207, 207, 207),
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRect(
                                    child: Image.network(
                                      imageUser!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hola, $userName $userApellido",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "QuicksandBold",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // getOut
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                    ),
                    title: const Text(
                      "Salir",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "QuicksandSemiBold",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            /// Drawer button
            Positioned(
              top: 42,
              left: 19,
              child: GestureDetector(
                onTap: () {
                  if (isDrawerOpened) {
                    sKey.currentState!.openDrawer();
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const LoadingDialog(
                          messageText: 'Espere por favor...',
                        );
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                    child: Icon(
                      isDrawerOpened ? Icons.menu : Icons.close_outlined,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).size.height * 0.02,
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (userRole != "")
                          Text(
                            " Rol: ${userRole[0].toUpperCase() + userRole.substring(1).toLowerCase()}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "QuicksandBold",
                            ),
                          ),
                        const Text(
                          "UNLrace",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                        Text(
                          "Versión $version",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "QuicksandRegular",
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // CRONOMETRO

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    competition,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontFamily: "QuicksandBold",
                    ),
                  ),
                  Text(
                    "#$nroTeam - $team",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "QuicksandBold",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tiempo: $_tiempo',
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "QuicksandBold",
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _numResultados < 15 && _tiempo != "00:00:00.00"
                                ? () => guardarResultado(false)
                                : null,
                        child: const Text(
                          'Asignar tiempo ',
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            !_bonificacionUsada && _tiempo != "00:00:00.00"
                                ? () => guardarResultado(true)
                                : null,
                        child: const Text(
                          'Bonificación',
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _tiempo != "00:00:00.00"
                        ? eliminarUltimoResultado
                        : null,
                    child: const Text(
                      'Eliminar Último Resultado',
                      style: TextStyle(
                        fontFamily: "QuicksandBold",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Resultados en tiempo real',
                    style: TextStyle(
                      fontFamily: "QuicksandBold",
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    height: 200,
                    child: ListView.builder(
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        final resultado = resultados[index];
                        int count = index + 1;
                        String isBonificacion =
                            resultado['bonificacion'] == true ? "B" : "";
                        return ListTile(
                          title: Text(
                            '#$count - ${resultado['tiempo']}  $isBonificacion',
                            style: const TextStyle(
                              fontFamily: "QuicksandBold",
                              color: Colors.black,
                            ),
                          ),
                          trailing: const Text(
                            'Tiempo registrado',
                            style: TextStyle(
                              fontFamily: "QuicksandBold",
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Text(
                      'Sumatoria de Tiempos: $_sumatoriaTiempos',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "QuicksandRegular",
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
