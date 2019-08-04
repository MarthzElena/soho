import 'package:flutter/material.dart';

import 'package:soho_app/Splash/SplashWidget.dart';

class SohoApp extends StatefulWidget {

  @override
  State createState() {
    return SohoAppState();
  }

}

class SohoAppState extends State<SohoApp> {

  @override
  Widget build(BuildContext context) {

    return SplashWidget();
  }

}