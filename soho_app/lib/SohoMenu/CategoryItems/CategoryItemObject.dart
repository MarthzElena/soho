import 'dart:core';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';

class CategoryItemObject {

  /// All available products and subcategories
  List<SubcategoryItems> allItems = List<SubcategoryItems>();

  Future<void> addProductItem(ProductItemObject product) async {
    var elementAdded = false;
    for (var element in allItems) {
      if (element.subcategoryName.compareTo(product.subcategory) == 0) {
        // Add element
        element.items.add(product);
        elementAdded = true;
        return;
      }
    }
    // Check if element was added
    if (!elementAdded) {
      // Subcategory is new
      SubcategoryItems newSubcategory = SubcategoryItems();
      newSubcategory.subcategoryName = product.subcategory;
      newSubcategory.items.add(product);
      allItems.add(newSubcategory);
    }
  }
}

class SubcategoryItems {

  /// Sub-category name
  String subcategoryName = "";

  /// Available products
  List<ProductItemObject> items = List<ProductItemObject>();

}