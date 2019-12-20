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

  VariationTypeObject.fromJson(Map<dynamic, dynamic> json) {
    variationTypeName = json[keyTypeName];
    if (json[keyVariations] != null) {
      var variationsArray = json[keyVariations];
      for (var item in variationsArray) {
        variations.add(VariationItemObject.fromJson(item));
      }
    }
  }
}

class VariationItemObject {
  static String keyName = "name";
  static String keySquareId = "squareID";
  static String keyPrice = "price";
  static String keyLocationId = "locationId";
  static String keyFromState = "fromState";

  /// String for variation name on Square
  String name = "";

  /// Variation Square ID
  String squareID = "";

  /// Price value
  double price = 0.0;

  /// Value needed for updating inventory - from_state
  String fromState = "";
  /// Value needed for updating inventory - location_id
  String locationId = "";

  VariationItemObject(this.name, this.squareID, this.price);

  VariationItemObject.fromJson(Map<dynamic, dynamic> json):
        name = json[keyName],
        squareID = json[keySquareId],
        fromState = json[keyFromState],
        locationId = json[keyLocationId],
        price = json[keyPrice] + 0.0;

  Map<String, dynamic> toJson() =>
      {
        keyName : name,
        keySquareId : squareID,
        keyPrice : price,
        keyFromState : fromState,
        keyLocationId : locationId
      };
}