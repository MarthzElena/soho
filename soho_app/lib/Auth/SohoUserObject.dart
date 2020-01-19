import 'dart:convert';
import 'dart:core';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';
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
  static const keyFirstTime = "firstTime";
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
  // Used to know if user has done onboarding
  bool isFirstTime = true;

  // Past orders
  List<SohoOrderObject> pastOrders = List<SohoOrderObject>();
  // Ongoing orders
  List<SohoOrderObject> ongoingOrders = List<SohoOrderObject>();

  // Constructor
  SohoUserObject({this.username, this.email, this.userId, this.photoUrl, this.userPhoneNumber});

  void completedOnboarding() {
    isFirstTime = false;
  }

  // This method completes the onboarding gift order
  Future<String> completeOnboardingOrder(String milk, String sugar, String username) async {
    var order = SohoOrderObject();
    // Add product
    var item = SohoOrderItem("Café de bienvenida", "", "", "Coffee", "", 0.0, "IN_STOCK", "");
    item.addOnboardingVariations(sugar, milk);
    order.selectedProducts.add(item);
    order.completionDate = DateTime.now();
    order.orderTotal = 0.0;
    order.isOrderCompleted = true;
    order.isQRCodeValid = true;
    var codeObject = SohoOrderQR(order: order, userId: userId, userName: username);
    var codeData = jsonEncode(codeObject.getJson());
    order.qrCodeData = codeData;
    ongoingOrders.add(order);

    // Update values in database
    completedOnboarding();
    var userJson = getJson();
    await locator<AppController>().updateUserInDatabase(userJson);

    return jsonEncode(codeData);
  }

  // This method is only called if the payment was successful
  Future<String> completeOrder(SohoOrderObject order) async {
    // Update completion time
    order.completionDate = DateTime.now();
    // Update order total price
    for (var product in order.selectedProducts) {
      order.orderTotal += product.price;
    }
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
    await locator<AppController>().updateUserInDatabase(userJson);

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
    dict[keyFirstTime] = isFirstTime;
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
    isFirstTime = json[keyFirstTime];
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
      isAdmin: this.isAdmin,
      firstTime: this.isFirstTime
    );
  }

  static Map<String, dynamic> createUserDictionary({String username, String email, String userId, String photoUrl, String phoneNumber, bool isAdmin, bool firstTime}) {
    // Create dictionary
    final Map<String,  dynamic> map = {
      keyUsername : username,
      keyEmail : email,
      keyUserId : userId,
      keyImageUrl : photoUrl,
      keyPhone : phoneNumber,
      keyIsAdmin : isAdmin,
      keyFirstTime : firstTime
    };

    // Return value
    return map;
  }



}