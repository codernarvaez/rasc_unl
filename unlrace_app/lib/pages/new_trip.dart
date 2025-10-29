import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unlrace_app/appInfo/app_info.dart';
import 'package:unlrace_app/authentication/login_screen.dart';
import 'package:unlrace_app/global/global_var.dart';
import 'package:unlrace_app/global/trip.dart';
import 'package:unlrace_app/methods/common_methods.dart';

import 'package:unlrace_app/methods/manage_drivers_methods.dart';
import 'package:unlrace_app/models/address_model.dart';
import 'package:unlrace_app/models/direction_details.dart';
import 'package:unlrace_app/models/online_nearby_drivers.dart';
import 'package:unlrace_app/pages/home_page.dart';
import 'package:unlrace_app/pages/trip_calification_driver_page.dart';
import 'package:unlrace_app/widgets/info.dart';
import 'package:unlrace_app/widgets/info_dialog.dart';
import 'package:unlrace_app/widgets/loading_dialog.dart';
import 'package:unlrace_app/widgets/payment_dialog.dart';

class NewTripPage extends StatefulWidget {
  final int selectedOption;
  final int selectedPaymentOption;
  final String? tripID;
  const NewTripPage({
    super.key,
    required this.selectedOption,
    required this.selectedPaymentOption,
    this.tripID,
  });

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 276;
  double bottomMapPadding = 200;
  double rideDetailsContainerHeight = 0;
  double requestContainerHeight = 220;
  double tripContainerHeight = 0;
  DirectionDetails? tripDirectionDetailsInfo;
  List<LatLng> polyLineCoOrdinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  bool isDrawerOpened = false;

  bool nearbyOnlineDriversKeysLoaded = false;
  BitmapDescriptor? carIconNearbyDriver;

  StreamSubscription<DatabaseEvent>? tripStreamSubscription;
  bool requestingDirectionDetailsInfo = false;
  List<Rates> rates = [];
  DatabaseReference? tripRequestRef;

  bool showModalPayment = false;
  bool showModalCalification = false;

  makeDriverNearbyCarIcon() {
    if (carIconNearbyDriver == null) {
      ImageConfiguration configuration =
          createLocalImageConfiguration(context, size: const Size(0.5, 0.5));

      BitmapDescriptor.fromAssetImage(
              configuration, "assets/images/tracking.png")
          .then((iconImage) {
        carIconNearbyDriver = iconImage;
      });
    }
  }

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/night_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);

    final list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPositionOfUser = positionOfUser;

    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 17);

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (!context.mounted) return;

    await CommonMethods.convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
        positionOfUserInLatLng, context);

    await getUserInfoAndCheckBlockStatus();

    //await initializeGeoFireListener();
  }

  getUserInfoAndCheckBlockStatus() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("unlrace_app")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await userRef.once().then(
      (snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            setState(() {
              userName = (snap.snapshot.value as Map)["name"];
              userApellido = (snap.snapshot.value as Map)["apellidos"];
              userPhone = (snap.snapshot.value as Map)["phone"];
              userWallet = (snap.snapshot.value as Map)["wallet"] != null
                  ? ((snap.snapshot.value as Map)["wallet"]).toDouble()
                  : 0.0;
            });
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar(
                "Estás bloqueado o en proceso de validación. Ponte en contacto con soporte para mayor información",
                context);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ), (route) => false);
          }
        } else {
          FirebaseAuth.instance.signOut();

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ), (route) => false);
        }
      },
    );
  }

  retrieveDirectionDetails(
      LatLng pickUpLocation, LatLng dropOffDestination) async {
    var pickUpGeoGraphicsCoOrdenates = pickUpLocation;

    var dropOffDestinationGeoGraphicsCoOrdenates = dropOffDestination;

    /// Direction API
    var detailsFromDirectionAPI =
        await CommonMethods.getDirectionDetailsFromAPI(
      pickUpGeoGraphicsCoOrdenates,
      dropOffDestinationGeoGraphicsCoOrdenates,
    );

    if (detailsFromDirectionAPI == null) {
      if (!context.mounted) return;
      Navigator.pop(context);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const LoadingDialog(
              messageText: "Aviso :: Ruta fuera de rango permitido");
        },
      );

      await Future.delayed(const Duration(seconds: 3), () {});
      if (!context.mounted) return null;

      Navigator.pop(context);

      searchContainerHeight = 276;
      bottomMapPadding = -80;
      rideDetailsContainerHeight = 0;
      isDrawerOpened = true;

      return null;
    }

    setState(() {
      tripDirectionDetailsInfo = detailsFromDirectionAPI;
    });

    PolylinePoints pointsPolyline = PolylinePoints();

    List<PointLatLng> latLngPointsFromPickUpToDestination =
        pointsPolyline.decodePolyline(tripDirectionDetailsInfo!.encodedPoints!);

    polyLineCoOrdinates.clear();

    if (latLngPointsFromPickUpToDestination.isNotEmpty) {
      for (var latLngPoint in latLngPointsFromPickUpToDestination) {
        polyLineCoOrdinates
            .add(LatLng(latLngPoint.latitude, latLngPoint.longitude));
      }
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId("polylineID"),
        color: Colors.pink,
        points: polyLineCoOrdinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if (pickUpGeoGraphicsCoOrdenates.latitude >
            dropOffDestinationGeoGraphicsCoOrdenates.latitude &&
        pickUpGeoGraphicsCoOrdenates.longitude >
            dropOffDestinationGeoGraphicsCoOrdenates.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: dropOffDestinationGeoGraphicsCoOrdenates,
          northeast: pickUpGeoGraphicsCoOrdenates);
    } else if (pickUpGeoGraphicsCoOrdenates.longitude >
        dropOffDestinationGeoGraphicsCoOrdenates.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(pickUpGeoGraphicsCoOrdenates.latitude,
              dropOffDestinationGeoGraphicsCoOrdenates.longitude),
          northeast: LatLng(dropOffDestinationGeoGraphicsCoOrdenates.latitude,
              pickUpGeoGraphicsCoOrdenates.longitude));
    } else if (pickUpGeoGraphicsCoOrdenates.latitude >
        dropOffDestinationGeoGraphicsCoOrdenates.latitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(dropOffDestinationGeoGraphicsCoOrdenates.latitude,
              pickUpGeoGraphicsCoOrdenates.longitude),
          northeast: LatLng(pickUpGeoGraphicsCoOrdenates.latitude,
              dropOffDestinationGeoGraphicsCoOrdenates.longitude));
    } else {
      boundsLatLng = LatLngBounds(
          southwest: pickUpGeoGraphicsCoOrdenates,
          northeast: dropOffDestinationGeoGraphicsCoOrdenates);
    }

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 72));

    /// Markers

    // String pickUpAddress = context.read<TripProvider>().pickUpAddress;
    // String dropOffAddress = context.read<TripProvider>().dropOffAddress;

    String pickUpAddress =
        context.read<AppInfo>().pickUpLocation!.humanReadableAddress!;

    String dropOffAddress =
        context.read<AppInfo>().dropOffLocation!.humanReadableAddress!;

    Marker pickUpPointMarker = Marker(
      markerId: const MarkerId("pickUpPointMarkerID"),
      position: pickUpGeoGraphicsCoOrdenates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: pickUpAddress,
      ),
    );

    Marker dropOffDestinationPointMarker = Marker(
      markerId: const MarkerId("dropOffDestinationMarkerPointMarkerID"),
      position: dropOffDestinationGeoGraphicsCoOrdenates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: dropOffAddress, snippet: "Destination Location"),
    );

    setState(() {
      markerSet.add(pickUpPointMarker);
      markerSet.add(dropOffDestinationPointMarker);
    });

    /// Circle

    Circle pickUpPointCircle = Circle(
      circleId: const CircleId("pickUpID"),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: pickUpGeoGraphicsCoOrdenates,
      fillColor: Colors.pink,
    );

    Circle dropOffDestinationPointCircle = Circle(
      circleId: const CircleId("dropOffDestinationID"),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: dropOffDestinationGeoGraphicsCoOrdenates,
      fillColor: Colors.pink,
    );

    setState(() {
      circleSet.add(pickUpPointCircle);
      circleSet.add(dropOffDestinationPointCircle);
    });

    return '';
  }

  resetAppNow() async {
    polyLineCoOrdinates.clear();
    polylineSet.clear();
    markerSet.clear();
    circleSet.clear();
    rideDetailsContainerHeight = 0;
    requestContainerHeight = 0;
    tripContainerHeight = 0;
    searchContainerHeight = 276;
    bottomMapPadding = 300;
    isDrawerOpened = true;
    status = "";
    nameDriver = "";
    apellidoDriver = "";
    photoDriver = "";
    phoneNumberDriver = "";
    carDetailsDriver = "";
    tripStatusDisplay = "El conductor está llegando";
    statusOfTrip = "";
    tripID = "";

    Provider.of<AppInfo>(context, listen: false)
        .updateDropOffLocation(AddressModel());
  }

  cancelRideRequest() async {
    await tripRequestRef!.remove();

    await FirebaseDatabase.instance
        .ref("unlrace_app")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({"tripID": "", "statusOfTrip": ""});
  }

  cancelTripRequestByUserWhenDriverAlreadyAcepted() async {
    await tripRequestRef!.child("status").set("tripCancelledByUser");

    await FirebaseDatabase.instance
        .ref("unlrace_app")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({"tripID": "", "statusOfTrip": ""});

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Info(
          title: "Aviso",
          description: "Viaje cancelado satisfactoriamente!",
          fn: () => resetAppByUser(),
        );
      },
    );
  }

  displayRequestContainer() {
    // send ride request
    makeTripRequest();
  }

  resetAppByUser() async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return const HomePage(
          isReset: true,
        );
      },
    ), (route) => false);
  }

  makeTripRequest() async {
    if (statusOfTrip == "requesting") {
      tripRequestRef =
          FirebaseDatabase.instance.ref().child("tripRequests").push();

      var pickUpLocation =
          Provider.of<AppInfo>(context, listen: false).pickUpLocation;

      var dropOffDestinationLocation =
          Provider.of<AppInfo>(context, listen: false).dropOffLocation;

      Map pickUpCoOrdinatesMap = {
        "latitude": pickUpLocation!.latitudePosition.toString(),
        "longitude": pickUpLocation.longitudePosition.toString(),
      };

      Map dropOffDestinationCoOrdinatesMap = {
        "latitude": dropOffDestinationLocation!.latitudePosition.toString(),
        "longitude": dropOffDestinationLocation.longitudePosition.toString(),
      };

      Map driverCoOrdinates = {
        "latitude": "",
        "longitude": "",
      };

      Map dataMap = {
        "tripID": tripRequestRef!.key,
        "publishDateTime": DateTime.now().toString(),
        "userName": userName,
        "userApellido": userApellido,
        "userPhone": userPhone,
        "userID": userID,
        "pickUpLatLng": pickUpCoOrdinatesMap,
        "dropOffLatLng": dropOffDestinationCoOrdinatesMap,
        "pickUpAddress": pickUpLocation.placeName,
        "dropOffAddress": dropOffDestinationLocation.placeName,
        "driverID": "waiting",
        "carDetails": "",
        "driverLocation": driverCoOrdinates,
        "driverName": "",
        "driverPhone": "",
        "driverPhoto": "",
        "driverCarPhoto": "",
        "fareAmount": "",
        "status": "new",
        "userPaid": false,
        "userCalificationDone": false,
        "typeRateSelected": widget.selectedOption,
        "paymentOptionSelected":
            widget.selectedPaymentOption == 0 ? "cash" : "wallet",
        "tripCalificationToDriver": 1.0,
        "imageUser": imageUser ?? "noPic"
      };

      tripRequestRef!.set(dataMap);
    } else {
      tripRequestRef =
          FirebaseDatabase.instance.ref().child("tripRequests").child(tripID);

      displayTripDetailsContainer();
      Geofire.stopListener();
      //remove drivers markers
      setState(() {
        markerSet.removeWhere(
            (element) => element.markerId.value.contains("driver"));
      });
    }

    tripStreamSubscription =
        tripRequestRef!.onValue.listen((eventSnapshot) async {
      // start listening for the driver new | arrived | accept | onTrip | ended

      if (eventSnapshot.snapshot.value == null) {
        return;
      }

      if ((eventSnapshot.snapshot.value as Map)["driverName"] != null) {
        nameDriver = (eventSnapshot.snapshot.value as Map)["driverName"];
      }

      if ((eventSnapshot.snapshot.value as Map)["driverApellido"] != null) {
        apellidoDriver =
            (eventSnapshot.snapshot.value as Map)["driverApellido"];
      }

      if ((eventSnapshot.snapshot.value as Map)["driverPhone"] != null) {
        phoneNumberDriver =
            (eventSnapshot.snapshot.value as Map)["driverPhone"];
      }

      if ((eventSnapshot.snapshot.value as Map)["driverID"] != null) {
        await FirebaseDatabase.instance
            .ref("drivers")
            .child((eventSnapshot.snapshot.value as Map)["driverID"])
            .child("calification")
            .once()
            .then((snap) => driverRating = snap.snapshot.value != null
                ? snap.snapshot.value as String
                : "");
      }

      if ((eventSnapshot.snapshot.value as Map)["driverPhoto"] != null) {
        photoDriver = (eventSnapshot.snapshot.value as Map)["driverPhoto"];
      }

      if ((eventSnapshot.snapshot.value as Map)["driverCarPhoto"] != null) {
        driverCarPhoto =
            (eventSnapshot.snapshot.value as Map)["driverCarPhoto"];
      }

      if ((eventSnapshot.snapshot.value as Map)["carDetails"] != null) {
        carDetailsDriver = (eventSnapshot.snapshot.value as Map)["carDetails"];
      }

      if ((eventSnapshot.snapshot.value as Map)["status"] != null) {
        status = (eventSnapshot.snapshot.value as Map)["status"];
      }

      if ((eventSnapshot.snapshot.value as Map)["driverLocation"]["latitude"] !=
              "" &&
          (eventSnapshot.snapshot.value as Map)["driverLocation"]
                  ["longitude"] !=
              "") {
        var driverLocation =
            (eventSnapshot.snapshot.value as Map)["driverLocation"];

        double driverLatitude =
            double.parse(driverLocation["latitude"].toString());

        double driverLongitude =
            double.parse(driverLocation["longitude"].toString());

        LatLng driverCurrentLocationLatLng =
            LatLng(driverLatitude, driverLongitude);

        if (status == "accepted") {
          await FirebaseDatabase.instance
              .ref("unlrace_app")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "tripID": tripRequestRef!.key.toString(),
            "statusOfTrip": "accepted"
          });

          //update information from pickup to user interface UI

          //info from driver current location to user pickup location

          updateFromDriverCurrentLocationToPickUp(driverCurrentLocationLatLng);
        } else if (status == "arrived") {
          await FirebaseDatabase.instance
              .ref("unlrace_app")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({"statusOfTrip": "arrived"});

          //update information from arrived - when driver reach at the pickup point of user

          setState(() {
            tripStatusDisplay = "El conductor ha llegado.";
          });

          // Provider.of<TripProvider>(context, listen: false)
          //     .setTripStatusDisplay(tripStatusDisplay);
        } else if (status == "ontrip") {
          await FirebaseDatabase.instance
              .ref("unlrace_app")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({"statusOfTrip": "ontrip"});
          //update information from dropOff to user interface UI

          //info from driver current location to user dropOff location

          updateFromDriverCurrentLocationToDropOffDestination(
              driverCurrentLocationLatLng);
        }
      }

      if (status == "tripCancelledByDriver") {
        await FirebaseDatabase.instance
            .ref("unlrace_app")
            .child(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "tripID": "",
          "statusOfTrip": "",
        });

        if (!context.mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Info(
              title: "Aviso",
              description: "Viaje cancelado por el conductor!",
              fn: () => resetAppByUser(),
            );
          },
        );
      }

      if (status == "accepted") {
        displayTripDetailsContainer();
        Geofire.stopListener();
        //remove drivers markers
        setState(() {
          markerSet.removeWhere(
              (element) => element.markerId.value.contains("driver"));
        });
      }

      if (status == "ended") {
        if ((eventSnapshot.snapshot.value as Map)["fareAmount"] != null) {
          String fareAmount =
              (eventSnapshot.snapshot.value as Map)["fareAmount"].toString();

          if (!mounted) return;

          String responseFromPaymentDialog = "";

          if (showModalPayment && showModalCalification) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const LoadingDialog(
                  messageText: "Gracias por confiar...",
                );
              },
            );
          }
          if (!showModalPayment) {
            responseFromPaymentDialog = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return PaymentDialog(
                    fareAmount: fareAmount,
                    selectedPaymentOption: widget.selectedPaymentOption);
              },
            );
          }

          await FirebaseDatabase.instance
              .ref("unlrace_app")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "statusOfTrip": "ended",
          });

          if (responseFromPaymentDialog == "paid") {
            showModalPayment = true;
            if (widget.selectedPaymentOption == 1) {
              await FirebaseDatabase.instance
                  .ref("unlrace_app")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({"wallet": userWallet - double.parse(fareAmount)});

              // userWallet = userWallet - double.parse(fareAmount);
            }

            // CALIFICAR AL CONDUCTOR AQUI
            if (!mounted) return;
            String responseFromTripCalificationDriverPage = "";
            if (!showModalCalification) {
              responseFromTripCalificationDriverPage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripCalificationDriverPage(),
                ),
              );
            }

            await tripRequestRef!.child("userPaid").set(true);
            showModalCalification = true;

            if (responseFromTripCalificationDriverPage == "calificationDone") {
              await tripRequestRef!.child("userCalificationDone").set(true);

              await tripRequestRef!
                  .child("tripCalificationToDriver")
                  .set(rating);

              await setCalificationToDriver(
                (eventSnapshot.snapshot.value as Map)["driverID"],
              );

              tripRequestRef!.onDisconnect();
              tripRequestRef = null;
              tripStreamSubscription!.cancel();
              tripStreamSubscription = null;

              await FirebaseDatabase.instance
                  .ref("unlrace_app")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "tripID": "",
                "statusOfTrip": "",
              });

              // resetAppNow();
              resetAppByUser();
            } else {
              // TODO: que pasa si el usuario no califica ??? resolver esto

              await tripRequestRef!
                  .child("tripCalificationToDriver")
                  .set(rating);

              // asignar al driver on clave

              await setCalificationToDriver(
                  (eventSnapshot.snapshot.value as Map)["driverID"]);

              tripRequestRef!.onDisconnect();
              tripRequestRef = null;
              tripStreamSubscription!.cancel();
              tripStreamSubscription = null;

              await FirebaseDatabase.instance
                  .ref("unlrace_app")
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "tripID": "",
                "statusOfTrip": "",
              });

              //resetAppNow();
              resetAppByUser();
            }
          }
        }
      }
    });
  }

  setCalificationToDriver(String driverID) async {
    final completedTripRequestsOfCurrentDriver =
        FirebaseDatabase.instance.ref().child("tripRequests");

    await completedTripRequestsOfCurrentDriver.once().then((snap) async {
      Map dataTrips = snap.snapshot.value as Map;

      int cantidad = 0;
      double rating = 0.0;

      dataTrips.forEach((key, value) {
        if (value["status"] != null &&
            value["status"] == "ended" &&
            value["driverID"] == driverID) {
          cantidad++;
          rating += value["tripCalificationToDriver"];
        }
      });

      double totalRatingOfCurrentDriver = (rating / cantidad);

      await FirebaseDatabase.instance
          .ref("drivers")
          .child(driverID)
          .child("calification")
          .set(totalRatingOfCurrentDriver.toStringAsFixed(1));
    });
  }

  displayTripDetailsContainer() {
    setState(() {
      requestContainerHeight = 0;

      tripContainerHeight = 360;

      bottomMapPadding = 281;
    });
  }

  updateFromDriverCurrentLocationToPickUp(
      LatLng driverCurrentLocationLatLng) async {
    if (!requestingDirectionDetailsInfo) {
      requestingDirectionDetailsInfo = true;

      var userPickUpLocationLatLng = LatLng(
          currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

      var directionDetailsPickUp =
          await CommonMethods.getDirectionDetailsFromAPI(
              driverCurrentLocationLatLng, userPickUpLocationLatLng);

      if (directionDetailsPickUp == null) {
        return;
      }

      setState(() {
        tripStatusDisplay =
            "El conductor está en camino - ${directionDetailsPickUp.durationTextString}";
      });

      requestingDirectionDetailsInfo = false;

      // if (!context.mounted) return;

      // Provider.of<TripProvider>(context, listen: false)
      //     .setTripStatusDisplay(tripStatusDisplay);
    }
  }

  updateFromDriverCurrentLocationToDropOffDestination(
      LatLng driverCurrentLocationLatLng) async {
    if (!requestingDirectionDetailsInfo) {
      requestingDirectionDetailsInfo = true;

      var dropOffLocation =
          Provider.of<AppInfo>(context, listen: false).dropOffLocation;

      var userDroOffLocationLatLng = LatLng(dropOffLocation!.latitudePosition!,
          dropOffLocation.longitudePosition!);

      var directionDetailsPickUp =
          await CommonMethods.getDirectionDetailsFromAPI(
              driverCurrentLocationLatLng, userDroOffLocationLatLng);

      if (directionDetailsPickUp == null) {
        return;
      }

      setState(() {
        tripStatusDisplay =
            "En camino al destino - ${directionDetailsPickUp.durationTextString}";
      });

      // Provider.of<TripProvider>(context, listen: false)
      //     .setTripStatusDisplay(tripStatusDisplay);

      requestingDirectionDetailsInfo = false;
    }
  }

  updateAvailableNearbyOnlineDriversOnMap() {
    setState(() {
      markerSet.clear();
    });

    Set<Marker> markersTempSet = {};

    for (OnlineNearbyDrivers eachOnlineNearbyDriver
        in ManageDriversMethods.nearbyOnlineDriversList) {
      LatLng driverCurrentPosition = LatLng(
          eachOnlineNearbyDriver.latDriver!, eachOnlineNearbyDriver.lngDriver!);

      Marker driverMarker = Marker(
        markerId: MarkerId("driver ID = ${eachOnlineNearbyDriver.uidDriver}"),
        position: driverCurrentPosition,
        icon: carIconNearbyDriver!,
      );

      markersTempSet.add(driverMarker);
    }

    setState(() {
      markerSet = markersTempSet;
    });
  }

  initializeGeoFireListener() {
    Geofire.initialize("onlineDrivers");

    Geofire.queryAtLocation(
      currentPositionOfUser!.latitude,
      currentPositionOfUser!.longitude,
      ratioUserGeoFire,
    )!
        .listen((driverEvent) {
      if (driverEvent != null) {
        var onlineDriverChild = driverEvent["callBack"];

        switch (onlineDriverChild) {
          case Geofire.onKeyEntered:
            OnlineNearbyDrivers onlineNearbyDrivers = OnlineNearbyDrivers();
            onlineNearbyDrivers.uidDriver = driverEvent["key"];
            onlineNearbyDrivers.latDriver = driverEvent["latitude"];
            onlineNearbyDrivers.lngDriver = driverEvent["longitude"];
            onlineNearbyDrivers.distance = driverEvent["distance"];

            var resultado = ManageDriversMethods.nearbyOnlineDriversList
                .indexWhere((OnlineNearbyDrivers element) =>
                    element.uidDriver == driverEvent["key"]);

            if (resultado == -1) {
              ManageDriversMethods.addOnlineNearbyDriversLocation(
                  onlineNearbyDrivers);

              if (nearbyOnlineDriversKeysLoaded == true) {
                // update drivers on google map
                updateAvailableNearbyOnlineDriversOnMap();
              }
            }

            break;

          case Geofire.onKeyExited:
            ManageDriversMethods.removeDriverFromList(driverEvent["key"]);

            updateAvailableNearbyOnlineDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            OnlineNearbyDrivers onlineNearbyDrivers = OnlineNearbyDrivers();
            onlineNearbyDrivers.uidDriver = driverEvent["key"];
            onlineNearbyDrivers.latDriver = driverEvent["latitude"];
            onlineNearbyDrivers.lngDriver = driverEvent["longitude"];
            onlineNearbyDrivers.distance = driverEvent["distance"];

            ManageDriversMethods.updateOnlineNearbyDriversLocation(
                onlineNearbyDrivers);

            updateAvailableNearbyOnlineDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            nearbyOnlineDriversKeysLoaded = true;

            updateAvailableNearbyOnlineDriversOnMap();
            break;
        }
      }
    });
  }

  noDriverAvailable() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const InfoDialog(
          title: "No hay conductores disponibles",
          description:
              "No hay conductores disponibles en estos momentos intente nuevamente en unos minutos.",
        );
      },
    );
  }

  searchDriver() {
    if (statusOfTrip == "requesting") {
      if (ManageDriversMethods.nearbyOnlineDriversList.isEmpty) {
        cancelRideRequest();
        resetAppNow();
        noDriverAvailable();
        return;
      }

      LatLng positionOfUserInLatLng = LatLng(
          currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

      CameraPosition cameraPosition =
          CameraPosition(target: positionOfUserInLatLng, zoom: 17);

      controllerGoogleMap!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      var currentDriver = ManageDriversMethods.nearbyOnlineDriversList[0];

      //send push notification to this current driver - selected driver

      sendNotificationToDriver(currentDriver);

      //availableNearbyOnlineDriversList!.removeAt(0);

      if (ManageDriversMethods.nearbyOnlineDriversList.isNotEmpty) {
        log("ELIMINADO");
        ManageDriversMethods.nearbyOnlineDriversList.removeAt(0);
      }
    }
  }

  sendNotificationToDriver(OnlineNearbyDrivers currentDriver) async {
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(currentDriver.latDriver!, currentDriver.lngDriver!),
        zoom: 19);

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    Map rates = {0: "economic", 1: "confort", 2: "pets"};

    String rateSelected = rates[widget.selectedOption];

    DatabaseReference rateRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentDriver.uidDriver.toString())
        .child(rateSelected);

    DatabaseEvent dataSnapshot = await rateRef.once();

    bool isRateDriverSelectedOption = dataSnapshot.snapshot.value as bool;

    if (isRateDriverSelectedOption == true) {
      // update drivers newTripStatus - assing tripID to current driver
      DatabaseReference currentDriverRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentDriver.uidDriver.toString())
          .child("newTripStatus");

      currentDriverRef.set(tripRequestRef!.key);

      const oneTickPerSec = Duration(seconds: 1);

      Timer.periodic(
        oneTickPerSec,
        (timer) async {
          requestTimeOutDriver = requestTimeOutDriver - 1;

          //when tripRequest is not requesting means trip request cancelled - stop timer

          if (statusOfTrip == "") {
            timer.cancel();
            await currentDriverRef.set("cancelled");
            currentDriverRef.onDisconnect();
            requestTimeOutDriver = 20;
            return;
          }

          // when trip request is accepted by online nearest driver

          if (requestTimeOutDriver == 0) {
            timer.cancel();
            currentDriverRef.onDisconnect();
            requestTimeOutDriver = 20;
            currentDriverRef.set("timeout");
            //send notification to next nearest online available driver
            // ManageDriversMethods.nearbyOnlineDriversList.removeAt(0);
            //ManageDriversMethods.nearbyOnlineDriversList.removeAt(0);
            searchDriver();
            log("SearchDriver", name: "requestTimeOutDriver == 0 PUSH");
          }

          currentDriverRef.onValue.listen((dataSnapshot) {
            if (dataSnapshot.snapshot.value.toString() == "accepted") {
              timer.cancel();
              currentDriverRef.onDisconnect();
              requestTimeOutDriver = 20;
              log("DRIVER accepted");
              statusOfTrip = "accepted";
            } else if (dataSnapshot.snapshot.value.toString() ==
                "declinedByDriver") {
              timer.cancel();
              currentDriverRef.onDisconnect();
              requestTimeOutDriver = 20;
              //ManageDriversMethods.nearbyOnlineDriversList.removeAt(0);
              searchDriver();
              log("SearchDriver no push", name: "declinedByDriver");
            }
          });

          //if 20 seconds passed - send notification to next nearest online available driver
        },
      );
    } else {
      // ManageDriversMethods.nearbyOnlineDriversList.removeAt(0);
      searchDriver();
      log("SearchDriver", name: "else");
    }
  }

  showModalSoporte() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Soporte',
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
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.headset,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Escríbenos al whatsapp para brindarte el soporte.',
                    style: TextStyle(
                      fontFamily: "QuicksandRegular",
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text(
                'Ir al whatstapp',
                style: TextStyle(fontFamily: "QuicksandMedium"),
              ),
              onPressed: () async {
                final configRef = FirebaseDatabase.instance
                    .ref("config")
                    .child("soportPhone");

                configRef.once().then(
                  (snap) {
                    if (snap.snapshot.exists) {
                      final phone = snap.snapshot.value as String;

                      // Ir al whatsapp
                      launchUrl(Uri.parse("https://wa.me/$phone"));
                    }
                  },
                );
              },
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  retrieveRate() async {
    final List<Rates> lista = [];

    await FirebaseDatabase.instance
        .ref()
        .child("rates")
        .once()
        .then((dataSnapshot) {
      (dataSnapshot.snapshot.value as Map).forEach((key, value) {
        lista.add(
          Rates(
            id: key,
            name: value["name"],
            km: double.parse(value["km"].toString()),
            min: double.parse(value["min"].toString()),
            seating: value["seating"],
            commission: value["commission"],
            basePrice: double.parse(value["base"].toString()),
            kmRestriction: double.parse(value["kmRestriction"].toString()),
          ),
        );
      });
    });

    lista.sort((a, b) => a.id!.compareTo(b.id!));

    if (!mounted) return;

    for (var rate in lista) {
      rates.add(Rates(
        id: rate.id,
        name: rate.name,
        km: rate.km,
        min: rate.min,
        seating: rate.seating,
        commission: rate.commission,
        basePrice: rate.basePrice,
        kmRestriction: rate.kmRestriction,
      ));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var pickUp = context.watch<AppInfo>().pickUpLocation;
    var dropOff = context.watch<AppInfo>().dropOffLocation;

    makeDriverNearbyCarIcon();
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: sKey,
        body: Stack(
          children: [
            /// Google map
            GoogleMap(
              padding: EdgeInsets.only(
                top: 86,
                bottom: bottomMapPadding,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: googlePlexInitialPosition,
              markers: markerSet,
              polylines: polylineSet,
              circles: circleSet,
              onMapCreated: (GoogleMapController mapController) async {
                controllerGoogleMap = mapController;

                updateMapTheme(mapController);
                googleMapCompleterController.complete(controllerGoogleMap);

                getCurrentLiveLocationOfUser();

                if (pickUp != null && dropOff != null) {
                  await retrieveDirectionDetails(
                    LatLng(pickUp.latitudePosition!, pickUp.longitudePosition!),
                    LatLng(
                        dropOff.latitudePosition!, dropOff.longitudePosition!),
                  );
                }

                updateAvailableNearbyOnlineDriversOnMap();

                makeTripRequest();
                searchDriver();
                log("SearchDriver", name: "Map");
              },
            ),

            // Buton cancel Trip By User cancelTripRequestByUserWhenDriverAlreadyAcepted

            statusOfTrip != "requesting"
                ? Positioned(
                    top: 42,
                    left: 5,
                    child: Dismissible(
                      key: const Key("key"),
                      direction: DismissDirection.startToEnd,

                      background: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: RippleWave(
                          color: primary,
                          repeat: true,
                          child: const Icon(
                            Icons.delete_forever,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      onDismissed: (direction) async {
                        cancelTripRequestByUserWhenDriverAlreadyAcepted();
                      },
                      // style: ElevatedButton.styleFrom(
                      //     backgroundColor: buttonColor),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RippleWave(
                              color: Colors.greenAccent,
                              repeat: true,
                              child: Icon(
                                Icons.keyboard_double_arrow_right_outlined,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Cancelar viaje ",
                              style: TextStyle(
                                fontFamily: "QuicksandBold",
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),

            /// button soport
            Positioned(
              top: 42,
              right: 5,
              child: SizedBox(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showModalSoporte();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Soporte ",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "QuicksandSemiBold",
                            ),
                          ),
                          Icon(
                            Icons.headset,
                            color: Colors.black,
                          )
                        ]),
                  ),
                ),
              ),
            ),

            /// Request Container  - loading container
            statusOfTrip == "requesting"
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: requestContainerHeight,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            RippleWave(
                              color: primary,
                              repeat: true,
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Buscando conductor mas cercano",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "QuicksandMedium",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                resetAppNow();
                                await cancelRideRequest();

                                // NAVIGATOR HERE
                                resetAppByUser();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),

            ///trip details container - driver info
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: tripContainerHeight,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 251, 255, 245),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white24,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),

                        // STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              tripStatusDisplay,
                              style: const TextStyle(
                                fontFamily: "QuicksandBold",
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IMAGEN DRIVER

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: photoDriver != ""
                                              ? NetworkImage(photoDriver)
                                              : const NetworkImage(
                                                  "https://firebasestorage.googleapis.com/v0/b/flutter-taxi-app-b9ff5.appspot.com/o/avatarman.png?alt=media&token=a69d5ee8-0c5c-465a-8d4d-e6b918e2052d"),
                                        ),
                                      ),
                                    ),
                                    Image.network(
                                      driverCarPhoto == ""
                                          ? "https://firebasestorage.googleapis.com/v0/b/flutter-taxi-app-b9ff5.appspot.com/o/avatarman.png?alt=media&token=a69d5ee8-0c5c-465a-8d4d-e6b918e2052d"
                                          : driverCarPhoto,
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    )
                                  ],
                                ),
                              ),

                              // DATOS DRIVER
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.58,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Conductor",
                                        style: TextStyle(
                                          fontFamily: "QuicksandRegular",
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),

                                      // NAME DRIVER
                                      Text(
                                        "  $nameDriver",
                                        style: const TextStyle(
                                          fontFamily: "QuicksandBold",
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),

                                      // APELIIDO DRIVER
                                      Text(
                                        "  $apellidoDriver",
                                        style: const TextStyle(
                                          fontFamily: "QuicksandBold",
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Vehiculo",
                                        style: TextStyle(
                                          fontFamily: "QuicksandRegular",
                                          fontSize: 18,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Text(
                                        carDetailsDriver != ""
                                            ? "  ${carDetailsDriver.split("-")[0]}"
                                            : "",
                                        style: const TextStyle(
                                          fontFamily: "QuicksandBold",
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      const Text(
                                        "Placa",
                                        style: TextStyle(
                                          fontFamily: "QuicksandRegular",
                                          fontSize: 18,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              carDetailsDriver != ""
                                                  ? "  ${carDetailsDriver.split("-")[1]}"
                                                  : "",
                                              style: const TextStyle(
                                                fontFamily: "QuicksandBold",
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  "Llamarle",
                                                  style: TextStyle(
                                                    fontFamily: "QuicksandBold",
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(25),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.phone_android_rounded,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
