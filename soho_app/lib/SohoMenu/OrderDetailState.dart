import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Application.dart';

class OrderDetailState extends Model {

  static const double NO_TIP = 0.0;
  static const double TIP_TEN = 10.0;
  static const double TIP_FIFTEEN = 15.0;
  static const double TIP_TWENTY = 20.0;

  bool showCode = false;
  bool showCustomTip = false;

  double currentTip = 0.0;
  double orderSubtotal = 0.0;

  String discountCode = "";
  bool hasExchangedCode = false;
  double discount = 0.0;

  bool isTipOther() {
    return showCustomTip;
  }

  bool isTipTen() {
    return currentTip == TIP_TEN;
  }
  bool isTipFifteen() {
    return currentTip == TIP_FIFTEEN;
  }
  bool isTipTwenty() {
    return currentTip == TIP_TWENTY;
  }

  void updateState() {
    notifyListeners();
  }

  void updateShowCode() {
    showCode = !showCode;
    notifyListeners();
  }

  void updateShowCustomTip() {
    showCustomTip = !showCustomTip;
    if (showCustomTip) {
      currentTip = 0.0;
    }
    notifyListeners();
  }

  void updateTip(double toValue) {
    currentTip = toValue;
    showCustomTip = false;
    if (Application.currentOrder != null) {
      Application.currentOrder.tip = toValue;
    }
    notifyListeners();
  }

  void updateTotalPercentageDiscount(double productsTotal, int percentage) {
    if (!hasExchangedCode) {
      discount = productsTotal * (percentage/100);
      orderSubtotal = productsTotal - discount;
      hasExchangedCode = true;
      notifyListeners();
    }
  }

  void updateTotalFixedDiscount(double productsTotal, double amount) {
    if (!hasExchangedCode) {
      orderSubtotal = productsTotal - amount;
      hasExchangedCode = true;
      discount = amount;
      notifyListeners();
    }
  }

}