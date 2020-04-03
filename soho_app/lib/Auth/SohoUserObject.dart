import 'dart:convert';
import 'dart:core';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/Network/get_all_cards/call.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderQR.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:uuid/uuid.dart';

enum CardType {
  visa,
  masterCard,
  amex
}

class CardInfoReduced {
  String last4;
  String cardName;
  String expiration;
  CardType cardType;
  String cardId;

  CardInfoReduced({this.last4, this.cardName, this.expiration, this.cardType, this.cardId});
}

class SohoUserObject {
  static const keyStripeId = "stripe_id";
  static const keyPaymentMethod = "payment_method";
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
  // Stripe id
  String stripeId = "";
  // Default card id
  String selectedPaymentMethod = "";

  // Admin user
  // Admin user can read QR codes
  bool isAdmin = false;
  // Used to know if user has done onboarding
  bool isFirstTime = true;

  // Past orders
  List<SohoOrderObject> pastOrders = List<SohoOrderObject>();
  // Ongoing orders
  List<SohoOrderObject> ongoingOrders = List<SohoOrderObject>();

  List<CardInfoReduced> cardsReduced = List<CardInfoReduced>();

  // Constructor
  SohoUserObject({this.username, this.email, this.userId, this.photoUrl, this.userPhoneNumber});

  void completedOnboarding() {
    isFirstTime = false;
  }

  Future<bool> addStripeId(String value) async {
    stripeId = value;
    await locator<AppController>().updateUserInDatabase(getJson()).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
    return false;
  }

  Future<void> getCardsShortInfo() async {
    if (stripeId.isNotEmpty) {
      await getAllCardsCall(customerId: stripeId).then((response) {
        // Clear data
        cardsReduced.clear();
        for (var item in response.data) {
          var month = item.expMonth < 10 ? "0${item.expMonth}" : item.expMonth.toString();
          var year = item.expYear.toString().substring(2);
          if (item.brand.contains("MasterCard") || item.brand.contains("Visa") || item.brand.contains("American Express")) {
            var cardType = CardType.visa;
            if (item.brand.contains("MasterCard")) {
              cardType = CardType.masterCard;
            } else if (item.brand.contains("American Express")) {
              cardType = CardType.amex;
            }
            CardInfoReduced info = CardInfoReduced(
              last4: item.last4,
              cardName: item.name,
              expiration: "$month / $year",
              cardType: cardType,
              cardId: item.id,
            );
            cardsReduced.add(info);
          }
        }
        if (cardsReduced.isEmpty) {
          selectedPaymentMethod = "";
        } else {
          selectedPaymentMethod = cardsReduced.first.cardId;
        }
      }).catchError((error) {
        print("ERROR getting cards: ${error.toString()}");
      });
    }
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
    // Add id to order
    order.id = Uuid().v1();
    // Create QR Code  object
    var codeObject = SohoOrderQR(order: order, userId: userId, userName: username);
    var codeData = jsonEncode(codeObject.getJson());
    // Add code data to order
    order.qrCodeData = codeData;
    // Add to ongoingOrders
    ongoingOrders.add(order);
    // Update inventory for order
    await locator<SquareHTTPRequest>().updateInventoryForOrder(order);
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
    dict[keyStripeId] = stripeId;
    dict[keyPaymentMethod] = selectedPaymentMethod;
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
    stripeId = json[keyStripeId] == null ? "" : json[keyStripeId];
    selectedPaymentMethod = json[keyPaymentMethod] == null ? "" : json[keyPaymentMethod];
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