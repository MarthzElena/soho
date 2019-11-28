
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class ProductItemState extends Model {

  Map<String, Map<VariationItemObject, bool>> availableVariations = {};
  List<VariationKeyValueModel> selectedVariations = List<VariationKeyValueModel>();

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

    addVariation(forItem, forType);
  }

  void addVariation(VariationItemObject item, String fromType) {
    // Add element to list
    VariationKeyValueModel newValue = VariationKeyValueModel(type: fromType, value: item);

    // If value is already selected, de-select variation
    if (selectedVariations.contains(newValue)) {
      selectedVariations.remove(newValue);
      notifyListeners();
      return;
    }

    selectedVariations.add(newValue);
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
    }
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

}

class VariationKeyValueModel {
  String type;
  VariationItemObject value;

  VariationKeyValueModel({this.type, this.value});
}