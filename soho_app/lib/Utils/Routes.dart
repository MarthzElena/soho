import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Auth/LoginWidget.dart';
import 'package:soho_app/Auth/RegisterWidget.dart';
import 'package:soho_app/HomePage/HomePageWidget.dart';
import 'package:soho_app/SohoApp.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsWidget.dart';
import 'package:soho_app/ui/auth/login.dart';
import 'package:soho_app/ui/purchases/orders.dart';

class Routes {
  static String root = "/";
  static String login = "Login";
  static String homePage = "HomePage";
  static String register = "Register";
  static String categoryDetail = "CategoryDetail/:category";
  static String orderDetail = "OrderDetail";

  static Handler _categoryDetailHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          CategoryItemsWidget(categoryObjectString: params['category'][0]));

  static void setUpRouter(Router router) {
    // Auth Login
    router.define(login,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return LoginScreen();
    }), transitionType: TransitionType.native);

    // Auth Create Account
    router.define(register,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return RegisterWidget();
    }), transitionType: TransitionType.native);

    // Soho Home
    router.define(homePage,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return HomePageWidget();
    }), transitionType: TransitionType.fadeIn);

    // Category Detail
    router.define(categoryDetail,
        handler: _categoryDetailHandler, transitionType: TransitionType.inFromRight);

    // Order detail (Shopping cart)
    router.define(orderDetail,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return OrderScreen();
        }));
  }
}
