import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
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

  void validateEmail() {
    validEmail = EmailValidator.validate(emailInput);
    notifyListeners();
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
      await locator<AppController>().updateUserInDatabase(updatedDict).then((_) {
        // Make sure user is saved to state
        Application.currentUser = SohoUserObject.fromJson(updatedDict);
        // Update drawer
        locator<HomePageState>().updateDrawer();
        Navigator.pop(context);
        Navigator.pop(context);
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "Error al registrar datos de usuario.",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 4,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0x99E51F4F),
            textColor: Colors.white
        );
      });
    } else {
      Fluttertoast.showToast(
          msg: "El email debe de ser válido y todos los campos son necesarios.",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 4,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0x99E51F4F),
          textColor: Colors.white
      );
    }
  }


}