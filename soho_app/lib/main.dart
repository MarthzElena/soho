import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/FBPush.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/splash/splash.dart';

Future main() async {
  final Router _router = Router();

  Routes.setUpRouter(_router);
  setUpLocator();

  final FirebaseMessaging _fireBaseMsg = FirebaseMessaging();
  _fireBaseMsg.requestNotificationPermissions();
  setupFireBase(_fireBaseMsg);

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
