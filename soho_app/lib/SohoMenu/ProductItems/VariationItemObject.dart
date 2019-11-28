import 'dart:core';

class VariationTypeObject {
  static String keyIsRequired = "isRequired";
  static String keyTypeName = "typeName";
  static String keyVariations = "variations";

  /// String for subcategory name
  String variationTypeName = "";

  /// Available product variations on Square
  List<VariationItemObject> variations = List<VariationItemObject>();

  VariationTypeObject(this.variationTypeName);

  VariationTypeObject.fromJson(Map<String, dynamic> json)
  : variationTypeName = json[keyTypeName],
        variations = json[keyVariations];

  Map<String, dynamic> toJson() =>
      {
        keyTypeName : variationTypeName,
        keyVariations : variations
      };
}

class VariationItemObject {
  static String keyName = "name";
  static String keySquareId = "squareID";
  static String keyPrice = "price";

  /// String for variation name on Square
  String name = "";

  /// Variation Square ID
  String squareID = "";

  /// Price value
  double price = 0.0;

  VariationItemObject(this.name, this.squareID, this.price);

  VariationItemObject.fromJson(Map<String, dynamic> json)
  : name = json[keyName],
  squareID = json[keySquareId],
  price = json[keyPrice];

  Map<String, dynamic> toJson() =>
      {
        keyName : name,
        keySquareId : squareID,
        keyPrice : price
      };
}