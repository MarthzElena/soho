import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:soho_app/SohoApp.dart';
import 'package:soho_app/Auth/AuthWidget.dart';
import 'package:soho_app/HomePage/HomePageWidget.dart';

class Routes {

  static String root = "/";
  static String auth = "Auth";
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
        auth,
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
              return AuthWidget();
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