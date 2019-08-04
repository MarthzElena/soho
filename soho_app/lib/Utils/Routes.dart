import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:soho_app/SohoApp.dart';
import 'package:soho_app/Auth/LoginWidget.dart';
import 'package:soho_app/HomePage/HomePageWidget.dart';

class Routes {

  static String root = "/";
  static String login = "Login";
  static String homePage = "HomePage";

  static void setUpRouter(Router router) {

    // Main route
    router.define(
        root,
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
              return SohoApp();
            }),
        transitionType: TransitionType.native
    );

    // Auth
    router.define(
        login,
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
              return LoginWidget();
            }),
        transitionType: TransitionType.native
    );

    // Soho Home
    router.define(
        homePage,
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
              return HomePageWidget();
            }),
        transitionType: TransitionType.native
    );

  }

}