class PredictionsModel {
  String? placeId;
  String? mainText;
  String? secondaryText;

  PredictionsModel({this.placeId, this.mainText, this.secondaryText});

  PredictionsModel.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"];
    mainText = json["structured_formatting"]["main_text"];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}
