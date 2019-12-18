import 'dart:core';

import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class SohoOrderItem {
  static const String keyProductName = "product_name";
  static const String keyCategoryId = "category_id";
  static const String keyCategoryName = "category_name";
  static const String keyProductId = "product_id";
  static const String keyProductPrice = "product_price";
  static const String keyProductVariations = "product_variations";
  static const String keyLocationId = "location_id";
  static const String keyFromState = "from_state";
  static const String keyPhotoUrl = "photo_url";

  /// String for product name on Square
  String name = "";
  String photoUrl = "";

  /// Square ID for the products category and name
  String categoryID = "";
  String categoryName = "";

  /// Product Square ID
  String productID = "";

  /// Product final price (includes selected variations)
  double price = 0.0;

  /// Value needed for updating inventory - from_state
  String fromState = "";
  /// Value needed for updating inventory - location_id
  String locationId = "";

  /// Available variations by subcategory
  List<VariationTypeObject> productVariations = List<VariationTypeObject>();

  SohoOrderItem(this.name, this.photoUrl, this.categoryID, this.categoryName, this.productID, this.price, this.fromState, this.locationId);

  void addVariations(Map<String, List<VariationItemObject>> items) {
    // First check if variation type is already included
    for (var variationName in items.keys) {
      VariationTypeObject variationType = VariationTypeObject(variationName);
      variationType.variations = items[variationName];

      productVariations.add(variationType);
    }
  }

  Map<String, dynamic> getJson() {
    var dict = Map<String, dynamic>();
    dict[keyProductName] = name;
    dict[keyPhotoUrl] = photoUrl;
    dict[keyCategoryId] = categoryID;
    dict[keyCategoryName] = categoryName;
    dict[keyProductId] = productID;
    dict[keyProductPrice] = price;
    dict[keyFromState] = fromState;
    dict[keyLocationId] = locationId;
    var productsArray = [];
    for (var variation in productVariations) {
      productsArray.add(variation.getJson());
    }
    dict[keyProductVariations] = productsArray;
    return dict;
  }

  SohoOrderItem.fromJson(Map<dynamic, dynamic> json) {
    name = json[keyProductName];
    photoUrl = json[keyPhotoUrl];
    categoryID = json[keyCategoryId];
    categoryName = json[keyCategoryName];
    productID = json[keyProductId];
    price = json[keyProductPrice] + 0.0;
    locationId = json[keyLocationId];
    fromState = json[keyFromState];
    if (json[keyProductVariations] != null) {
      var productsArray = json[keyProductVariations];
      for (var product in productsArray) {
        productVariations.add(VariationTypeObject.fromJson(product));
      }
    }
  }

}