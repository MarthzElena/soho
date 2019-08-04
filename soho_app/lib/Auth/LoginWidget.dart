import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Auth/LoginStateController.dart';

class LoginWidget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    // Return State for Login
    return _LoginState();
  }
}

class _LoginState extends State<LoginWidget> {
  LoginState loginState = locator<LoginState>();

  @override
  Widget build(BuildContext context) {

    return ScopedModel<LoginState>(
      model: loginState,
      child: ScopedModelDescendant<LoginState>(builder: (builder, child, model) {
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
                    onChanged: (value) {
                      // TODO: Validate text
                      model.emailInput = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 23, right: 0.0, bottom: 0.0),
                    child: Text('Contraseña'),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                    ),
                    onChanged: (value) {
                      // TODO: Validate text
                      model.passwordInput = value;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 32.0, right: 0.0, bottom: 16.0),
                      child: RaisedButton(
                        onPressed: () => emailLoginPressed(context: context,  email: model.emailInput, password: model.passwordInput),
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
                        onPressed: () => facebookLoginPressed(context),
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
                      onPressed: () => googleLoginPressed(context),
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
      }),
    );
  }

  Future<void> facebookLoginPressed(BuildContext context) async {

    await AuthController().initiateFacebookLogin().then((facebookUser) {
      if (facebookUser != null) {
        // TODO: Do something with this user?
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** FACEBOOK Login ERROR");
      }
    });
  }

  Future<void> googleLoginPressed(BuildContext context) async {

    await AuthController().initiateGoogleLogin().then((googleUser) {
      if (googleUser != null) {
        // TODO: Do something with this user?
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** Google Login ERROR");
      }
    });

  }

  Future<void> emailLoginPressed({BuildContext context, String email, String password}) async {

    await AuthController().initiateEmailLogin(userEmail: email, userPassword: password).then((emailUser) {
      if (emailUser != null) {
        // TODO: Do something with this user?
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** Email Login ERROR");
      }
    });

  }

}
