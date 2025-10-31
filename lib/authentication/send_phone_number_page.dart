import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:unl_race/authentication/login_screen.dart';
import 'package:unl_race/authentication/opt_page.dart';
import 'package:unl_race/global/global_var.dart';

import 'package:unl_race/methods/common_methods.dart';

class SendPhoneNumberPage extends StatefulWidget {
  const SendPhoneNumberPage({super.key});

  @override
  State<SendPhoneNumberPage> createState() => _SendPhoneNumberPageState();
}

class _SendPhoneNumberPageState extends State<SendPhoneNumberPage> {
  CommonMethods cMethods = CommonMethods();
  TextEditingController userPhoneTextEditingController =
      TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'VE');
  bool isPhoneValid = false;
  String? phone;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 25,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 250,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Image.asset("assets/images/logo.png"),
                      const Text(
                        "DEMO USUARIOS",
                        style: TextStyle(
                          fontFamily: "QuicksandBold",
                          fontSize: 26,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Ingresa tu número de teléfono, te enviaremos un código de verificación.",
                  style: TextStyle(
                    fontFamily: "QuicksandMedium",
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    phone = number.phoneNumber;
                  },
                  onInputValidated: (bool value) {
                    isPhoneValid = value;
                    setState(() {});
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    useBottomSheetSafeArea: true,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  inputDecoration: const InputDecoration(
                    labelText: 'Teléfono',
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textFieldController: userPhoneTextEditingController,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                      !isLoading ? primary : Colors.grey,
                    ),
                  ),
                  onPressed: () async {
                    if (!isPhoneValid) {
                      cMethods.displaySnackBar(
                          "Introduzca un número de teléfono valido.", context);

                      return;
                    }
                    isLoading = true;
                    setState(() {});

                    try {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phone,
                        verificationCompleted: (phoneAuthCredential) async {
                          // (await FirebaseAuth.instance
                          //         .signInWithCredential(phoneAuthCredential))
                          //     .user;
                        },
                        verificationFailed: (e) {
                          cMethods.displaySnackBar(
                              e.message.toString(), context);

                          isLoading = false;
                          setState(() {});
                        },
                        codeSent: (verificationId, forceResendingToken) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return OptPage(
                                verificationId: verificationId,
                                phoneNumber: phone!,
                              );
                            },
                          ));
                        },
                        codeAutoRetrievalTimeout: (verificationId) {},
                      );
                    } on FirebaseAuthException catch (e) {
                      if (!mounted) return;
                      cMethods.displaySnackBar(e.message.toString(), context);

                      isLoading = false;
                      setState(() {});
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      isLoading ? "Espere por favor..." : "Verificar número",
                      style: const TextStyle(
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
      ),
    );
  }
}
