import 'dart:convert';
import 'package:soho_app/Utils/Constants.dart';

class AuthControllerUtilities {


  static Map<String, String> createUserDictionary(String lastName, String firstName, String email, String userId, String birthDate, String gender, String phoneNumber) {
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