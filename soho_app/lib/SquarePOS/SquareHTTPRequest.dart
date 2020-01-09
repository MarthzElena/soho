import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemObject.dart';
import 'dart:convert';

import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:uuid/uuid.dart';

class SquareHTTPRequest {

  static const _token = "EAAAEOjIOtjeZhu3M35n3uhYp4iQCBfOxfseiRthdNaFzS9o4P99IW48fP6uTEcZ";
  static const _location = "NQ95EVXZF402W";

  // Request URL
  static const _squareHost = "https://connect.squareup.com/v2/";
  static const _catalog = "catalog/";
  static const _search = "search";
  static const _inventory = "inventory/";
  static const _batchChange = "batch-change";
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
        print("Categories request ERROR");
        print(socketError);
      }
    });
    // Return empty array if response fails
    if (categoriesResponse == null) {
      return List();
    }
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
      var categorySearchArrayResult = await _getItemsForCategory(categoryId);
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
  static Future<CategoryItemObject> getCategoryDetail(String categoryId, String categoryName) async {
    // Init empty list for result

    var categorySearchArrayResult = await _getItemsForCategory(categoryId);
    var categoryDetails = await _parseCategoryElementsResult(categorySearchArrayResult, categoryName);

    // Make sure items have correct order before returning
    var orderedCategoryDetails = await _orderCategoryItems(categoryDetails);

    return orderedCategoryDetails;
  }

  /// Parses the result of a Search query from different categories
  static Future<List<SubcategoryItems>> _parseSearchResult(List<dynamic> searchResult) async {
    List<SubcategoryItems> result = List<SubcategoryItems>();
    for (var searchItem in searchResult) {
      //  Get item_data
      var itemData = searchItem["item_data"];
      var productName = itemData["name"].toString();
      // Get category name
      // Get category name by ID
      var categoryId = itemData["category_id"].toString();
      var categoryName = "";
      for (var item in Application.sohoCategories) {
        if (item.squareID == categoryId) {
          categoryName = item.name;
          break;
        }
      }
      // Create ProductItemObject
      var productItemObject = ProductItemObject(nameAndSubCategory: productName, categoryName: categoryName);
      // Ignore "foto" items
      if (productName.compareTo("foto") != 0) {
        // Add missing details to ProductItemObject
        productItemObject.description = itemData["description"] == null ? "" : itemData["description"];
        productItemObject.imageUrl = itemData["image_url"] == null ? "" : itemData["image_url"].toString();
        // Get variations
        var variationsArray = itemData["variations"];
        for (var variationItem in variationsArray) {
          var variationId = variationItem["id"];
          // Check if variation is REGULAR
          var variationData = variationItem["item_variation_data"];
          var variationNameArray = variationData["name"].toString().split("-");
          if (variationNameArray.length == 1) {
            // Add PRODUCT ID
            productItemObject.squareID = variationId;
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
            // Only add variation to product if Inventory is available
            var updatedVariation = await _isVariationAvailable(variation: variationItem);
            if (updatedVariation != null) {
              await productItemObject.addProductVariation(updatedVariation, variationType);
            }
          }
        }
        // Add product to categoryDetails
        var updatedProduct = await _isProductAvailable(product: productItemObject);
        if (updatedProduct != null) {
          SubcategoryItems newSubcategory = SubcategoryItems();
          newSubcategory.subcategoryName = updatedProduct.subcategory;
          newSubcategory.items.add(updatedProduct);
          result.add(newSubcategory);
        }
      }
    }
    return result;
  }

  /// Parses the result of a search query, from the same category
  static Future<CategoryItemObject> _parseCategoryElementsResult(List<dynamic> searchResult, String categoryName) async {
    CategoryItemObject categoryDetails = CategoryItemObject();
    for (var categoryItem in searchResult) {
      //  Get item_data
      var itemData = categoryItem["item_data"];
      var productName = itemData["name"].toString();
      // Create ProductItemObject
      var productItemObject = ProductItemObject(nameAndSubCategory: productName, categoryName: categoryName);
      // Ignore "foto" items
      if (productName.compareTo("foto") != 0) {
        // Add missing details to ProductItemObject
        productItemObject.description = itemData["description"] == null ? "" : itemData["description"];
        productItemObject.imageUrl = itemData["image_url"] == null ? "" : itemData["image_url"].toString();
        // Get variations
        var variationsArray = itemData["variations"];
        for (var variationItem in variationsArray) {
          var variationId = variationItem["id"];
          // Check if variation is REGULAR
          var variationData = variationItem["item_variation_data"];
          var variationNameArray = variationData["name"].toString().split("-");
          if (variationNameArray.length == 1) {
            // Add PRODUCT ID
            productItemObject.squareID = variationId;
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
            // Only add variation to product if Inventory is available
            var updatedVariation = await _isVariationAvailable(variation: variationItem);
            if (updatedVariation != null) {
              await productItemObject.addProductVariation(updatedVariation, variationType);
            }
          }
        }
        // Add product to categoryDetails
        var updatedProduct = await _isProductAvailable(product: productItemObject);
        if (updatedProduct != null) {
          await categoryDetails.addProductItem(updatedProduct);
        }
      }
    }

    return categoryDetails;
  }

  /// Request to get all the items in a specific category
  /// PARAMS:
  /// - String categoryID - String  ID for category given by  SQUARE
  static Future<List<dynamic>> _getItemsForCategory(String categoryId) async {
    var itemsInCategoryHost = _squareHost + _catalog + _search;
    var request = await http.post(itemsInCategoryHost, body: _buildSearchItemsByCategoryRequestBody(categoryId), headers: _requestHeader);
    var jsonCategorySearch = json.decode(utf8.decode(request.bodyBytes));
    var objects = jsonCategorySearch["objects"];
    return objects == null ? List() : List.from(objects);
  }

  /// Request to search for items by NAME
  /// Returns an array of
  static Future<List<SubcategoryItems>> searchForItems(String query) async {
    var searchHost = _squareHost + _catalog + _search;
    var request = await http.post(searchHost, body: _builsSearchItemsByNameRequestBody(query), headers: _requestHeader);
    var jsonProductSearch = json.decode(utf8.decode(request.bodyBytes));
    var objects = jsonProductSearch["objects"];
    var searchResult = objects == null ? List() : List.from(objects);
    var parsedResult = await _parseSearchResult(searchResult);
    return parsedResult;
  }

  /// Request Variation inventory count
  /// Returns the updated variation if count is greater than 0.
  static Future<VariationItemObject> _isVariationAvailable({VariationItemObject variation}) async {
    var itemInventoryHost = _squareHost + _inventory + variation.squareID;
    var request = await http.get(itemInventoryHost, headers: _requestHeader);
    var jsonInventoryResult = json.decode(utf8.decode(request.bodyBytes));
    var countObject = jsonInventoryResult["counts"];
    if (countObject != null) {
      var countList = List.from(countObject);
      if (countList.length > 0) {
        var countItem = countList[0];
        var availability = countItem["state"]; // TODO: Check that state check is not needed
        var quantity = int.tryParse(countItem["quantity"]) ?? 0;
        if (quantity > 0) {
          // Add inventory values to variation
          variation.fromState = countItem["state"];
          variation.locationId = countItem["location_id"];
          return variation;
        }
      }
    }
    return null;
  }

  /// Request Product inventory count
  /// Returns the updatedProduct if count is greater than 0.
  static Future<ProductItemObject> _isProductAvailable({ProductItemObject product}) async {
    var itemInventoryHost = _squareHost + _inventory + product.squareID;
    var request = await http.get(itemInventoryHost, headers: _requestHeader);
    var jsonInventoryResult = json.decode(utf8.decode(request.bodyBytes));
    var countObject = jsonInventoryResult["counts"];
    if (countObject != null) {
      var countList = List.from(countObject);
      if (countList.length > 0) {
        var countItem = countList[0];
        var availability = countItem["state"]; // TODO: Check that state check is not needed
        var quantity = int.tryParse(countItem["quantity"]) ?? 0;
        if (quantity > 0) {
          // Add inventory values to variation
          product.fromState = countItem["state"];
          product.locationId = countItem["location_id"];
          return product;
        }
      }
    }
    return null;
  }

  /// Makes sure the elements without subCategory are first
  static Future<CategoryItemObject> _orderCategoryItems(CategoryItemObject item) async {
    if (item.allItems.first.subcategoryName.isEmpty) {
      // Elements already ordered
      return item;
    } else {
      var copy = item;
      for (var current in item.allItems) {
        if (current.subcategoryName.isEmpty) {
          copy.allItems.remove(current);
          copy.allItems.insert(0, current);
          return copy;
        }
      }
      // All items have subcategories
      return item;
    }
  }

  /// POST an update in the inventory of the purchased items
  static Future<void> updateInventoryForOrder(SohoOrderObject order) async {
    final String adjustmentType = "ADJUSTMENT";
    final String stateSold = "SOLD";

    // Init request body with initial values
    var requestBody = {
      "idempotency_key" : Uuid().v1(),
      "ignore_unchanged_counts" : true

    };
    var changes = [];
    var occurredAt = "";
    try {
      occurredAt = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSS').format(DateTime.now());
    } catch (e) {
      // TODO: HAndle error!
      print(e.toString());
    }

    for (var element in order.selectedProducts) {
      // Add REGULAR element to array
      Map<String, dynamic> elementDict = {
        "type" : adjustmentType
      };
      var adjustmentDict = {
        "catalog_object_id" : element.productID,
        "from_state" : element.fromState,
        "to_state" : stateSold,
        "location_id" : element.locationId,
        "quantity" : "1",
        "occurred_at" : occurredAt + "Z"
      };
      elementDict["adjustment"] = adjustmentDict;
      changes.add(elementDict);
      // Add VARIATIONS if any
      for (var variationType in element.productVariations) {
        for (var variation in variationType.variations) {
          // Add REGULAR element to array
          Map<String, dynamic> variationDict = {
            "type" : adjustmentType
          };
          var adjustmentDict = {
            "catalog_object_id" : variation.squareID,
            "from_state" : variation.fromState,
            "to_state" : stateSold,
            "location_id" : variation.locationId,
            "quantity" : "1",
            "occurred_at" : occurredAt + "Z"
          };
          variationDict["adjustment"] = adjustmentDict;
          changes.add(variationDict);
        }
      }
    }
    // Add array to request body
    requestBody["changes"] = changes;

    // Build request
    var updateInventoryHost = _squareHost + _inventory + _batchChange;
    var request = await http.post(updateInventoryHost, body: jsonEncode(requestBody), headers: _requestHeader);
    var jsonInventoryResult = json.decode(utf8.decode(request.bodyBytes));
    // Check if an error occured
    if (jsonInventoryResult["counts"] == null) {
      // TODO: Notify about error (Maybe sent email to admin with the order)
    }
  }


  /// Builds a String with the body for the getItemsForCategory(categoryID) request
  /// PARAMS:
  /// - categoryId - String  ID for category given by  SQUARE
  static String _buildSearchItemsByCategoryRequestBody(String categoryId) {
    return jsonEncode({"object_types": ["ITEM"],"query": {"prefix_query": {"attribute_name": "category_id","attribute_prefix": "$categoryId"}},"limit": 100});
  }

  static String _builsSearchItemsByNameRequestBody(String name) {
    return jsonEncode({"object_types": ["ITEM"],"query": {"prefix_query": {"attribute_name": "name","attribute_prefix": "$name"}},"limit": 100});
  }

}
