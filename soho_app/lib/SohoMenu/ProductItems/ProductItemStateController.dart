
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class ProductItemState extends Model {

  Map<String, Map<VariationItemObject, bool>> availableVariations = {};
  List<VariationKeyValueModel> selectedVariations = List<VariationKeyValueModel>();
  double selectedItemPrice = 0.0;
  bool variationRequired = false;

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
    // Get new element
    VariationKeyValueModel newValue = VariationKeyValueModel(type: fromType, value: item);

    // Search for repeated variation
    for (var item in selectedVariations) {
      if (item.value.name == newValue.value.name) {
        newValue = item;
        break;
      }
    }

    if (selectedVariations.remove(newValue)) {
      // Update price
      selectedItemPrice -= newValue.value.price;

      notifyListeners();
    }

  }

  void addVariation(VariationItemObject item, String fromType) {
    // Add element to list
    VariationKeyValueModel newValue = VariationKeyValueModel(type: fromType, value: item);

    // Only remove repeated type if variation is required
    if (variationRequired) {
      // Get repeated type
      VariationKeyValueModel repeatedType;
      for (var element in selectedVariations) {
        if (element.type == fromType && element.value.name != item.name) {
          repeatedType = element;
          break;
        }
      }
      if (repeatedType != null) {
        selectedVariations.remove(repeatedType);

        // Update price
        selectedItemPrice -= repeatedType.value.price;
      }
    }

    // Add new variation
    selectedVariations.add(newValue);
    // Update the price
    selectedItemPrice += newValue.value.price;

    notifyListeners();
  }

  VariationItemObject getSelectedVariation(String fromType) {
    for (var variation in selectedVariations) {
      if (variation.type == fromType) {
        return variation.value;
      }
    }
    return null;
  }

  void updateVariationType({bool isRequired}) {
    variationRequired = isRequired;
    notifyListeners();
  }

}

class VariationKeyValueModel {
  String type;
  VariationItemObject value;

  VariationKeyValueModel({this.type, this.value});
}