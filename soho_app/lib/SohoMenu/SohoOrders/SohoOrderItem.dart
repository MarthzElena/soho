import 'dart:core';

import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class SohoOrderItem {
  static const keyProductName = "product_name";
  static const keyCategoryId = "category_id";
  static const keyProductId = "product_id";
  static const keyProductPrice = "product_price";
  static const keyProductVariations = "product_variations";

  /// String for product name on Square
  String name = "";

  /// Square ID for the products category
  String categoryID = "";

  /// Product Square ID
  String productID = "";

  /// Product final price (includes selected variations)
  double price = 0.0;

  /// Available variations by subcategory
  List<VariationTypeObject> productVariations = List<VariationTypeObject>();

  SohoOrderItem(this.name, this.categoryID, this.productID, this.price);

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
    dict[keyCategoryId] = categoryID;
    dict[keyProductId] = productID;
    dict[keyProductPrice] = price;
    var productsArray = [];
    for (var variation in productVariations) {
      productsArray.add(variation.getJson());
    }
    dict[keyProductVariations] = productsArray;
    return dict;
  }

  SohoOrderItem.fromJson(Map<String, dynamic> json)
  : name = json[keyProductName],
  categoryID = json[keyCategoryId],
  productID = json[keyProductId],
  price = json[keyProductPrice],
  productVariations = json[keyProductVariations];

  Map<String, dynamic> toJson() =>
      {
        keyProductName : name,
        keyCategoryId : categoryID,
        keyProductId : productID,
        keyProductPrice : price,
        keyProductVariations : productVariations
      };

}