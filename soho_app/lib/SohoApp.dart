import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/HomePage/HomeMainUIWidget.dart';
import 'package:fluro/fluro.dart';

import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Auth/LoginUIWidget.dart';

class SohoApp extends StatefulWidget {

  @override
  State createState() {
    return SohoAppState();
  }

}

class SohoAppState extends State<SohoApp> {
  SohoAppState() {
    // Initial config
    setUpRouter(_router);
    setUpLocator();
  }
  final Router _router = Router();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: FutureBuilder<FirebaseUser>(
          future: AuthController().getSavedAuthObject(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {

            if (snapshot.data != null) {
              return  HomeMainUIWidget().build(context);
            } else {
              return LoginUIWidget().build(context);
            }
            },
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _router.generator,
    );

  }

}

class Splash extends State<SohoApp> {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Text('SPLASH!!'),
      ),
    );
  }
}