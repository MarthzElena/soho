import 'dart:convert';
import 'dart:core';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderQR.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Locator.dart';

class SohoUserObject {
  static const keyEmail = "email";
  static const keyUsername = "nombre";
  static const keyUserId = "id";
  static const keyPhone = "telefono";
  static const keyImageUrl = "picture";
  static const keyIsAdmin = "isAdmin";
  static const keyPastOrders = "past_orders";
  static const keyOngoingOrders = "ongoing_orders";

  // User name
  String username = "";
  //  User email
  String email = "";
  // User UUID from FireBase
  String userId = "";
  // User phone number (as String)
  String userPhoneNumber = "";
  // User image url
  String photoUrl = "";

  // Admin user
  // Admin user can read QR codes
  bool isAdmin = false;

  // Past orders
  List<SohoOrderObject> pastOrders = List<SohoOrderObject>();
  // Ongoing orders
  List<SohoOrderObject> ongoingOrders = List<SohoOrderObject>();

  // Constructor
  SohoUserObject({this.username, this.email, this.userId, this.photoUrl, this.userPhoneNumber});

  // This method is only called if the payment was successful
  Future<String> completeOrder(SohoOrderObject order) async {
    // Update completion time
    order.completionDate = DateTime.now();
    // Update completion value
    order.isOrderCompleted = true;
    order.isQRCodeValid = true;
    // Create QR Code  object
    var codeObject = SohoOrderQR(order: order, userId: userId, userName: username);
    var codeData = jsonEncode(codeObject.getJson());
    // Add code data to order
    order.qrCodeData = codeData;
    // Add to ongoingOrders
    ongoingOrders.add(order);
    // Update inventory for order
    await SquareHTTPRequest.updateInventoryForOrder(order);
    // Update values in database
    var userJson = getJson();
    await locator<AuthController>().updateUserInDatabase(userJson);

    return jsonEncode(codeData);
  }

  Map<String, dynamic> getJson() {
    var dict = Map<String, dynamic>();
    dict[keyEmail] = email;
    dict[keyUsername] = username;
    dict[keyUserId] = userId;
    dict[keyPhone] = userPhoneNumber;
    dict[keyImageUrl] = photoUrl;
    dict[keyIsAdmin] = isAdmin;
    var pastOrdersDict = [];
    for (var order in pastOrders) {
      pastOrdersDict.add(order.getJson());
    }
    dict[keyPastOrders] = pastOrdersDict;
    var ongoingOrdersDict = [];
    for (var order in ongoingOrders) {
      ongoingOrdersDict.add(order.getJson());
    }
    dict[keyOngoingOrders] = ongoingOrdersDict;
    return dict;
  }

  SohoUserObject.fromJson(Map<String, dynamic> json) {
    username = json[keyUsername];
    email = json[keyEmail];
    userId = json[keyUserId];
    userPhoneNumber = json[keyPhone];
    photoUrl = json[keyImageUrl] == null ? "" : json[keyImageUrl];
    isAdmin = json[keyIsAdmin];
    if (json[keyPastOrders] != null) {
      var pastOrdersDict = json[keyPastOrders];
      for (var order in pastOrdersDict) {
        pastOrders.add(SohoOrderObject.fromJson(order));
      }
    }
    if (json[keyOngoingOrders] != null) {
      var ongoingOrdersDict = json[keyOngoingOrders];
      for (var order in ongoingOrdersDict) {
        ongoingOrders.add(SohoOrderObject.fromJson(order));
      }
    }
  }

  Map<String, dynamic> getDictionary() {
    return createUserDictionary(
      username: this.username,
      email: this.email,
      userId: this.userId,
      photoUrl: this.photoUrl,
      phoneNumber: this.userPhoneNumber,
      isAdmin: this.isAdmin
    );
  }

  static Map<String, dynamic> createUserDictionary({String username, String email, String userId, String photoUrl, String phoneNumber, bool isAdmin}) {
    // Create dictionary
    final Map<String,  dynamic> map = {
      keyUsername : username,
      keyEmail : email,
      keyUserId : userId,
      keyImageUrl : photoUrl,
      keyPhone : phoneNumber,
      keyIsAdmin : isAdmin
    };

    // Return value
    return map;
  }



}