import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/items/onboarding_item.dart';

class NoUserMenuWidget extends StatelessWidget {
  final AppController authController = locator<AppController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Color.fromARGB(255, 96, 73, 73)),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 16.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(204, 243, 241, 242),
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
                        style: interBoldStyle(fSize: 16.0),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Inicia sesión ahora para que puedas disfrutar de todo lo que SOHO tiene para tí.',
                        style: interLightStyle(fSize: 12.0),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.login);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xffF0AB31),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Center(
                            child: Text(
                              'Iniciar sesión',
                              style: interBoldStyle(
                                fSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          locator<HomePageState>().updateSpinner(show: true);
                          authController.initiateFacebookLogin().then((_) {
                            locator<HomePageState>().updateSpinner(show: false);
                            // Check first user
                            var user = Application.currentUser;
                            if (user != null && user.isFirstTime) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()));
                            }
                            // Make sure drawer is updated
                            locator<HomePageState>().updateDrawer();
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xff3B5998),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Center(
                            child: Text(
                              'Entrar con Facebook',
                              style: interBoldStyle(
                                fSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          locator<HomePageState>().updateSpinner(show: true);
                          authController.initiateGoogleLogin().then((_) {
                            locator<HomePageState>().updateSpinner(show: false);
                            // Check first user
                            var user = Application.currentUser;
                            if (user != null && user.isFirstTime) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()));
                            }
                            // Make sure drawer is updated
                            locator<HomePageState>().updateDrawer();
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Color(0xffE51F4F),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Center(
                            child: Text(
                              'Entrar con Gmail',
                              style: interBoldStyle(
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
                          style: interLightStyle(fSize: 14.0),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          'Crea una cuenta aquí',
                          style: interMediumStyle(
                            fSize: 14.0,
                            decoration: TextDecoration.underline,
                            color: Color(0xffE51F4F),
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
                          style: interMediumStyle(
                            fSize: 14.0,
                            color: Color(0xffE4E4E4),
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
                          'Ubicaciones',
                          style: interMediumStyle(
                            fSize: 14.0,
                            color: Color(0xffE4E4E4),
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
