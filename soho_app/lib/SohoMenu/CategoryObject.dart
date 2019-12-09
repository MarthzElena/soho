import 'dart:core';

class CategoryObject {
  static String keyName = "name";
  static String keySquareId = "squareID";
  static String keyImageUrl = "image";
  static String keySubtitle = "subtitle";

  /// String for category  name on Square (used for filtered search)
  String name = "";

  /// URL Image for category on carousel
  String imageUrl;

  /// Category  Square ID
  String squareID = "";

  /// Subtitle for Category
  String subtitle = "";

  /// Name and SquareID Constructor
  CategoryObject(this.name, this.squareID);

  CategoryObject.fromJson(Map<String, dynamic> json)
      : name = json[keyName],
      squareID = json[keySquareId],
      imageUrl = json[keyImageUrl],
      subtitle = json[keySubtitle];

  Map<String, dynamic> toJson() =>
      {
        keyName : name,
        keySquareId : squareID,
        keyImageUrl : imageUrl,
        keySubtitle : subtitle
      };
}