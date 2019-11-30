import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Routes.dart';

class SplashWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // Return Splash state
    return _SplashWidgetState();
  }
}

class _SplashWidgetState extends State<SplashWidget> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image(image: AssetImage('assets/splash/soho_logo.png')),
            Image(image: AssetImage('assets/splash/green_scratch.png'))
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Give some time to the splash to show
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      // Get the categories for HomePage
      SquareHTTPRequest.getSquareCategories().then((categories) {
        if (categories.isNotEmpty) {
          timer.cancel();
          Application.sohoCategories = categories;
          Navigator.pushNamed(context, Routes.homePage);
        }
      });
    });
  }
}
