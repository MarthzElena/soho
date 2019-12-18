import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Payments/stripe_token.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/payments/add_method.dart';
import 'package:soho_app/ui/splash/splash.dart';

Future main() async {
  final Router _router = Router();

  Routes.setUpRouter(_router);
  setUpLocator();

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _router.generator,
      title: 'Soho',
      home: SplashScreen(),
    ),
  );
}
