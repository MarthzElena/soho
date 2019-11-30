import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:soho_app/Payments/card_information.dart';
import 'package:soho_app/Payments/stripe_token.dart';

import 'package:soho_app/SohoApp.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';

void main() {

  // Initial config
  final Router _router = Router();
  Routes.setUpRouter(_router);
  setUpLocator();
  
  runApp(MaterialApp(
    home: SohoApp(),
    theme: ThemeData(fontFamily: 'InterUI'),
    debugShowCheckedModeBanner: false,
    onGenerateRoute: _router.generator,
  ));

}



