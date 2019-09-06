import 'dart:async';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';

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
      body: Container(
        constraints: BoxConstraints.expand(),
        alignment: Alignment.center,
        color: Colors.white,
        child: Container(
          child: Image(
              image: AssetImage('assets/splash/soho_splash.png')
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Give some time to the splash to show
    Timer(Duration(seconds: 1), () {
      // Get the categories for HomePage
      SquareHTTPRequest.getSquareCategories().then((categories) {
        Application.sohoCategories = categories;
        Navigator.pushNamed(context, Routes.homePage);
      });
    });

  }

}