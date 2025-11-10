import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:unl_race/global/trip.dart';

class TripCalificationDriverPage extends StatefulWidget {
  const TripCalificationDriverPage({super.key});

  @override
  State<TripCalificationDriverPage> createState() =>
      _TripCalificationDriverPageState();
}

class _TripCalificationDriverPageState
    extends State<TripCalificationDriverPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Calificar al conductor',
                style: TextStyle(
                  fontFamily: "QuicksandSemiBold",
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ClipOval(
                child: Image.network(
                  photoDriver == ""
                      ? "https://firebasestorage.googleapis.com/v0/b/flutter-taxi-app-b9ff5.appspot.com/o/avatarman.png?alt=media&token=a69d5ee8-0c5c-465a-8d4d-e6b918e2052d"
                      : photoDriver,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                nameDriver,
                style: const TextStyle(
                  fontFamily: "QuicksandBold",
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (r) {
                rating = r;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, "calificationDone");
                },
                child: const Text("Aceptar",
                    style: TextStyle(
                      fontFamily: "QuicksandSemiBold",
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
