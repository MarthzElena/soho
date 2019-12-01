import 'dart:core';

import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class SohoOrderItem {

  /// String for product name on Square
  String name = "";

  /// Square ID for the products category
  String categoryID = "";

  /// Product Square ID
  String squareID = "";

  /// Product final price (includes selected variations)
  double price = 0.0;

  /// Available variations by subcategory
  List<VariationTypeObject> productVariations = List<VariationTypeObject>();

  SohoOrderItem(this.name, this.categoryID, this.squareID, this.price);

  void addVariations(Map<String, List<VariationItemObject>> items) {
    // First check if variation type is already included
    for (var variationName in items.keys) {
      VariationTypeObject variationType = VariationTypeObject(variationName);
      variationType.variations = items[variationName];
    }
  }

}