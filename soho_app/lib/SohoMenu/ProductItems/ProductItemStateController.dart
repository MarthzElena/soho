
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';

class ProductItemState extends Model {

  List<VariationKeyValueModel> selectedVariations = List<VariationKeyValueModel>();

  void addVariation(VariationItemObject item, String fromType) {
    // Add element to list
    VariationKeyValueModel newValue = VariationKeyValueModel(type: fromType, value: item);
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


}

class VariationKeyValueModel {
  String type;
  VariationItemObject value;

  VariationKeyValueModel({this.type, this.value});
}