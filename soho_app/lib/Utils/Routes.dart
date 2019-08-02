import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:soho_app/SohoApp.dart';
import 'package:soho_app/Auth/AuthWidget.dart';
import 'package:soho_app/HomePage/HomePageWidget.dart';

void setUpRouter(Router router) {

  // Main route
  router.define(
      '/',
      handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return SohoApp();
          }),
      transitionType: TransitionType.native
  );

  // Auth
  router.define(
      'Auth',
      handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return AuthWidget();
          }),
      transitionType: TransitionType.native
  );

  // Soho Home
  router.define(
      'Home',
      handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return HomePageWidget();
        }),
      transitionType: TransitionType.native
  );

}