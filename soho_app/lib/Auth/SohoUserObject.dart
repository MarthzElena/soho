import 'dart:core';

import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/Utils/Constants.dart';

class SohoUserObject {

  // User last name
  String lastName = "";
  // User first name
  String firstName = "";
  //  User email
  String email = "";
  // User UUID from FireBase
  String userId = "";
  // User phone number (as String)
  String userPhoneNumber = "";
  // User birthday date TODO: Define String format for date
  String userBirthDate = "";
  // User gender TODO: Define format for gender
  String userGender = "";
  // Admin user
  // Admin user can read QR codes
  bool isAdmin = false;

  // Past orders
  List<SohoOrderObject> pastOrders = List<SohoOrderObject>();
  // Ongoing orders
  List<SohoOrderObject> ongoingOrders = List<SohoOrderObject>();

  // Constructor
  SohoUserObject({this.lastName, this.firstName, this.email, this.userId, this.userPhoneNumber});

  SohoUserObject.sohoUserObjectFromDictionary(Map<String, String> dictionary) {
    this.lastName = dictionary[Constants.DICT_KEY_LAST_NAME];
    this.firstName = dictionary[Constants.DICT_KEY_NAME];
    this.email = dictionary[Constants.DICT_KEY_EMAIL];
    this.userId = dictionary[Constants.DICT_KEY_ID];
    this.userPhoneNumber = dictionary[Constants.DICT_KEY_PHONE];
    this.userBirthDate = dictionary[Constants.DICT_KEY_BIRTH_DATE];
    this.userGender = dictionary[Constants.DICT_KEY_GENDER];
  }

  static Map<String, String> createUserDictionary({String lastName, String firstName, String email, String userId, String birthDate, String gender, String phoneNumber}) {
    // Create dictionary
    final Map<String,  String> map = {
      Constants.DICT_KEY_LAST_NAME : lastName,
      Constants.DICT_KEY_NAME : firstName,
      Constants.DICT_KEY_EMAIL : email,
      Constants.DICT_KEY_ID : userId,
      Constants.DICT_KEY_PHONE : phoneNumber,
      Constants.DICT_KEY_BIRTH_DATE : birthDate,
      Constants.DICT_KEY_GENDER : gender
    };

    // Return value
    return map;
  }



}