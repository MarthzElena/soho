import 'dart:core';

import 'package:intl/intl.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';

/// THIS OBJECT WILL BE SAVED ON DATABASE PER USER
class SohoOrderObject {
  static const String keySelectedProducts = "selected_products";
  static const String keyCompletionDate = "completion_date";
  static const String keyIsCompleted = "is_completed";
  static const String keyIsQRCodeValid = "is_qr_code_valid";
  static const String keyQRCodeData = "qr_code_reference";

  SohoOrderObject();

  // List of selected products for this order
  List<SohoOrderItem> selectedProducts = List<SohoOrderItem>();

  // Time of order completion
  // This value must be updated when the order is completed
  DateTime completionDate = DateTime.now();

  // Reference in Firebase Storage to QR Code
  String qrCodeData = "";

  static DateTime setCompletionDateFromString(String date) {
    return DateTime.parse(date);
  }
  String getCompletedDateString() {
    return completionDate.toIso8601String();
  }
  String getCompletedDateShort() {
    var formatter = DateFormat("MMM dd yyyy");
    return formatter.format(completionDate);
  }

  // Used for specifying if the order has been completed.
  // An order has been completed when the payment has been processed and accepted.
  bool isOrderCompleted = false;

  // Used for specifying if the QR Code for this order is valid.
  // A QR code for an order is only valid if it hasn't been exchanged.
  // The validity of a QR code only begins when the order is completed.
  bool isQRCodeValid = false;

  Map<String, dynamic> getJson() {
    var dict = Map<String, dynamic>();
    dict[keyCompletionDate] = getCompletedDateString();
    dict[keyIsCompleted] = isOrderCompleted;
    dict[keyIsQRCodeValid] = isQRCodeValid;
    dict[keyQRCodeData] = qrCodeData;
    var dictProducts = [];
    for (var product in selectedProducts) {
      dictProducts.add(product.getJson());
    }
    dict[keySelectedProducts] = dictProducts;
    return dict;
  }

  SohoOrderObject.fromJson(Map<dynamic, dynamic> json) {
    completionDate = setCompletionDateFromString(json[keyCompletionDate]);
    isOrderCompleted = json[keyIsCompleted];
    isQRCodeValid = json[keyIsQRCodeValid];
    qrCodeData = json[keyQRCodeData];
    if (json[keySelectedProducts] != null) {
      var dictProducts = json[keySelectedProducts];
      for (var product in dictProducts) {
        selectedProducts.add(SohoOrderItem.fromJson(product));
      }
    }
  }

}