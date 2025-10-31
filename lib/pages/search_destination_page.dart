import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unlrace_app/appInfo/app_info.dart';
import 'package:unlrace_app/global/global_var.dart';
import 'package:unlrace_app/methods/common_methods.dart';
import 'package:unlrace_app/models/predictions_model.dart';
import 'package:unlrace_app/pages/map_location_manual.dart';

import 'package:unlrace_app/widgets/prediction_place_ui.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController =
      TextEditingController();

  List<PredictionsModel> dropOffPredictionsPlacesList = [];

  Timer? _debounceTimer;

  void onQueryChanged(String locationName) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 700), () {
      searchLocation(locationName);
    });
  }

  /// Google Places API Places AutoComplete
  searchLocation(String locationName) async {
    if (locationName.length > 1) {
      // Obtener referencia a la base de datos

      await FirebaseDatabase.instance
          .ref()
          .child("config")
          .child("country_code")
          .once()
          .then((snap) {
        if (snap.snapshot.value != null) {
          countryShortCode = snap.snapshot.value.toString();

          setState(() {});
        }
      });

      String apiPlacesUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=$googleMapKey&components=country:$countryShortCode";

      var responseFromPlacesAPI =
          await CommonMethods.sendRequestToAPI(apiPlacesUrl);

      if (responseFromPlacesAPI == "error") {
        return;
      }

      if (responseFromPlacesAPI["status"] == "OK") {
        var predictionsResultInJson = responseFromPlacesAPI["predictions"];

        var predictionsList = (predictionsResultInJson as List)
            .map((eachPlacePrediction) =>
                PredictionsModel.fromJson(eachPlacePrediction))
            .toList();

        setState(() {
          dropOffPredictionsPlacesList = predictionsList;
        });

        if (!mounted) return;
        Provider.of<AppInfo>(context, listen: false)
            .updateStatusPlaceSelectedDropOff(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String userAddress = Provider.of<AppInfo>(context).pickUpLocation != null
        ? Provider.of<AppInfo>(context).pickUpLocation!.humanReadableAddress ??
            ""
        : "-1";

    if (userAddress == "-1") {
      Navigator.of(context).pop();
    }

    pickUpTextEditingController.text = userAddress;

    String? userAddressDropOff =
        Provider.of<AppInfo>(context).dropOffLocation != null
            ? Provider.of<AppInfo>(context).dropOffLocation!.placeName ?? ""
            : "";

    bool isWriting = Provider.of<AppInfo>(context).isWriting;
    if (!isWriting) {
      destinationTextEditingController.text = userAddressDropOff;
    }

    bool updateStatusPlaceSelectedDropOff =
        Provider.of<AppInfo>(context).statusPlaceSelectedDropOff;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  color: color,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(31, 247, 247, 247),
                      blurRadius: 3.0,
                      spreadRadius: 0.3,
                      offset: Offset(0.4, 0.4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, top: 48, right: 24, bottom: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),

                          // ICON BUTTON - TITLE
                          const Center(
                            child: Text(
                              "¿A dónde vamos?",
                              style: TextStyle(
                                fontFamily: "QuicksandBold",
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // PickUp TextField
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/initial.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 219, 219, 219),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  style: const TextStyle(
                                    fontFamily: 'QuicksandRegular',
                                  ),
                                  controller: pickUpTextEditingController,
                                  decoration: const InputDecoration(
                                    hintText: "¿Desde dónde?",
                                    fillColor:
                                        Color.fromARGB(31, 255, 254, 254),
                                    filled: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 11,
                                      top: 9,
                                      bottom: 9,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const MapLocationManual(
                                    selectedLocation: 0,
                                  );
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.swipe_up,
                              color: Colors.green,
                              size: 24,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 11),

                      // Destination TextField

                      Row(
                        children: [
                          Image.asset(
                            "assets/images/final.png",
                            height: 18,
                            width: 18,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 219, 219, 219),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  style: const TextStyle(
                                    fontFamily: 'QuicksandRegular',
                                  ),
                                  controller: destinationTextEditingController,
                                  onChanged: (value) {
                                    Provider.of<AppInfo>(context, listen: false)
                                        .updateIsWriting(true);

                                    onQueryChanged(value);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "¿Hasta dónde?",
                                    fillColor: Colors.white12,
                                    filled: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 11,
                                      top: 9,
                                      bottom: 9,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const MapLocationManual(
                                    selectedLocation: 1,
                                  );
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.swipe_up,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // display PredictionResult for Destination

            dropOffPredictionsPlacesList.isNotEmpty &&
                    !updateStatusPlaceSelectedDropOff
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          child: PredictionPlaceUI(
                            predictedPlaceData:
                                dropOffPredictionsPlacesList[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 2,
                        );
                      },
                      itemCount: dropOffPredictionsPlacesList.length,
                    ),
                  )
                : Container(),

            // Button Accept & cancel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                            Colors.grey[300],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, "cancelar");
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                            Colors.yellow,
                          ),
                        ),
                        onPressed: () {
                          if (Provider.of<AppInfo>(context, listen: false)
                                  .dropOffLocation ==
                              null) {
                            return;
                          }

                          Navigator.pop(context, "placeSelected");
                        },
                        child: const Text(
                          "Aceptar",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
