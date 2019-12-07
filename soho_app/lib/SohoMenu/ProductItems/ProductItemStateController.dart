import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';
import 'package:soho_app/Utils/Application.dart';

import 'ProductItemObject.dart';

class ProductItemState extends Model {
  final String ADD_ITEM_TEXT = "Agregar 1 a la orden";
  final String GO_TO_CHECKOUT_TEXT = "Ver carrito";
  ProductItemObject currentProduct;
  Map<String, Map<VariationItemObject, bool>> availableVariations = {};
  Map<String, List<VariationItemObject>> selectedVariations = {};
  double selectedItemPrice = 0.0;
  bool variationRequired = false;
  // Settings for Add To Cart button
  bool showAddToCart = false;
  String addToCartText = "";
  String addToCartPrice = "";

  void initProduct(ProductItemObject fromProduct) {
    // Set current product
    currentProduct = fromProduct;
    // Set initial price
    selectedItemPrice = fromProduct.price;
    // Set variations
    initAvailableVariations(fromProduct.productVariations, fromProduct.isVariationsRequired());
    // Clear selected variations
    selectedVariations.clear();
    // Set add to cart button
    setBottomToAddItem();

  }

  bool shouldGoToCheckout() {
    return addToCartText == GO_TO_CHECKOUT_TEXT;
  }

  void setBottomToAddItem() {
    addToCartText = ADD_ITEM_TEXT;
    addToCartPrice = "\$${selectedItemPrice.toString()}0";
    updateShowAddToCart(shouldShow: !currentProduct.isVariationsRequired());
  }

  void setBottomToCheckout() {
    // Only show add to cart button if there's an ongoing order
    if (Application.currentOrder != null) {
      addToCartText = GO_TO_CHECKOUT_TEXT;
      // Get price of order
      var price = 0.0;
      for (var item in Application.currentOrder.selectedProducts) {
        price += item.price;
      }
      addToCartPrice = "\$${price}0";
      updateShowAddToCart(shouldShow: Application.currentOrder != null);
    } else {
      // Hide button
      updateShowAddToCart(shouldShow: false);
    }

  }

  void initAvailableVariations(List<VariationTypeObject> allVariations, bool isRequired) {
    availableVariations.clear();
    for (var variationType in allVariations) {
      Map<VariationItemObject, bool> values = {};
      for (var variation in variationType.variations) {
        values[variation] = false;
      }
      availableVariations[variationType.variationTypeName] = values;
    }
    // Set if variation is required
    variationRequired = isRequired;

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

      notifyListeners();
    }
  }

  void addVariation(VariationItemObject item, String fromType) {
    // Check if variation type has already been added
    if (selectedVariations[fromType] == null) {
      selectedVariations[fromType] = List<VariationItemObject>();
    }

    // If variation is required && already selected, remove the current variation for the type value
    if (variationRequired && selectedVariations[fromType].isNotEmpty) {
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

    if (!showAddToCart) {
      updateShowAddToCart(shouldShow: true);
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

  void updateVariationType({bool isRequired}) {
    variationRequired = isRequired;
    notifyListeners();
  }

  void updateShowAddToCart({bool shouldShow}) {
    showAddToCart = shouldShow;
    notifyListeners();
  }
}
