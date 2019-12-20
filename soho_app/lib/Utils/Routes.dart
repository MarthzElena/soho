import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsWidget.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/ui/about/about.dart';
import 'package:soho_app/ui/about/location.dart';
import 'package:soho_app/ui/auth/login.dart';
import 'package:soho_app/ui/auth/register.dart';
import 'package:soho_app/ui/home/home.dart';
import 'package:soho_app/ui/payments/methods.dart';
import 'package:soho_app/ui/profile/check_profile.dart';
import 'package:soho_app/ui/profile/edit_profile.dart';
import 'package:soho_app/ui/purchases/orders.dart';

class Routes {
  static String root = "/";
  static String login = "Login";
  static String homePage = "HomePage";
  static String categoryDetail = "CategoryDetail/:category";
  static String orderDetail = "OrderDetail";
  static String viewProfile = "ViewProfile";
  static String editProfile = "editProfile";
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

    // Soho Home
    router.define(homePage,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return HomeScreen();
    }), transitionType: TransitionType.fadeIn);

    // Category Detail
    router.define(categoryDetail,
        handler: _categoryDetailHandler, transitionType: TransitionType.inFromRight);

    // Order detail (Shopping cart)
    router.define(orderDetail,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return OrderScreen();
        }));

    // Profile view
    router.define(viewProfile,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          var user = Application.currentUser;
          if (user != null) {
            if (user.userPhoneNumber.isEmpty) {
              CheckProfileScreen(name: user.username, email: user.email, photo: user.photoUrl,);
            }
            return CheckProfileScreen(name: user.username, phone: user.userPhoneNumber, email: user.email, photo: user.photoUrl,);
          }
          return CheckProfileScreen();
        }));

    // Edit Profile
    router.define(editProfile,
        handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          var user = Application.currentUser;
          if (user != null) {
            print("phone number ${user.userPhoneNumber}");
            if (user.userPhoneNumber.isEmpty) {
              return EditProfileScreen(name: user.username, email: user.email);
            }
            return EditProfileScreen(name: user.username, phone: user.userPhoneNumber, email: user.email);
          } else {
            return EditProfileScreen();
          }
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
