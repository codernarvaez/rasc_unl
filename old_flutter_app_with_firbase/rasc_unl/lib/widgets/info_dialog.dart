import 'package:flutter/material.dart';
import 'package:unl_race/global/global_var.dart';
import 'package:unl_race/pages/home_page.dart';

class InfoDialog extends StatefulWidget {
  final String? title, description;
  const InfoDialog({super.key, this.title, this.description});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: color,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  widget.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: "QuicksandBold",
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 27),
                Text(
                  widget.description.toString(),
                  style: const TextStyle(
                    fontFamily: "QuicksandRegular",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 202,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const HomePage();
                          },
                        ),
                      );
                    },
                    child: const Text("OK"),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
