import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({super.key});

  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  final completedTripRequestsOfCurrentUser =
      FirebaseDatabase.instance.ref().child("tripRequests");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historial de viajes",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "QuicksandBold",
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: completedTripRequestsOfCurrentUser.onValue,
        builder: (context, snapshotData) {
          if (snapshotData.hasError) {
            return const Center(
              child: Text(
                "Ha ocurrido un error.",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          if ((!snapshotData.hasData)) {
            return const Center(
              child: Text(
                "No hay datos todavía.",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          if ((!snapshotData.data!.snapshot.exists)) {
            return const Center(
              child: Text(
                "No hay datos todavía.",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }

          Map dataTrips = snapshotData.data!.snapshot.value as Map;

          List tripsList = [];

          dataTrips
              .forEach((key, value) => tripsList.add({"key": key, ...value}));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: tripsList.length,
            itemBuilder: (context, index) {
              if (tripsList[index]["status"] != null &&
                  tripsList[index]["status"] == "ended" &&
                  tripsList[index]["userID"] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                return Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //pickup - fare amount
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/initial.png",
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Text(
                                tripsList[index]["pickUpAddress"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: "QuicksandRegular",
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "\$ ${tripsList[index]["fareAmount"].toString()}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: "QuicksandRegular",
                              ),
                            )
                          ],
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        //dropOff
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/final.png",
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Text(
                                tripsList[index]["dropOffAddress"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: "QuicksandRegular",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
