import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Auth/LoginStateController.dart';

class LoginWidget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    // Return State for Login
    return _LoginState();
  }
}

class _LoginState extends State<LoginWidget> {
  LoginState loginState = locator<LoginState>();
  AuthController authController = locator<AuthController>();
  String smsCode = "";

  @override
  Widget build(BuildContext context) {

    return ScopedModel<LoginState>(
      model: loginState,
      child: ScopedModelDescendant<LoginState>(builder: (builder, child, model) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('X')
                ),
                Text('Número de télefono'),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 229,228,229), width: 1.0)),
                    hintText: '(333) - (3333333)'
                  ),
                  onChanged: (value) {
                    // TODO: Validate phone
                    model.phoneInput = value;
                  },
                ),
                Text('SMS code'),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 229,228,229), width: 1.0)),
                      hintText: 'Type code sent by SMS'
                  ),
                  onChanged: (value) {
                    // TODO: Validate phone
                    smsCode = value;
                  },
                ),
                FlatButton(
                    onPressed: () {
                      _phoneLoginPressed(context, phoneNumber: model.phoneInput);
                    },
                    child: Text('Iniciar sesión con télefono')
                ),
                FlatButton(
                    onPressed: () {
                      _facebookLoginPressed(context);
                    },
                    child: Text('Iniciar sesión con Facebook!')
                ),
                FlatButton(
                    onPressed: () {
                      _googleLoginPressed(context);
                    },
                    child: Text('Iniciar sesión con Google!')
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _facebookLoginPressed(BuildContext context) async {

    await authController.initiateFacebookLogin().then((_) {
      if (Application.currentUser != null) {

        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** FACEBOOK Login ERROR");
      }
    });
  }

  Future<void> _googleLoginPressed(BuildContext context) async {

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

  Future<void> _phoneLoginPressed(BuildContext context, {String phoneNumber, String code}) async {

    if (phoneNumber.isNotEmpty) {
      await authController.initiatePhoneLogin(phoneNumber, code);
    }
  }

}
