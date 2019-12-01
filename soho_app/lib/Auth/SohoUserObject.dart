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

  // Past orders
  List<SohoOrderObject> pastOrders = List<SohoOrderObject>();
  // Ongoing orders
  List<SohoOrderObject> ongoingOrders = List<SohoOrderObject>();

  // Constructor
  SohoUserObject({this.lastName, this.firstName, this.email, this.userId, this.userPhoneNumber});


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