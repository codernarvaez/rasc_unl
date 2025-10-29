import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unl_race/authentication/signup_screen.dart';
import 'package:unl_race/global/global_var.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/arbitro_home_page.dart';

import 'package:unl_race/pages/home_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();
  bool isPasswordVisible = true;

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar(
          "Por favor escriba un correo electrónico válido.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "su contraseña debe tener al menos 6 o más caracteres.", context);
    } else {
      // register user
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(messageText: "Validando..."),
      barrierDismissible: false,
    );

    try {
      final User? userFirebase =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ))
              .user;

      if (!context.mounted) return;
      Navigator.pop(context);

      if (userFirebase != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userFirebase.uid);

        usersRef.once().then((snap) async {
          try {
            if (snap.snapshot.value != null) {
              if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
                userName = (snap.snapshot.value as Map)["nombres"];
                userApellido = (snap.snapshot.value as Map)["apellidos"];

                userRole = (snap.snapshot.value as Map)["role"];

                pass = passwordTextEditingController.text.trim();

                email = emailTextEditingController.text.trim();

                idUserFirebaseAdmin = FirebaseAuth.instance.currentUser!.uid;

                if (userRole == "admin") {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const HomePage();
                    },
                  ), (route) => false);
                } else if (userRole == "arbitro") {
                  idCompetition = (snap.snapshot.value as Map)["idCompetition"];
                  idTeam = (snap.snapshot.value as Map)["idTeam"];
                  competition = (snap.snapshot.value as Map)["competition"];
                  team = (snap.snapshot.value as Map)["team"];

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const ArbitroHomePage();
                    },
                  ), (route) => false);
                }
              } else {
                FirebaseAuth.instance.signOut();
                cMethods.displaySnackBar(
                    "Estás bloqueado. Ponte en contacto con soporte para mayor información",
                    context);
              }
            } else {
              FirebaseAuth.instance.signOut();
              cMethods.displaySnackBar(
                  "Tu registro no existe como usuario", context);
            }
          } catch (e) {
            if (!context.mounted) return;
            Navigator.pop(context);

            cMethods.displaySnackBar(
                "Error inesperado. Intente de nuevo mas tarde.", context);
          }
        });
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);

      cMethods.displaySnackBar(
          "Error inesperado. Intente de nuevo mas tarde.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borde = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(
        color: primary,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 62,
                ),
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'QuicksandMedium',
                    color: color,
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                // text fields + Button
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          focusedBorder: borde,
                          labelText: 'Email usuario',
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: color,
                            fontFamily: 'QuicksandRegular',
                          ),
                        ),
                        style: TextStyle(
                          color: color,
                          fontSize: 15,
                          fontFamily: 'QuicksandRegular',
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextField(
                        controller: passwordTextEditingController,
                        keyboardType: TextInputType.text,
                        obscureText: isPasswordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          focusedBorder: borde,
                          suffixIcon: IconButton(
                            onPressed: () {
                              isPasswordVisible = !isPasswordVisible;
                              setState(() {});
                            },
                            icon: isPasswordVisible
                                ? const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                          ),
                          labelText: 'Contraseña usuario',
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: color,
                            fontFamily: 'QuicksandRegular',
                          ),
                        ),
                        style: TextStyle(
                          color: color,
                          fontSize: 15,
                          fontFamily: 'QuicksandRegular',
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkIfNetworkIsAvailable();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 80)),
                        child: Text(
                          'Acceder',
                          style: TextStyle(
                            color: primary,
                            fontFamily: 'QuicksandBold',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const SignUpScreen();
                            },
                          ));
                        },
                        child: Text(
                          'No tienes una cuenta? Registrate ya!',
                          style: TextStyle(
                            color: color,
                            fontFamily: 'QuicksandRegular',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
