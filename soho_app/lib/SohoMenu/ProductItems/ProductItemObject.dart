import 'dart:core';
import 'package:flutter/material.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class ProductItemObject {
  static String keyName = "name";
  static String keySquareId = "squareID";
  static String keyImageUrl = "image";
  static String keyDescription = "description";
  static String keyPrice = "price";
  static String keyVariations = "variations";

  /// String for product name on Square
  String name = "";

  /// Product Square ID
  String squareID = "";

  /// Product Image
  String imageUrl;

  /// Product description on Square
  String description = "";

  /// Product regular price on Square
  double price = 0.0;

  /// Available variations by subcategory
  List<VariationTypeObject> productVariations = List<VariationTypeObject>();

  ProductItemObject(this.name, this.squareID);

  Future<void> addProductVariation(VariationItemObject variation, String variationType) async {
    var elementAdded = false;
    for (var element in productVariations) {
      if (element.variationTypeName.compareTo(variationType) == 0) {
        // Add element
        element.variations.add(variation);
        elementAdded = true;
        return;
      }
    }
    // Check if element was added
    if (!elementAdded) {
      // Variation type is new
      VariationTypeObject newVariation = VariationTypeObject();
      newVariation.variationTypeName = variationType;
      newVariation.variations.add(variation);
      productVariations.add(newVariation);
    }
  }

  ProductItemObject.fromJson(Map<String, dynamic> json)
  : name = json[keyName],
  squareID = json[keySquareId],
  description = json[keyDescription],
  price = json[keyPrice];

  Map<String, dynamic> toJson() =>
      {
        keyName : name,
        keySquareId : squareID,
        keyDescription : description,
        keyPrice : price
      };

}