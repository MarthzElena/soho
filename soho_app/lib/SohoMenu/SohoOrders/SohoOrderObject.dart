import 'dart:core';

import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';

/**
 * THIS OBJECT WILL BE SAVED ON DATABASE PER USER
 */
class SohoOrderObject {

  // List of selected products for this order
  List<SohoOrderItem> selectedProducts = List<SohoOrderItem>();

  // Used for specifying if the order has been completed.
  // An order has been completed when the payment has been processed and accepted.
  bool isOrderCompleted = false;

  // Used for specifying if the QR Code for this order is valid.
  // A QR code for an order is only valid if it hasn't been exchanged.
  // The validity of a QR code only begins when the order is completed.
  bool isQRCodeValid = false;

}