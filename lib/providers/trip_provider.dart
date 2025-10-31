import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unl_race/models/direction_details.dart';

class TripProvider extends ChangeNotifier {
  String? tripID;
  String nameDriver = "";
  String photoDriver = "";
  String? phoneNumberDriver = "";
  int requestTimeOutDriver = 30;
  String status = "";
  String carDetailsDriver = "";
  String driverCarPhoto = "";
  String driverRating = "0.0";
  String tripStatusDisplay = "La conductora está llegando";
  String stateOfApp = "normal";
  LatLng? pickUpGeoGraphicsCoOrdenates;
  LatLng? dropOffDestinationGeoGraphicsCoOrdenates;
  DirectionDetails? tripDirectionDetailsInfo;
  int? selectedOption;
  int? selectedPaymentOption;
  String pickUpAddress = "";
  String dropOffAddress = "";

  setDropOffAddress(String dddress) async {
    dropOffAddress = dddress;
    notifyListeners();
  }

  getDropOffAddress() async {
    return dropOffAddress;
  }

  setPickUpAddress(String pddress) async {
    pickUpAddress = pddress;
    notifyListeners();
  }

  getPickUpAddress() async {
    return pickUpAddress;
  }

  setSelectedPaymentOption(int selectedPayment) async {
    selectedPaymentOption = selectedPayment;
    notifyListeners();
  }

  getSetSelectedPaymentOption() async {
    return selectedPaymentOption;
  }

  setSelectedOption(int selectedOpt) async {
    selectedOption = selectedOpt;
    notifyListeners();
  }

  getSelectedOption() async {
    return selectedOption;
  }

  setTripID(String tripId) async {
    tripID = tripId;
    notifyListeners();
  }

  getTripID() async {
    return tripID;
  }

  setStatus(String status) async {
    status = status;
    notifyListeners();
  }

  getStatus() async {
    return status;
  }

  setTripStatusDisplay(String tripStatus) async {
    tripStatusDisplay = tripStatus;
    notifyListeners();
  }

  getTripStatusDisplay() async {
    return tripStatusDisplay;
  }

  setDriverRating(String driverRat) async {
    driverRating = driverRat;
    notifyListeners();
  }

  getDriverRating() async {
    return driverRating;
  }

  setDriverCarPhoto(String driverPhoto) async {
    driverCarPhoto = driverPhoto;
    notifyListeners();
  }

  getDriverCarPhoto() async {
    return driverCarPhoto;
  }

  setCarDetailsDriver(String carDetails) async {
    carDetailsDriver = carDetails;
    notifyListeners();
  }

  getCarDetailsDriver() async {
    return carDetailsDriver;
  }

  setPhoneNumberDriver(String phoneNumber) async {
    phoneNumberDriver = phoneNumber;
    notifyListeners();
  }

  getPhoneNumberDriver() async {
    return phoneNumberDriver;
  }

  setPhotoDriver(String photo) async {
    photoDriver = photo;
    notifyListeners();
  }

  getPhotoDriver() async {
    return photoDriver;
  }

  setNameDriver(String name) async {
    nameDriver = name;
    notifyListeners();
  }

  getNameDriver() async {
    return nameDriver;
  }

  setTripDirectionDetailsInfo(DirectionDetails tripDirectionDetails) async {
    tripDirectionDetailsInfo = tripDirectionDetails;
    notifyListeners();
  }

  getTripDirectionDetailsInfo() async {
    return tripDirectionDetailsInfo;
  }

  setDropOffDestinationGeoGraphicsCoOrdenates(LatLng dropOffDestination) async {
    dropOffDestinationGeoGraphicsCoOrdenates = dropOffDestination;
    notifyListeners();
  }

  getDropOffDestinationGeoGraphicsCoOrdenates() async {
    return dropOffDestinationGeoGraphicsCoOrdenates;
  }

  setPickUpGeoGraphicsCoOrdenates(LatLng pickUpCoOrdenates) async {
    pickUpGeoGraphicsCoOrdenates = pickUpCoOrdenates;
    notifyListeners();
  }

  getPickUpGeoGraphicsCoOrdenates() async {
    return pickUpGeoGraphicsCoOrdenates;
  }

  setStateOfApp(String state) async {
    stateOfApp = state;
    notifyListeners();
  }

  getStateOfApp() async {
    return stateOfApp;
  }

  resetApp() async {
    tripID = null;
    nameDriver = "";
    photoDriver = "";
    phoneNumberDriver = "";
    requestTimeOutDriver = 30;
    status = "";
    carDetailsDriver = "";
    driverCarPhoto = "";
    driverRating = "0.0";
    tripStatusDisplay = "La conductora está llegando";
    stateOfApp = "normal";
    selectedOption = null;
    selectedPaymentOption = null;
    pickUpAddress = "";
    dropOffAddress = "";

    notifyListeners();
  }
}
