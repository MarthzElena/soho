import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


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

class _SplashScreen extends State<SohoHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/splash/soho_splash_chafa.png'),
        ),
      ),
    );
  }
  
}
