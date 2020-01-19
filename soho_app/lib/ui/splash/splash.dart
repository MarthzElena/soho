import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Auth/AuthController.dart';
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
      SquareHTTPRequest.getSquareCategories().then((categories) async {
        AuthController authController = locator<AuthController>();
        // Get featured photo if any
        await authController.getFeaturedImageFromStorage();

        // Get logged in user if any
        await authController.getSavedAuthObject().then((_) async {
          if (categories.isNotEmpty) {
            Application.sohoCategories = categories;

            // Check if is first time
            String firstTimeSaved = await locator<FlutterSecureStorage>().read(key: Constants.KEY_FIRST_TIME);
            var firstTime = firstTimeSaved == null ? true : firstTimeSaved;
            if (Application.currentUser != null) {
              firstTime = Application.currentUser.isFirstTime;
            }
            // TODO: Fix this: only show onboarding if FIRST LOGIN
//            if (firstTime) {
//              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()));
//            } else {
//              Navigator.of(context).pushNamed(Routes.homePage);
//            }
            Navigator.of(context).pushNamed(Routes.homePage);
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
