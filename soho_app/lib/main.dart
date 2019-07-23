import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Auth/LoginStateWidget.dart';



void main() => runApp(SohoApp());

class SohoApp extends StatelessWidget {

  // This widget is the root of your application.
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
            return  _SohoHomePageState().build(context);
          } else {
            return LoginStateWidget().build(context);
          }
        },
      ),
    );
  }

}

class SohoHomePage extends StatefulWidget {
  SohoHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SohoHomePageState createState() => _SohoHomePageState();

}

class _SohoHomePageState extends State<SohoHomePage> {

  // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'SOHO',
            ),
            Text(
              'COFFE & TEA',
            ),
          ],
        ),
      ),
    );
  }
}
