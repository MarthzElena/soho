import 'dart:collection';
import 'dart:core';

import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';

import 'SohoOrderItem.dart';

class SohoOrderQR {
  static const String keyOrder = "order";
  static const String keyUserName = "userName";
  static const String keyUserId = "userId";

  SohoOrderObject order;
  String userName;
  String userId;

  SohoOrderQR({this.order, this.userId, this.userName});



  Map<String, dynamic> getJson() {
    var dict = Map<String, dynamic>();
    dict[keyUserName] = userName;
    dict[keyUserId] = userId;
    dict[keyOrder] = order.getJson();
    return dict;
  }

  SohoOrderQR.fromJson(Map<String, dynamic> json) {
    userName = json[keyUserName];
    userId = json[keyUserId];
    order = SohoOrderObject.fromJson(json[keyOrder]);
  }

  void parseLinkedList(LinkedHashMap map) {
    userName = map["userName"];
    userId = map["userId"];
    LinkedHashMap orderValue = map["order"];
    // Create new order
    SohoOrderObject convertedOrder = SohoOrderObject.fromJson(orderValue.cast());
    order = convertedOrder;
  }

}