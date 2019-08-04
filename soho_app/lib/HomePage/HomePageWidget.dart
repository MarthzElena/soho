import 'package:flutter/material.dart';

import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Routes.dart';

class HomePageWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}


class _HomePageState extends State<HomePageWidget> {

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
            RaisedButton(
                onPressed: () => onLogoutPressed(context),
                child: Text("Log Out"))
          ],
        ),
      ),
    );
  }

  // TODO: Put this in the proper place!!
  Future<void> onLogoutPressed(BuildContext  context) async {
    await AuthController().logoutUser().then((_) {
      // User is logged out, go to Login
      Navigator.pushNamed(context, Routes.login);
    });
  }
}