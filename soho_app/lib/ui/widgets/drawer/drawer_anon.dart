import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/auth/login.dart';
import 'package:soho_app/ui/items/onboarding_item.dart';

class NoUserMenuWidget extends StatelessWidget {
  final AppController authController = locator<AppController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 16.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffebe7e4),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Center(
                        child: Image(
                          image: AssetImage('assets/home/menu_logo.png'),
                        ),
                      ),
                      SizedBox(height: 23.0),
                      Text(
                        'Inicia sesión ahora',
                        style: boldStyle(fSize: 16.0),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Inicia sesión ahora para que puedas disfrutar de todo lo que SOHO tiene para tí.',
                        style: regularStyle(fSize: 12.0),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => LoginScreen())
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                              color: Color(0xffCCC5BA),
                              width: 2
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Iniciar sesión',
                              style: boldStyle(
                                fSize: 14.0,
                                color: Color(0xff604848),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          locator<HomePageState>().updateSpinner(show: true);
                          await authController.initiateFacebookLogin().then((error) async {
                            if (error.isNotEmpty) {
                              Fluttertoast.showToast(
                                  msg: error,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIos: 4,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Color(0x99E51F4F),
                                  textColor: Colors.white
                              );
                            } else {
                              locator<HomePageState>().updateSpinner(show: false);
                              // Check first user
                              var user = Application.currentUser;
                              if (user != null && user.isFirstTime) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()));
                              }
                              // Make sure drawer is updated
                              locator<HomePageState>().updateDrawer();
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xffCCC5BA),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Center(
                            child: Text(
                              'Entrar con Facebook',
                              style: boldStyle(
                                fSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          locator<HomePageState>().updateSpinner(show: true);
                          await authController.initiateGoogleLogin().then((error) async {
                            if (error.isNotEmpty) {
                              await showDialog(
                                context: context,
                                child: SimpleDialog(
                                  title: Text(error),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              locator<HomePageState>().updateSpinner(
                                  show: false);
                              // Check first user
                              var user = Application.currentUser;
                              if (user != null && user.isFirstTime) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OnboardingScreen()));
                              }
                              // Make sure drawer is updated
                              locator<HomePageState>().updateDrawer();
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xffCCC5BA),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Center(
                            child: Text(
                              'Entrar con Gmail',
                              style: boldStyle(
                                fSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 26.0),
                      Center(
                        child: Text(
                          '¿No tienes cuenta?',
                          style: lightStyle(fSize: 14.0),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => LoginScreen())
                          );
                        },
                        child: Center(
                          child: Text(
                            'Crea una cuenta aquí',
                            style: regularStyle(
                              fSize: 14.0,
                              decoration: TextDecoration.underline,
                              color: Color(0xff565758),
                              fWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 54.0, left: 30.0),
                child: Container(
                  height: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 20.0,
                        height: 20.0,
                        child: Center(
                          child: Image(
                            image: AssetImage('assets/menu/icon_about.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Acerca de Soho',
                          style: regularStyle(
                            fSize: 14.0,
                            color: Color(0xff604848),
                            fWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 114.0, left: 30.0),
                child: Container(
                  height: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 20.0,
                        height: 20.0,
                        child: Center(
                          child: Image(
                            image: AssetImage('assets/menu/icon_locations.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Text(
                          'Ubicación',
                          style: regularStyle(
                            fSize: 14.0,
                            color: Color(0xff604848),
                            fWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ) // Ubicaciones (icon + text)
          ],
        ),
      ),
    );
  }
}
