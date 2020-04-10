import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';
import 'package:soho_app/Utils/Application.dart';

import '../SohoMenu/ProductItems/ProductItemObject.dart';

class ProductItemState extends Model {
  // Black Tea category constants
  final String BLACK_TEA_MILK = "Leche";
  final String BLACK_TEA_GARNISH = "Garnish";
  // Bottom text
  static const String ADD_ITEM_TEXT = "Agregar 1 a la orden";
  static const String GO_TO_CHECKOUT_TEXT = "Ver carrito";
  static const String COMPLETE_ORDER = "Realizar pedido ahora";
  ProductItemObject currentProduct;
  Map<String, Map<VariationItemObject, bool>> availableVariations = {};
  Map<String, List<VariationItemObject>> selectedVariations = {};
  double selectedItemPrice = 0.0;

  bool shouldShowBottomForProductDetail = false;

  // Settings for Add To Cart button
  String addToCartText = "";
  String addToCartPrice = "";

  void initProduct(ProductItemObject fromProduct) {
    // Set current product
    currentProduct = fromProduct;
    // Set initial price
    selectedItemPrice = fromProduct.price;
    // Set variations
    initAvailableVariations(fromProduct.productVariations);
    // Clear selected variations
    selectedVariations.clear();
    // Should show bottom
    shouldShowBottomForProductDetail = !fromProduct.isVariationRequired();
    // Set bottom
    setBottomState(ProductItemState.ADD_ITEM_TEXT);
  }

  bool shouldGoToCheckout() {
    return addToCartText == GO_TO_CHECKOUT_TEXT;
  }

  bool shouldGoToCompleteOrder() {
    return addToCartText == COMPLETE_ORDER;
  }

  void setBottomState(String state) {
    if (state == ADD_ITEM_TEXT) {
      addToCartText = ADD_ITEM_TEXT;
      addToCartPrice = "\$${selectedItemPrice.toString()}0";

    } else if (state == GO_TO_CHECKOUT_TEXT) {
      // Only show add to cart button if there's an ongoing order
      if (Application.currentOrder != null) {
        addToCartText = GO_TO_CHECKOUT_TEXT;
        // Get price of order
        var price = 0.0;
        for (var item in Application.currentOrder.selectedProducts) {
          price += item.price;
        }
        addToCartPrice = "\$${price}0";
      }

    } else if (state == COMPLETE_ORDER) {
      addToCartText = COMPLETE_ORDER;
      addToCartPrice = "";
    }

    notifyListeners();
  }

  void initAvailableVariations(List<VariationTypeObject> allVariations) {
    availableVariations.clear();
    for (var variationType in allVariations) {
      Map<VariationItemObject, bool> values = {};
      for (var variation in variationType.variations) {
        values[variation] = false;
      }
      availableVariations[variationType.variationTypeName] = values;
    }
    notifyListeners();
  }

  void updateCheckboxValue(String forType, VariationItemObject forItem, bool value) {
    var variation = availableVariations[forType];
    variation[forItem] = value;

    // Only add variation if value == TRUE
    if (value) {
      addVariation(forItem, forType);
    } else {
      // Remove optional variation
      removeVariation(forItem, forType);
    }
  }

  void removeVariation(VariationItemObject item, String fromType) {
    // Make sure variation has values
    if (selectedVariations[fromType] == null) {
      // Item for variation type doesn't exist, do nothing
      return;
    }
    // Remove item
    if (selectedVariations[fromType].remove(item)) {
      // Update price
      selectedItemPrice -= item.price;
      // Update the price on button
      addToCartPrice = "\$${selectedItemPrice.toString()}0";

      notifyListeners();
    }
  }

  void addVariation(VariationItemObject item, String fromType) {
    // Check if variation type has already been added
    if (selectedVariations[fromType] == null) {
      selectedVariations[fromType] = List<VariationItemObject>();
    }

    // If variation is already selected, remove the current variation for the type value
    if (selectedVariations[fromType].isNotEmpty) {
      // First update the price
      selectedItemPrice -= selectedVariations[fromType].first.price;
      // Clear the list
      selectedVariations[fromType].clear();
    }

    // Add the new item
    selectedVariations[fromType].add(item);
    // Update the price
    selectedItemPrice += item.price;
    // Update the price on button
    addToCartPrice = "\$${selectedItemPrice.toString()}0";

    // If all variations are added then show bottom
    if (availableVariations.length == selectedVariations.length) {
      shouldShowBottomForProductDetail = true;
    }

    notifyListeners();
  }

  VariationItemObject getSelectedVariation(String fromType) {
    if (selectedVariations[fromType] != null) {
      return selectedVariations[fromType].first;
    } else {
      return null;
    }
  }
}
