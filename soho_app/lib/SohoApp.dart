import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/HomePage/HomePageState.dart';

import 'Auth/AuthController.dart';
import 'Auth/LoginStateWidget.dart';

class SohoApp extends StatefulWidget {

  @override
  State createState() {

    return SohoAppState();
  }

}

class SohoAppState extends State<SohoApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'SOHO APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<FirebaseUser>(
        future: AuthController().getSavedAuthObject(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {

          if (snapshot.data != null) {
            return  SohoHomePageState().build(context);
          } else {
            return LoginStateWidget().build(context);
          }
        },
      ),
    );
  }

}