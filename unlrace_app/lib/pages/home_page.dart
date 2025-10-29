import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/arbitro_home_page.dart';
import 'package:unl_race/pages/arbitros_page.dart';
import 'package:unl_race/pages/competitions_list_page.dart';
import 'package:unl_race/pages/new_competition_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';
import 'package:unl_race/authentication/login_screen.dart';
import 'package:unl_race/global/global_var.dart';

class HomePage extends StatefulWidget {
  final bool? isReset;
  const HomePage({super.key, this.isReset});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String version = "";
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpened = true;
  CommonMethods cMethods = CommonMethods();

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
            userApellido = (snap.snapshot.value as Map)["apellidos"];
            userRole = (snap.snapshot.value as Map)["role"];

            idCompetition = (snap.snapshot.value as Map)["idCompetition"] ?? "";
            idTeam = (snap.snapshot.value as Map)["idTeam"] ?? "";
            competition = (snap.snapshot.value as Map)["competition"] ?? "";
            team = (snap.snapshot.value as Map)["team"] ?? "";
            nro = (snap.snapshot.value as Map)["nro"] ?? "";

            setState(() {});

            if (userRole == "arbitro") {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return const ArbitroHomePage();
                },
              ), (route) => false);
            }
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

            // NUEVA COMPETENCIA

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const NewCompetitionPage();
                        },
                      ));
                    },
                    child: const Text(
                      "Nueva competencia",
                      style: TextStyle(
                        fontFamily: "QuicksandMedium",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const CompetitionsListPage();
                        },
                      ));
                    },
                    child: const Text(
                      "Listado de competencias",
                      style: TextStyle(
                        fontFamily: "QuicksandMedium",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const ArbitrosPage();
                        },
                      ));
                    },
                    child: const Text(
                      "Gestionar Arbitros",
                      style: TextStyle(
                        fontFamily: "QuicksandMedium",
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
