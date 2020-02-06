import 'dart:core';

import 'package:intl/intl.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';

/// THIS OBJECT WILL BE SAVED ON DATABASE PER USER
class SohoOrderObject {
  static const String keySelectedProducts = "selected_products";
  static const String keyCompletionDate = "completion_date";
  static const String keyTip = "tip";
  static const String keyNotes = "notes";
  static const String keyOrderTotal = "order_total";
  static const String keyIsCompleted = "is_completed";
  static const String keyIsQRCodeValid = "is_qr_code_valid";
  static const String keyQRCodeData = "qr_code_reference";

  SohoOrderObject();

  // List of selected products for this order
  List<SohoOrderItem> selectedProducts = List<SohoOrderItem>();

  // Time of order completion
  // This value must be updated when the order is completed
  DateTime completionDate = DateTime.now();

  double orderTotal = 0.0;
  double tip = 0.0;
  String notes = "";

  // Reference in Firebase Storage to QR Code
  String qrCodeData = "";

  // Used for specifying if the order has been completed.
  // An order has been completed when the payment has been processed and accepted.
  bool isOrderCompleted = false;

  // Used for specifying if the QR Code for this order is valid.
  // A QR code for an order is only valid if it hasn't been exchanged.
  // The validity of a QR code only begins when the order is completed.
  bool isQRCodeValid = false;

  // Date getters
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
  String getCompletedDateWithTime() {
    var formatter = DateFormat("MMM dd yyyy hh:mm aa");
    return formatter.format(completionDate);
  }

  String getSelectedProductDescription() {
    var result = "";
    for (var item in selectedProducts) {
      result = "$result, ${item.name}";
    }
    return result;
  }

  Map<String, dynamic> getJson() {
    var dict = Map<String, dynamic>();
    dict[keyCompletionDate] = getCompletedDateString();
    dict[keyTip] = tip;
    dict[keyNotes] = notes;
    dict[keyOrderTotal] = orderTotal;
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
    tip = json[keyTip] + 0.0;
    notes = json[keyNotes];
    orderTotal = json[keyOrderTotal] + 0.0;
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