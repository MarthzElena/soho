import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class ProductItemState extends Model {
  Map<String, Map<VariationItemObject, bool>> availableVariations = {};
  Map<String, List<VariationItemObject>> selectedVariations = {};
  double selectedItemPrice = 0.0;

  bool variationRequired = false;
  bool isVisible = false;

  void initAvailableVariations(List<VariationTypeObject> allVariations) {
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

  void changeVisible() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
