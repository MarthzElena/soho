import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/items/onboarding_item.dart';
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
      locator<SquareHTTPRequest>().getSquareCategories().then((categories) async {
        AppController authController = locator<AppController>();
        // Get featured photo if any
        await authController.getFeaturedImageFromStorage();

        // Get logged in user if any
        await authController.getSavedAuthObject().then((_) async {
          if (categories.isNotEmpty) {
            Application.sohoCategories = categories;

            // Get card info from square
            if (Application.currentUser != null) {
              await Application.currentUser.getCardsShortInfo();
            }

            // Check if is first time
            String firstTimeSaved = await locator<FlutterSecureStorage>().read(key: Constants.KEY_FIRST_TIME).catchError((error) {
              // Since there's no first time saved, skip Onboarding
              Navigator.of(context).pushReplacementNamed(Routes.homePage);
            });
            var firstTime = firstTimeSaved == null ? true : firstTimeSaved;
            if (Application.currentUser != null) {
              firstTime = Application.currentUser.isFirstTime;

              if (firstTime) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()));
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.homePage);
              }
            } else {
              // If no user is logged in go directly to Home Page
              Navigator.of(context).pushReplacementNamed(Routes.homePage);
            }
          } else {
            Application.sohoCategories = List<CategoryObject>();
            Navigator.of(context).pushReplacementNamed(Routes.homePage);
          }
        }).catchError((_) {
          Navigator.of(context).pushReplacementNamed(Routes.homePage);
        });


      }).catchError((error) {
        Application.sohoCategories = List<CategoryObject>();
        Navigator.of(context).pushReplacementNamed(Routes.homePage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PreConfiguredLayout(
      buildWidget: Container(
        color: Color(0xffEBE7E4),
        constraints: BoxConstraints.expand(),
        child: Center(
          child: Image(image: splashLogo),
        ),
      ),
    );
  }
}
