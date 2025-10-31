import 'package:flutter/material.dart';
import 'package:unl_race/models/address_model.dart';

class Rates {
  String? id;
  String? name;
  double? km;
  double? min;
  int? seating;
  int? commission;
  double? basePrice;
  double? kmRestriction;

  Rates({
    this.id,
    this.name,
    this.km,
    this.min,
    this.seating,
    this.commission,
    this.basePrice,
    this.kmRestriction,
  });
}

class AppInfo extends ChangeNotifier {
  AddressModel? pickUpLocation;
  AddressModel? dropOffLocation;
  double tripCalificationDriver = 3.0;
  bool statusPlaceSelectedDropOff = false;
  bool isWriting = false;

  updateIsWriting(bool status) {
    isWriting = status;
    notifyListeners();
  }

  updateStatusPlaceSelectedDropOff(bool status) {
    statusPlaceSelectedDropOff = status;
    notifyListeners();
  }

  void updatePickUpLocation(AddressModel pickUpModel) {
    pickUpLocation = pickUpModel;
    notifyListeners();
  }

  void updateDropOffLocation(AddressModel droOffModel) {
    dropOffLocation = droOffModel;
    notifyListeners();
  }

  updateTripCalificationDriver(double calification) {
    tripCalificationDriver = calification;
    notifyListeners();
  }
}
