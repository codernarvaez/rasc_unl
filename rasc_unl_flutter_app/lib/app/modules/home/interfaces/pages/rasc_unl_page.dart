import 'package:flutter/material.dart';

class RascUnlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RASC UNL'),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD50000),
              ),
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD50000),
              ),
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}