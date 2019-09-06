import 'package:flutter/material.dart';

class CategoryObject {
  /// String for category  name on Square (used for filtered search)
  String name = "";

  /// Image for category  on carousel
  Image image;

  /// Category  Square ID
  String squareID = "";

  /// Subtitle for Category
  String subtitle = "";

  CategoryObject(String name, String squareId) {
    this.name = name;
    this.squareID = squareId;
  }
}