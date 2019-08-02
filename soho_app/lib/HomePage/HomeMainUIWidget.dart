import 'package:flutter/material.dart';
import 'package:soho_app/SohoApp.dart';

class HomeMainUIWidget extends State<SohoApp> {

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