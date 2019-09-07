import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:soho_app/SohoApp.dart';
import 'package:soho_app/Auth/LoginWidget.dart';
import 'package:soho_app/HomePage/HomePageWidget.dart';
import 'package:soho_app/Auth/RegisterWidget.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsWidget.dart';

class Routes {

  static String root = "/";
  static String login = "Login";
  static String homePage = "HomePage";
  static String register = "Register";
  static String categoryDetail = "CategoryDetail";

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

    // Auth Login
    router.define(
      login,
      handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return LoginWidget();
          }),
      transitionType: TransitionType.native
    );

    // Auth Create Account
    router.define(
      register,
      handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return RegisterWidget();
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
      transitionType: TransitionType.fadeIn
    );
    
    // Category Detail
    router.define(
        categoryDetail,
        handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return CategoryItemsWidget();
          }
        ),
      transitionType: TransitionType.inFromRight
    );

  }

}