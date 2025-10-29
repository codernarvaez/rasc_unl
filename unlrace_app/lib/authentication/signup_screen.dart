import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unl_race/global/global_var.dart';
import 'package:unl_race/methods/common_methods.dart';
import 'package:unl_race/pages/home_page.dart';
import 'package:unl_race/widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController apellidosTextEditingController =
      TextEditingController();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();

  bool isPasswordVisible = true;

  showLoadingDialog() {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Espere por favor'),
          ),
        );
      },
    );
  }

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    signFormValidation();
  }

  signFormValidation() {
    if (userNameTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar("Introduzca sus nombres completos", context);
    } else if (apellidosTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar("Introduzca sus apellidos completos", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar(
          "Por favor escriba un correo electrónico válido.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "su contraseña debe tener al menos 6 o más caracteres.", context);
    } else {
      // register user
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      builder: (context) =>
          const LoadingDialog(messageText: "Registrando su cuenta..."),
      barrierDismissible: false,
    );

    try {
      final User? userFirebase =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ))
              .user;

      if (!context.mounted) return;
      Navigator.pop(context);

      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase!.uid);

      Map userDataMap = {
        "nombres": userNameTextEditingController.text.trim().toUpperCase(),
        "apellidos": apellidosTextEditingController.text.trim().toUpperCase(),
        "email": emailTextEditingController.text.trim(),
        "id": userFirebase.uid,
        "blockStatus": "no",
        "role": "admin",
      };

      usersRef.set(userDataMap);

      if (!mounted) return;

      showModalVerification();
    } catch (e) {
      Navigator.pop(context);
      return cMethods.displaySnackBar(e.toString(), context);
    }
  }

  showModalVerification() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Usuario registrado correctamente',
            style: TextStyle(
              fontFamily: "QuicksandMedium",
            ),
          ),
          content: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text(
                'ir al home',
                style: TextStyle(fontFamily: "QuicksandMedium"),
              ),
              onPressed: () {
                Navigator.pop(context);

                FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ), (route) => false);
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final borde = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      borderSide: BorderSide(
        color: secondary,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                const SizedBox(
                  height: 62,
                ),

                Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'QuicksandMedium',
                    color: color,
                  ),
                ),

                // text fields + Button
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOMBRES
                      TextField(
                        controller: userNameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          focusedBorder: borde,
                          labelText: 'Nombres completos',
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

                      // APELLIDOS
                      TextField(
                        controller: apellidosTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          focusedBorder: borde,
                          labelText: 'Apellidos completos',
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
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red,
                          enabledBorder: borde,
                          border: borde,
                          focusedBorder: borde,
                          labelText: 'Email',
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              isPasswordVisible = !isPasswordVisible;
                              setState(() {});
                            },
                            icon: isPasswordVisible
                                ? const Icon(Icons.remove_red_eye,
                                    color: Colors.white)
                                : const Icon(Icons.visibility_off,
                                    color: Colors.white),
                          ),
                          focusedBorder: borde,
                          labelText: 'Contraseña',
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
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            checkIfNetworkIsAvailable();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 80)),
                          child: Text(
                            'Registrarse',
                            style: TextStyle(
                              color: primary,
                              fontFamily: 'QuicksandBold',
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
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
