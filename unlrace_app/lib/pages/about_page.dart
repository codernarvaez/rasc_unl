import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Esta app fue desarrollada por JFdeSousa.com",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "QuicksandBold",
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          ElevatedButton.icon(
            onPressed: () {
              launchUrl(Uri.parse("https://jfdesousa.com"));
            },
            icon: const Icon(Icons.send),
            label: const Text(
              "Visitar web",
              style: TextStyle(
                fontFamily: "QuicksandSemiBold",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
