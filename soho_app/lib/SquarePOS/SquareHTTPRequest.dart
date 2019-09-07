import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:soho_app/SohoMenu/CategoryObject.dart';

class SquareHTTPRequest {

  static const _token = "EAAAEOjIOtjeZhu3M35n3uhYp4iQCBfOxfseiRthdNaFzS9o4P99IW48fP6uTEcZ";
  static const _location = "NQ95EVXZF402W";

  // Request URL
  static const _squareHost = "https://connect.squareup.com/v2/";
  static const _catalog = "catalog/";
  static const _search = "search";
  static const _inventory = "inventory/";
  static const _list = "list?";
  static const _types = "types=";
  static const _categoryParam = "CATEGORY";
  static const _itemParam = "ITEM";
  static var _requestHeader = {
    HttpHeaders.acceptHeader : "application/json",
    HttpHeaders.contentTypeHeader : "application/x-www-form-urlencoded",
    HttpHeaders.authorizationHeader : "Bearer $_token",
    HttpHeaders.acceptEncodingHeader : "gzip, deflate"
  };

  /// Returns a list with the CategoryObject items to populate the Category carousel in HomePageWidget
  static Future<List<CategoryObject>> getSquareCategories() async {
    // Init empty list to save the categories
    List<CategoryObject> categoryList = new List<CategoryObject>();
    // Get categories from API
    var categoriesHost = _squareHost + _catalog + _list + _types + _categoryParam;
    var categoriesResponse = await http.get(categoriesHost, headers: _requestHeader);
    var jsonCategories = json.decode(categoriesResponse.body);
    var categoryObjects = List.from(jsonCategories["objects"]);
    // Loop categories to get each category info
    for (var item in categoryObjects) {
      var categoryId = item["id"];
      var categoryData = item["category_data"];
      var categoryString = categoryData["name"].toString();
      var categoryName = categoryString;

      // Create the category item
      CategoryObject categoryObject = CategoryObject(categoryName, categoryId);
      // Request each category items
      var categorySearchArrayResult = await getItemsForCategory(categoryId);
      for (var categoryItem in categorySearchArrayResult) {
        var itemData = categoryItem["item_data"];
        var variationsList = List.from(itemData["variations"]);
        // The category info ITEM  has  only ONE VARIATION
        if (variationsList.length == 1) {
          var info = variationsList.first;
          // The category info ITEM price is variable
          var variationData = info["item_variation_data"];
          var pricing = variationData["pricing_type"];
          if (pricing == "VARIABLE_PRICING") {
            // Use item name as subtitle value
            var subtitle = itemData["name"].toString();
            categoryObject.subtitle = subtitle;
          }
        }
      }
      // Add category object to list
      categoryList.add(categoryObject);
    }

    // Once list is full, return the values
    return categoryList;

  }

  /// Request to get all the items in a specific category
  /// PARAMS:
  /// - String categoryID - String  ID for category given by  SQUARE
  static Future<List<dynamic>> getItemsForCategory(String categoryId) async {
    var itemsInCategoryHost = _squareHost + _catalog + _search;
    var request = await http.post(itemsInCategoryHost, body: _buildSearchRequestBody(categoryId), headers: _requestHeader);
    var jsonCategorySearch = json.decode(request.body);
    return List.from(jsonCategorySearch["objects"]);
  }

  /// Builds a String with the body for the getItemsForCategory(categoryID) request
  /// PARAMS:
  /// - categoryId - String  ID for category given by  SQUARE
  static String _buildSearchRequestBody(String categoryId) {
    return jsonEncode({"object_types": ["ITEM"],"query": {"prefix_query": {"attribute_name": "category_id","attribute_prefix": "$categoryId"}},"limit": 100});
  }



}