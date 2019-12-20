import 'dart:core';

import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';

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

}