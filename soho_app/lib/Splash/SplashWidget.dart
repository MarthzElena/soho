import 'dart:async';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/Auth/AuthController.dart';

class SplashWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // Return Splash state
    return _SplashWidgetState();
  }

}

class _SplashWidgetState extends State<SplashWidget>  with AfterLayoutMixin {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Container(
            child: Text("!!! SPLASH !!!"),
            constraints: BoxConstraints.expand(),
            alignment: Alignment(0.0, 0.0),
            color: Colors.pinkAccent,
          )),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {

    Timer(Duration(seconds: 2), () {
      // Check if there's a valid user
      AuthController().getSavedAuthObject().then((user) {
        if (user != null) {
          // TODO: Do something with this user
          Navigator.pushNamed(context, Routes.homePage);
        } else {
          // Go to Login
          Navigator.pushNamed(context, Routes.login);
        }
      });
    });

  }

}