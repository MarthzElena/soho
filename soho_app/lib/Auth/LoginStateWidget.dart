/// LoginstateWidget.dart
///
/// This class manages the widget state for Login.
///
/// Created by: Martha Elena Loera

import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/SohoApp.dart';

class LoginStateWidget extends State<SohoApp> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(left: 20.0, top: 70.0, right: 20.0, bottom: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Soho'),
                Text('Iniciar Sesión'),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 77, right: 0.0, bottom: 0.0),
                  child: Text('Email'),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                      hintText: 'ejemplo@mail.com'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 23, right: 0.0, bottom: 0.0),
                  child: Text('Contraseña'),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 32.0, right: 0.0, bottom: 16.0),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'O también puedes',
                    textAlign: TextAlign.center,
                    textWidthBasis: TextWidthBasis.parent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 16.0, right: 0.0, bottom: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () => facebookLoginPressed(),
                      child: Text(
                        'Iniciar sesión usando Facebook',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'Iniciar sesión usando Google',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 24.0, right: 0.0, bottom: 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '¿No tienes una cuenta? ',
                        textAlign: TextAlign.center,
                        textWidthBasis: TextWidthBasis.parent,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Crear Cuenta',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  void facebookLoginPressed() async {

    var facebookLoginResult = await AuthController().initiateFacebookLogin();

    if (facebookLoginResult) {
      //
    } else {
      // TODO: Show some error
    }
  }

}