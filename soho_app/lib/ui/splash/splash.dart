import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/home/home.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/layouts/preconfigured_layout.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      SquareHTTPRequest.getSquareCategories().then((categories) {

        // Get logged in user if any
        locator<AuthController>().getSavedAuthObject().then((isLoggedIn) {

          if (categories.isNotEmpty) {
            Application.sohoCategories = categories;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        });


      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreConfiguredLayout(
      buildWidget: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image(image: splashLogo),
            SizedBox(height: 45.0),
            Image(
              image: splashScratch,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
