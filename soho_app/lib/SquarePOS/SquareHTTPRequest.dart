import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemObject.dart';
import 'dart:convert';

import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

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
    HttpHeaders.contentTypeHeader : "application/json; charset=utf-8",
    HttpHeaders.authorizationHeader : "Bearer $_token",
    HttpHeaders.acceptEncodingHeader : "gzip, deflate"
  };

  /// Returns a list with the CategoryObject items to populate the Category carousel in HomePageWidget
  static Future<List<CategoryObject>> getSquareCategories() async {
    // Init empty list to save the categories
    List<CategoryObject> categoryList = new List<CategoryObject>();
    // Get categories from API
    var categoriesHost = _squareHost + _catalog + _list + _types + _categoryParam;
    var categoriesResponse = await http.get(categoriesHost, headers: _requestHeader).catchError((error) {
      var socketError = error as SocketException;
      if (socketError != null) {
        // TODO: Show no internet connection error
      }
    });
    var jsonCategories = json.decode(utf8.decode(categoriesResponse.bodyBytes));
    var categoryObjects = List.from(jsonCategories["objects"]);
    // Loop categories to get each category info
    for (var item in categoryObjects) {
      var categoryId = item["id"];
      var categoryData = item["category_data"];
      var categoryString = categoryData["name"].toString();
      // Parse category Name and Subtitle
      var categoryArray = categoryString.split("-");
      var categoryName = categoryString;
      var categorySubtitle = "";
      // Make sure array is expected size
      if (categoryArray.length == 2) {
        categoryName = categoryArray[0];
        categorySubtitle = categoryArray[1];
      }
      // Create the category item
      CategoryObject categoryObject = CategoryObject(categoryName, categoryId);
      categoryObject.subtitle = categorySubtitle;

      // Request each category items to get the image
      var categorySearchArrayResult = await getItemsForCategory(categoryId);
      for (var categoryItem in categorySearchArrayResult) {
        var itemData = categoryItem["item_data"];
        var itemName = itemData["name"].toString();
        if (itemName.compareTo("foto") == 0) {
          var imageURL = itemData["image_url"].toString();
          // TODO: image URL is breaking the route with parameter!!
          //categoryObject.imageUrl = imageURL;
        }
      }

      // Add category object to list
      categoryList.add(categoryObject);
    }

    // Once list is full, return the values
    return categoryList;

  }

  /// Return a list of CategoryItemObjects to populate the category detail view
  ///
  ///
  static Future<CategoryItemObject> getCategoryDetail(String categoryId) async {
    // Init empty list for result
    CategoryItemObject categoryDetails = CategoryItemObject();
    var categorySearchArrayResult = await getItemsForCategory(categoryId);
    for (var categoryItem in categorySearchArrayResult) {
      // ProductItemObject ID
      var productId = categoryItem["id"].toString();
      //  Get item_data
      var itemData = categoryItem["item_data"];
      var productName = itemData["name"].toString();
      // Create ProductItemObject
      var productItemObject = ProductItemObject(productName, productId);
      // TODO: Add AVAILABLE inventory check!
      // Ignore "foto" items
      if (productName.compareTo("foto") != 0) {
        // Attempt to get subcategory, if none is found item WON'T have subcategory
        var descriptionDetailsObject = json.decode(itemData["description"]);
        var productSubcategory = descriptionDetailsObject["subcategoria"] == null ? "" : descriptionDetailsObject["subcategoria"].toString();
        // Add missing details to ProductItemObject
        productItemObject.description = descriptionDetailsObject["descripcion"] == null ? "" : descriptionDetailsObject["descripcion"];
        productItemObject.imageUrl = itemData["image_url"] == null ? "" : itemData["image_url"].toString();
        // Get variations
        var variationsArray = itemData["variations"];
        for (var variationItem in variationsArray) {
          var variationId = variationItem["id"];
          // Check if variation is Regular
          var variationData = variationItem["item_variation_data"];
          var variationNameArray = variationData["name"].toString().split("-");
          if (variationNameArray.length == 1) {
            // Add regular price to ProductItemObject
            var priceMoney = variationData["price_money"];
            var priceValue = priceMoney["amount"];
            // Remove decimal 0's (bad square parsing)
            priceValue = priceValue/100;
            // Save price
            productItemObject.price = priceValue;
          } else if (variationNameArray.length == 2){
            // Item is variation
            var variationName = variationNameArray[0];
            var variationType = variationNameArray[1];
            // Get variation price
            var priceMoney = variationData["price_money"];
            var priceValue = priceMoney["amount"];
            // Remove decimal 0's (bad square parsing)
            priceValue = priceValue/100;
            // Create VariationItemObject
            var variationItem = VariationItemObject(variationName, variationId, priceValue);
            // Add variation to product
            await productItemObject.addProductVariation(variationItem, variationType);
          }
        }
        // Add product to categoryDetails
        await categoryDetails.addProductItem(productItemObject, productSubcategory);
      }

    }

    return categoryDetails;
  }

  /// Request to get all the items in a specific category
  /// PARAMS:
  /// - String categoryID - String  ID for category given by  SQUARE
  static Future<List<dynamic>> getItemsForCategory(String categoryId) async {
    var itemsInCategoryHost = _squareHost + _catalog + _search;
    var request = await http.post(itemsInCategoryHost, body: _buildSearchRequestBody(categoryId), headers: _requestHeader);
    var jsonCategorySearch = json.decode(utf8.decode(request.bodyBytes));
    var objects = jsonCategorySearch["objects"];
    return objects == null ? List() : List.from(objects);
  }

  /// Builds a String with the body for the getItemsForCategory(categoryID) request
  /// PARAMS:
  /// - categoryId - String  ID for category given by  SQUARE
  static String _buildSearchRequestBody(String categoryId) {
    return jsonEncode({"object_types": ["ITEM"],"query": {"prefix_query": {"attribute_name": "category_id","attribute_prefix": "$categoryId"}},"limit": 100});
  }



}