import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Auth/RegisterWidget.dart';
import 'package:soho_app/HomePage/HomePageWidget.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsWidget.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/ui/about/about.dart';
import 'package:soho_app/ui/about/location.dart';
import 'package:soho_app/ui/auth/login.dart';
import 'package:soho_app/ui/payments/methods.dart';
import 'package:soho_app/ui/profile/check_profile.dart';
import 'package:soho_app/ui/purchases/history.dart';
import 'package:soho_app/ui/purchases/orders.dart';
import 'package:soho_app/ui/purchases/thanks.dart';

class Routes {
  static String root = "/";
  static String login = "Login";
  static String homePage = "HomePage";
  static String register = "Register";
  static String categoryDetail = "CategoryDetail/:category";
  static String orderDetail = "OrderDetail";
  static String orderComplete = "OrderComplete";
  static String viewProfile = "ViewProfile";
  static String myOrders = "MyOrders";
  static String about = "About";
  static String paymentMethods = "PaymentMethods";
  static String location = "Location";

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

    // Order completed
    router.define(orderComplete,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return ThanksScreen();
        }));

    // Profile view
    router.define(viewProfile,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          var user = Application.currentUser;
          if (user != null) {
            return CheckProfileScreen(name: user.firstName + " " + user.lastName, phone: user.userPhoneNumber);
          }
          return CheckProfileScreen();
        }));

    // My orders
    router.define(myOrders,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return HistoryScreen();
        }));

    // About SOHO
    router.define(about,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return AboutScreen();
        }));

    // Payment methods
    router.define(paymentMethods,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return MethodsScreen();
        }));

    // Location
    router.define(location,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return LocationScreen();
        }));
  }
}
