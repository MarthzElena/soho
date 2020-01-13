import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Locator.dart';

class RegisterState extends Model {

  // Validation tools
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  bool validEmail = true;

  // Registration field values
  String nameInput = "";
  String lastNameInput = "";
  String emailInput = "";

  bool validateFieldsNotEmpty() {
    if (nameInput.isNotEmpty && lastNameInput.isNotEmpty && emailInput.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> createAccount(BuildContext context, String phone, String userID) async {
    if (validEmail & validateFieldsNotEmpty()) {
      // Create new dictionary with data
      var updatedDict = SohoUserObject.createUserDictionary(
        username: nameInput + " " + lastNameInput,
        email: emailInput,
        userId: userID,
        photoUrl: "",
        phoneNumber: phone,
        isAdmin: false,
        firstTime: true
      );
      await locator<AuthController>().updateUserInDatabase(updatedDict).then((_) {
        // Update drawer
        locator<HomePageState>().updateDrawer();
        Navigator.pop(context);
        Navigator.pop(context);
      }).catchError((error) {
        // TODO: Handle error
        print("Register error: ${error.toString()}");
      });
    } else {
      // TODO: Show some error!
      print("REGISTER ERROR!!!");
    }
  }


}