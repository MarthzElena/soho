import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:soho_app/Auth/RegisterStateController.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';

import 'AuthController.dart';
import 'AuthControllerUtilities.dart';

class RegisterWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // Return state for Register
    return _RegisterState();
  }

}


class _RegisterState  extends State<RegisterWidget> {
  RegisterState registerState = locator<RegisterState>();

  @override
  Widget build(BuildContext context) {

    return ScopedModel<RegisterState>(
      model: registerState,
      child: ScopedModelDescendant<RegisterState>(builder: (builder, child, model) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
              children: <Widget>[
                Text('Soho'),
                Text('Registrar cuenta nueva'),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 20, right: 0.0, bottom: 0.0),
                  child: Text('Nombre(s)'),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                  ),
                  onChanged: (value) {
                    // TODO: Validate text
                    model.nameInput = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10, right: 0.0, bottom: 0.0),
                  child: Text('Apellido(s)'),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                  ),
                  onChanged: (value) {
                    // TODO: Validate text
                    model.lastNameInput = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10, right: 0.0, bottom: 0.0),
                  child: Text('Correo electrónico'),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                    hintText: 'ejemplo@correo.com',
                  ),
                  onChanged: (value) {
                    // TODO: Validate text
                    model.emailInput = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10, right: 0.0, bottom: 0.0),
                  child: Text('Teléfono celular'),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                    hintText: '33 3333 3333',
                  ),
                  onChanged: (value) {
                    // TODO: Validate text
                    model.phoneNumber = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10, right: 0.0, bottom: 0.0),
                  child: Text('Contraseña'),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1.0)),
                  ),
                  onChanged: (value) {
                    // TODO: Validate text
                    model.passwordInput = value;
                  },
                ),
                // TODO: Add inputs for gender and birth date
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 0.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () => createAccountPressed(context),
                      child: Text('Crear Cuenta'),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 0.0),
                    child: Text(
                      'O también puedes',
                      textAlign: TextAlign.center,
                      textWidthBasis: TextWidthBasis.parent,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 10.0),
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
                  padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '¿Ya tienes una cuenta? ',
                        textAlign: TextAlign.center,
                        textWidthBasis: TextWidthBasis.parent,
                      ),
                      InkWell(
                        onTap: () {Navigator.pushNamed(context, Routes.login);},
                        child: Text(
                          'Iniciar Sesión',
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
        );
      }),
    );
  }
  
  Future<void> createAccountPressed(BuildContext context) async {
    // Create user dictionary
    var user = AuthControllerUtilities.createUserDictionary(
        registerState.lastNameInput,
        registerState.nameInput,
        registerState.emailInput,
        "",
        registerState.birthInput,
        registerState.genderInput,
        registerState.phoneNumber
    );

    await AuthController().createUserWithEmail(user, registerState.passwordInput).then((registeredUser) {
      if (registeredUser != null) {
        // TODO: Do something with the user
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** EMAIL Login ERROR");
      }
    });

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

}