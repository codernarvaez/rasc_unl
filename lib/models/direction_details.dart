class DirectionDetails {
  String? distanceTextString;
  String? durationTextString;
  int? distanceValueDigits;
  int? durationValueDigits;
  String? encodedPoints;

  DirectionDetails(
      {this.distanceTextString,
      this.durationTextString,
      this.distanceValueDigits,
      this.durationValueDigits,
      this.encodedPoints});

  DirectionDetails.fromJson(Map<String, dynamic> json) {
    distanceTextString = json[""];
    durationTextString = json[""];
    distanceValueDigits = json[""];
    durationValueDigits = json[""];
    encodedPoints = json[""];
  }
}
