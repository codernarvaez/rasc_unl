import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:unl_race/authentication/login_screen.dart';
import 'package:unl_race/authentication/signup_screen.dart';
import 'package:unl_race/global/global_var.dart';
import 'package:unl_race/methods/common_methods.dart';

class OptPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OptPage(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OptPage> createState() => _OptPageState();
}

class _OptPageState extends State<OptPage> {
  CommonMethods cMethods = CommonMethods();
  String? otpCode;
  bool isLoading = false;
  String? uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 25,
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: primary),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: Image.asset("assets/images/6325251.png"),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Verificación",
                        style: TextStyle(
                          fontFamily: "QuicksandBold",
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Ingrese el código que has recibido en tu dispositivo móvil vía sms",
                        style: TextStyle(
                          fontFamily: "QuicksandMedium",
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Pinput(
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: PinTheme(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primary,
                              width: 3,
                            ),
                          ),
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onCompleted: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      // VERIFY BUTTON
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                              primary,
                            ),
                          ),
                          onPressed: () async {
                            if (otpCode != null) {
                              isLoading = true;
                              setState(() {});

                              try {
                                PhoneAuthCredential creds =
                                    PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: otpCode!,
                                );

                                User? user = (await FirebaseAuth.instance
                                        .signInWithCredential(creds))
                                    .user;

                                uid = user?.uid;
                                bool isUserExist = false;
                                // await FirebaseAuth.instance.signOut();
                                //await user?.unlink("phone");
                                //await user!.unlink("phone");
                                // await user.delete();

                                await FirebaseDatabase.instance
                                    .ref("unlrace_app")
                                    .once()
                                    .then((snap) {
                                  if (snap.snapshot.value != null) {
                                    Map data = snap.snapshot.value as Map;

                                    data.forEach((key, value) {
                                      if (value["phoneUID"] == uid) {
                                        isUserExist = true;
                                      }
                                    });
                                  }
                                });

                                if (isUserExist) {
                                  if (!mounted) return;
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const LoginScreen();
                                    },
                                  ), (route) => false);
                                } else {
                                  if (!mounted) return;
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const SignUpScreen();
                                    },
                                  ), (route) => false);
                                }

                                isLoading = false;
                                setState(() {});
                              } on FirebaseAuthException catch (e) {
                                if (!mounted) return;

                                cMethods.displaySnackBar(
                                    e.message.toString(), context);
                                isLoading = false;
                                setState(() {});
                              }
                            } else {
                              cMethods.displaySnackBar(
                                  "Ingresar el código de 6 dígitos", context);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Text(
                              "Verificar",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "QuicksandSemiBold",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // const Text(
                      //   "No recibiste el código?",
                      //   style: TextStyle(
                      //     fontFamily: "QuicksandMedium",
                      //     color: Colors.black54,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // const Text(
                      //   "Reenviar código",
                      //   style: TextStyle(
                      //     fontFamily: "QuicksandMedium",
                      //     color: Colors.green,
                      //     fontSize: 16,
                      //   ),
                      // ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
