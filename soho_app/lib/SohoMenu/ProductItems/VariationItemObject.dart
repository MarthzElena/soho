import 'dart:core';
import 'package:flutter/material.dart';

class VariationTypeObject {

  /// String for subcategory name
  String variationTypeName = "";

  /// Available product variations on Square
  List<VariationItemObject> variations = List<VariationItemObject>();
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