import 'dart:core';
import 'package:flutter/material.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class ProductItemObject {
  static String keyName = "name";
  static String keyCategory = "category";
  static String keySubcategory = "subcategory";
  static String keySquareId = "squareID";
  static String keyImageUrl = "image";
  static String keyDescription = "description";
  static String keyPrice = "price";
  static String keyVariations = "variations";

  /// String for product name on Square
  String name = "";

  /// String for product category on Square
  String category = "";

  /// String for product subcategory on Square
  String subcategory = "";

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

  ProductItemObject({String nameAndSubCategory, String itemID, String categoryName}) {
    this.squareID = itemID;
    this.category = categoryName;

    // Set product name and subcategory
    var nameArray = nameAndSubCategory.split("-");
    if (nameArray.length == 2) {
      // Product has subcategory
      this.name = nameArray[0];
      this.subcategory = nameArray[1];
    } else {
      // Product has no category or value is wrong
      // Use name AS IS and leave subcategory empty
      this.name = nameAndSubCategory;
    }
  }

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
  category = json[keyCategory],
  subcategory = json[keySubcategory],
  squareID = json[keySquareId],
  description = json[keyDescription],
  price = json[keyPrice];

  Map<String, dynamic> toJson() =>
      {
        keyName : name,
        keyCategory : category,
        keySubcategory : subcategory,
        keySquareId : squareID,
        keyDescription : description,
        keyPrice : price
      };

}