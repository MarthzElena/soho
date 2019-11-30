import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Routes.dart';

class NoUserMenuWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 96, 73, 73)
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 16.0, right: 16.0),
              child: Container(
                height: 406,
                decoration: BoxDecoration(
                  color: Color.fromARGB(204, 243, 241, 242),
                  borderRadius: BorderRadius.all(Radius.circular(16.0))
                ),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 37.0),
                        child: Image(
                          image: AssetImage('assets/home/menu_logo.png'),
                        ),
                      ),
                    ), // LOGO
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 23.0, left: 16.0),
                        child: Text(
                          'Inicia sesión ahora',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 4.0, right: 20.0),
                        child: Text(
                          'Inicia sesión ahora para que puedas disfrutar de todo lo que SOHO tiene para tí.',
                          style: TextStyle(
                              color: Color.fromARGB(255, 90, 98, 101),
                              fontSize: 12.0,
                              height: 1.3
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        height: 50,
                        width: 218,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.login);
                          },
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50.0))
                          ),
                          textColor: Colors.white,
                          color: Color.fromARGB(255, 240, 171, 49),
                        ),
                      ),
                    ), // Login button
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        height: 50,
                        width: 218,
                        child: FlatButton(
                          onPressed: () {
//                            Navigator.pushNamed(context, Routes.login);
                          },
                          child: Text(
                            'Iniciar sesión con Facebook',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50.0))
                          ),
                          textColor: Colors.white,
                          color: Color.fromARGB(255, 59, 89, 152),
                        ),
                      ),
                    ), // Facebook button
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        '¿No tienes cuenta?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 86, 87, 88),
                          fontSize: 14.0
                        ),
                      ),
                    ), // No tienes cuenta?
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.register);
                        },
                        child: Text(
                          'Crea una cuenta aquí',
                          style: TextStyle(
                            color: Color.fromARGB(255, 229, 31, 79),
                            fontSize: 14.0,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    )
                  ],
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
                      Image(
                        image: AssetImage('assets/menu/icon_about.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Acerca de Soho',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 228, 228, 228)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ), // Acerca de Soho (icon + text)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 114.0, left: 30.0),
                child: Container(
                  height: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/menu/icon_locations.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Text(
                          'Ubicaciones',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 228, 228, 228)
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