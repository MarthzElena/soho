import 'dart:convert';
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
  static String keyLocationId = "locationId";
  static String keyFromState = "fromState";

  // Constants for Category names
  final String _categoryCoffee = "coffee";
  final String _categoryTea = "tea";
  final String _categoryDesayunos = "desayunos";
  final String _categoryComidasCenas = "comidas y cenas";
  final String _categoryAltaReposteria = "alta repostería";
  final String _categoryBebidasCocteles = "bebidas y cócteles";
  final String _categoryOtros = "otros";

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

  /// Value needed for updating inventory - from_state
  String fromState = "";
  /// Value needed for updating inventory - location_id
  String locationId = "";

  /// Available variations by subcategory
  List<VariationTypeObject> productVariations = List<VariationTypeObject>();

  ProductItemObject({String nameAndSubCategory, String categoryName}) {
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

  /// Defines whether the variation list for this object will be REQUIRED or OPTIONAL
  /// TODO! Update this with FINAL values
  bool isVariationsRequired() {
    if (category.toLowerCase().startsWith(_categoryCoffee)) {
      return true;
    } else if (category.toLowerCase().startsWith(_categoryTea)) {
      return true;
    } else if (category.toLowerCase().startsWith(_categoryDesayunos)) {
      return false;
    } else if (category.toLowerCase().startsWith(_categoryComidasCenas)) {
      return false;
    } else if (category.toLowerCase().startsWith(_categoryAltaReposteria)) {
      return false;
    } else if (category.toLowerCase().startsWith(_categoryBebidasCocteles)) {
      return false;
    } else if (category.toLowerCase().startsWith(_categoryOtros)) {
      return false;
    } else {
      return false;
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
      VariationTypeObject newVariation = VariationTypeObject(variationType);
      newVariation.variations.add(variation);
      productVariations.add(newVariation);
    }
  }

  ProductItemObject.fromJson(Map<String, dynamic> json) {
    name = json[keyName];
    category = json[keyCategory];
    subcategory = json[keySubcategory];
    imageUrl = json[keyImageUrl];
    squareID = json[keySquareId];
    description = json[keyDescription];
    price = json[keyPrice];
    locationId = json[keyLocationId];
    fromState = json[keyFromState];
    productVariations = json[keyVariations];
  }

  Map<String, dynamic> toJson() =>
      {
        keyName : name,
        keyCategory : category,
        keySubcategory : subcategory,
        keyImageUrl : imageUrl,
        keySquareId : squareID,
        keyDescription : description,
        keyPrice : price,
        keyVariations : productVariations,
        keyLocationId : locationId,
        keyFromState : fromState
      };

}