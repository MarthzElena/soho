import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';

class LoginState extends Model {
  // TODO: Validate phone and password
  String phoneInput = "";
  String passwordInput = "";

  AuthController authController = locator<AuthController>();

  Future<void> facebookLoginPressed(BuildContext context) async {
    await authController.initiateFacebookLogin().then((_) {
      if (Application.currentUser != null) {
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** FACEBOOK Login ERROR");
      }
    });
  }

  Future<void> googleLoginPressed(BuildContext context) async {
    await authController.initiateGoogleLogin().then((_) {
      if (Application.currentUser != null) {
        // TODO: Do something with this user?
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** Google Login ERROR");
      }
    });
  }

  Future<void> phoneLoginPressed(
    BuildContext context, {
    String phoneNumber,
    String code,
  }) async {
    if (phoneNumber.isNotEmpty) {
      await authController.initiatePhoneLogin(phoneNumber, code);
    }
  }
}
