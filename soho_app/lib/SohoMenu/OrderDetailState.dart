import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/ui/purchases/orders.dart';

class OrderDetailState extends Model {

  static const double NO_TIP = 0.0;
  static const double TIP_TEN = 10.0;
  static const double TIP_FIFTEEN = 15.0;
  static const double TIP_TWENTY = 20.0;

  bool showCode = false;
  bool showCustomTip = false;
  bool showSpinner = false;

  double currentTip = 0.0;
  double orderTotal = 0.0;

  String discountCode = "";
  bool hasExchangedCode = false;
  double discount = 0.0;

  List<OrderElement> orderItems = List<OrderElement>();
  double productsSubTotal = 0.0;

  void prepareOrderElements() {
    // Clear elements
    orderItems.clear();
    orderTotal = 0.0;
    productsSubTotal = 0.0;

    if (Application.currentOrder != null) {
      for (var product in Application.currentOrder.selectedProducts) {
        var price = "\$${product.price}0";
        var productElement = OrderElement(name: product.name, price: price);
        orderItems.add(productElement);
        // Add variations
        for (var variationType in product.productVariations) {
          for (var variation in variationType.variations) {
            var itemVariation = OrderElement(name: variation.name);
            orderItems.add(itemVariation);
          }
        }
        // Add empty element for space between products
        orderItems.add(OrderElement());
        // Add price to subTotal
        productsSubTotal += product.price;
      }
      // Update order subtotal in model
      orderTotal = productsSubTotal;
    } else {
      orderItems.add(OrderElement(name: "No olvides agregar productos a tu pedido!"));
    }
    notifyListeners();
  }

  void updateSpinner({bool show}) {
    showSpinner = show;
    notifyListeners();
  }

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

  void updateTip(double toValue, {bool isCustomTip}) {
    currentTip = toValue;
    showCustomTip = isCustomTip;
    if (Application.currentOrder != null) {
      Application.currentOrder.tip = toValue;
    }
    notifyListeners();
  }

  void updateTotalPercentageDiscount(int percentage) {
    if (!hasExchangedCode) {
      discount = productsSubTotal * (percentage/100);
      orderTotal = productsSubTotal - discount;
      hasExchangedCode = true;
      notifyListeners();
    }
  }

  void updateTotalFixedDiscount(double amount) {
    if (!hasExchangedCode) {
      orderTotal = productsSubTotal - amount;
      hasExchangedCode = true;
      discount = amount;
      notifyListeners();
    }
  }

}