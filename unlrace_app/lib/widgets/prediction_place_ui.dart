import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unlrace_app/appInfo/app_info.dart';
import 'package:unlrace_app/global/global_var.dart';
import 'package:unlrace_app/methods/common_methods.dart';
import 'package:unlrace_app/models/address_model.dart';
import 'package:unlrace_app/models/predictions_model.dart';
import 'package:unlrace_app/providers/trip_provider.dart';
import 'package:unlrace_app/widgets/loading_dialog.dart';

class PredictionPlaceUI extends StatefulWidget {
  final PredictionsModel? predictedPlaceData;

  const PredictionPlaceUI({super.key, this.predictedPlaceData});

  @override
  State<PredictionPlaceUI> createState() => _PredictionPlacesUIState();
}

class _PredictionPlacesUIState extends State<PredictionPlaceUI> {
  /// Place Details - Places API
  fetchClickedPlaceDetails(String placeID) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const LoadingDialog(messageText: "Obteniendo detalles...");
      },
    );

    String urlPlaceDetailsAPI =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$googleMapKey";

    var responseFromPlacesDetailsAPI =
        await CommonMethods.sendRequestToAPI(urlPlaceDetailsAPI);

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);

    if (responseFromPlacesDetailsAPI == "error") {
      return;
    }

    if (responseFromPlacesDetailsAPI["status"] == "OK") {
      AddressModel dropOffLocation = AddressModel();

      dropOffLocation.placeName =
          responseFromPlacesDetailsAPI["result"]["name"];
      dropOffLocation.latitudePosition =
          responseFromPlacesDetailsAPI["result"]["geometry"]["location"]["lat"];
      dropOffLocation.longitudePosition =
          responseFromPlacesDetailsAPI["result"]["geometry"]["location"]["lng"];
      dropOffLocation.placeID = placeID;
      dropOffLocation.humanReadableAddress =
          responseFromPlacesDetailsAPI["result"]["formatted_address"];
      context.read<AppInfo>().updateDropOffLocation(dropOffLocation);

      context.read<AppInfo>().updateStatusPlaceSelectedDropOff(true);

      context.read<AppInfo>().updateIsWriting(false);

      // Go to the previus page

      //Navigator.pop(context, "placeSelected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fetchClickedPlaceDetails(widget.predictedPlaceData!.placeId!);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.share_location,
                color: Colors.grey,
              ),
              const SizedBox(width: 13),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.predictedPlaceData!.mainText ?? "",
                    style: const TextStyle(
                      fontFamily: 'QuicksandBold',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.predictedPlaceData!.secondaryText ?? "",
                    style: const TextStyle(
                      fontFamily: 'QuicksandBold',
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
