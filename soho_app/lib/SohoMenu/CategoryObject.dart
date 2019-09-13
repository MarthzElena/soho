import 'dart:core';
import 'package:flutter/material.dart';

class CategoryObject {
  static String keyName = "name";
  static String keySquareId = "squareID";
  static String keyImage = "image";
  static String keySubtitle = "subtitle";

  /// String for category  name on Square (used for filtered search)
  String name = "";

  /// Image for category  on carousel
  Image image;

  /// Category  Square ID
  String squareID = "";

  /// Subtitle for Category
  String subtitle = "";

  /// Name and SquareID Constructor
  CategoryObject(this.name, this.squareID);

  CategoryObject.fromJson(Map<String, dynamic> json)
      : name = json[keyName],
      squareID = json[keySquareId],
      image = json[keyImage],
      subtitle = json[keySubtitle];

  Map<String, dynamic> toJson() =>
      {
        keyName : name,
        keySquareId : squareID,
        keyImage : image,
        keySubtitle : subtitle
      };
}