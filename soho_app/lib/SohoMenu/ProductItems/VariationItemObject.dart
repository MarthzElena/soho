import 'dart:core';

class VariationTypeObject {
  static String keyIsRequired = "isRequired";
  static String keyTypeName = "typeName";
  static String keyVariations = "variations";

  VariationTypeObject(this.variationTypeName);

  /// String for subcategory name
  String variationTypeName = "";

  /// Available product variations on Square
  List<VariationItemObject> variations = List<VariationItemObject>();

  Map<String, dynamic> getJson() {
    var dict = Map<String, dynamic>();
    dict[keyTypeName] = variationTypeName;
    var variationsArray = [];
    for (var item in variations) {
      variationsArray.add(item.toJson());
    }
    dict[keyVariations] = variationsArray;
    return dict;
  }

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