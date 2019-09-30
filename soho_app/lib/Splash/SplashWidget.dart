import 'dart:async';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'dart:convert';

import 'dart:io';

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

//    test();
    // Give some time to the splash to show
    Timer(Duration(milliseconds: 50), () {
      // Get the categories for HomePage
      SquareHTTPRequest.getSquareCategories().then((categories) {
        Application.sohoCategories = categories;
        Navigator.pushNamed(context, Routes.homePage);
      });
    });

  }

  Future test() async {
    Stream<String> streamResult;

    print("start");
    HttpClient client = HttpClient();
    client.getUrl(Uri.parse("https://connect.squareup.com/v2/catalog/list?types=CATEGORY")).then((request) {
      request.headers.contentType = ContentType.json;
      request.headers.add("Authorization", "Bearer EAAAEOjIOtjeZhu3M35n3uhYp4iQCBfOxfseiRthdNaFzS9o4P99IW48fP6uTEcZ");
      request.headers.add("Accept",  "application/json");
      return request.close();
    }).then((response) {
      print("Result");

      streamResult = response.transform(utf8.decoder);


    });

    print("End");

  }

}