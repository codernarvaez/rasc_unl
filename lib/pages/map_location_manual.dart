import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unlrace_app/appInfo/app_info.dart';
import 'package:unlrace_app/methods/common_methods.dart';
import 'package:unlrace_app/models/address_model.dart';
import 'package:unlrace_app/widgets/loading_dialog.dart';

class MapLocationManual extends StatefulWidget {
  final int selectedLocation;

  const MapLocationManual({super.key, required this.selectedLocation});

  @override
  State<MapLocationManual> createState() => _MapLocationManualState();
}

class _MapLocationManualState extends State<MapLocationManual> {
  GoogleMapController? controllerGoogleMap;
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    AddressModel location = widget.selectedLocation == 0
        ? Provider.of<AppInfo>(context).pickUpLocation!
        : Provider.of<AppInfo>(context).dropOffLocation != null
            ? Provider.of<AppInfo>(context).dropOffLocation!.latitudePosition !=
                    null
                ? Provider.of<AppInfo>(context).dropOffLocation!
                : Provider.of<AppInfo>(context).pickUpLocation!
            : Provider.of<AppInfo>(context).pickUpLocation!;

    LatLng locationLatLng =
        LatLng(location.latitudePosition!, location.longitudePosition!);

    CameraPosition googlePlexInitialPosition = CameraPosition(
      target: locationLatLng,
      zoom: 16,
    );

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // Google map
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;

              googleMapCompleterController.complete(controllerGoogleMap);
            },
            onCameraMove: (CameraPosition? position) async {
              if (locationLatLng != position!.target) {
                locationLatLng = position.target;
              }
            },
            onCameraIdle: () async {},
          ),

          // Info
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    " Seleccione manualmente su ubicación en el mapa.",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "QuicksandSemiBold",
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Pin Location
          Align(
            alignment: Alignment.center,
            child: widget.selectedLocation == 0
                ? Image.asset(
                    "assets/images/pin_pickup_location.png",
                    fit: BoxFit.contain,
                    width: 50,
                    height: 50,
                  )
                : Image.asset(
                    "assets/images/pin_dropoff_location.png",
                    fit: BoxFit.contain,
                    width: 50,
                    height: 50,
                  ),
          ),

          // Button Accept
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(Colors.yellow)),
                onPressed: () async {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const LoadingDialog(messageText: "Procesando...");
                    },
                  );

                  widget.selectedLocation == 0
                      ? await CommonMethods
                          .convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
                              locationLatLng, context)
                      : await CommonMethods
                          .convertGeoGraphicCoOrdinatesIntoHumanReadableAddressForDropOffLocation(
                              locationLatLng, context);

                  if (!mounted) {
                    return;
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Aceptar y regresar",
                  style: TextStyle(
                    fontFamily: "QuicksandBold",
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
