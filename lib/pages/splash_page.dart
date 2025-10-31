import 'package:flutter/material.dart';
import 'package:unl_race/authentication/login_screen.dart';
import 'package:unl_race/global/global_var.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Image.asset(
                'assets/images/icon.jpeg',
                width: 120,
                height: 120,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ), (route) => false);
              },
              child: const Text(
                "Iniciar sesión",
                style: TextStyle(
                  fontFamily: "QuicksandBold",
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
