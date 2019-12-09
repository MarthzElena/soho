import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'SohoUserObject.dart';

class LoginState extends Model {
  // TODO: Validate phone and password
  String phoneInput = "";
  String passwordInput = "";
  String smsCode = "";
  String _phoneVerificationId = "";

  AuthController authController = locator<AuthController>();

  Future<void> facebookLoginPressed(BuildContext context) async {
    await authController.initiateFacebookLogin().then((_) {
      if (Application.currentUser != null) {
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** FACEBOOK Login ERROR");
      }
    });
  }

  Future<void> googleLoginPressed(BuildContext context) async {
    await authController.initiateGoogleLogin().then((_) {
      if (Application.currentUser != null) {
        // TODO: Do something with this user?
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        // TODO: Show some error
        print("****** Google Login ERROR");
      }
    });
  }

  signIn(BuildContext context, String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _phoneVerificationId,
        smsCode: smsCode,
      );
      final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential).catchError((signInError) {
        print("SIGN IN ERROR: ${signInError.toString()}");
        // TODO: HAndle error
      });
      if (user != null) {
        bool isNewUser = await locator<AuthController>().isNewUser(user.uid);
        if (isNewUser) {
          // TODO: Get this data from Register
          // Create user dictionary for Database
          var userDictionary = SohoUserObject.createUserDictionary(
              lastName: "Loera - telefono",
              firstName: "Martha",
              email: "",
              userId: user.uid,
              phoneNumber: phoneInput,
              isAdmin: false
          );
          // Get token
          await user.getIdToken(refresh: true).then((token) async {
            await locator<AuthController>().savePhoneCredentials(phoneInput, token).then((_) async {
              await locator<AuthController>().saveUserToDatabase(userDictionary);
              Navigator.pop(context);
              Navigator.pop(context);
            });
          }).catchError((tokenError) {
            print("token ERROR: ${tokenError.toString()}");
            // TODO: HAndle error
          });

//          Navigator.pushNamed(context, Routes.register);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        print("*** ERROR with user");
        // TODO: HAndle error
      }
    } catch (e) {
      handleError(e, context);
    }
  }

  Future<void> verifyPhone(BuildContext context) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this._phoneVerificationId = verId;
      smsCodeDialog(context);
    };
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: this.phoneInput, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this._phoneVerificationId = verId;
          },
          codeSent:
          smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            // TODO:
            print("**** Verificatioon COMPLETE! $phoneAuthCredential");
          },
          verificationFailed: (AuthException exception) {
            // TODO: Handle error
            print('Error with verification: ${exception.message}');
          });
    } catch (e) {
      handleError(e, context);
    }
  }

  handleError(PlatformException error, BuildContext context) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        print("*** INVALID CODE!!");
        // TODO: HAndle Error
        break;
      default:
        print("*** SOME ERROR!!");
        // TODO: HAndle Error

        break;
    }
  }

  Future<void> smsCodeDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'CÓDIGO DE ACCESO',
            style: interThinStyle(fSize: 24.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Ingresa el código de acceso',
                  style: interBoldStyle(fSize: 14.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Enviamos un mensaje de texto con un código de 6 digitos a tu número celular.',
                  style: interLightStyle(fSize: 14.0),
                ),
                SizedBox(height: 24.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65.0,
                  child: TextField(
                    onChanged: (value) {
                      smsCode = value;
                    },
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: interLightStyle(
                      fSize: 14.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: '- - - - - -',
                      hintStyle: interLightStyle(
                        fSize: 14.0,
                        color: Color(0xffC4C4C4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        borderSide: const BorderSide(
                          color: Color(0xffE5E4E5),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffE5E4E5),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffE5E4E5),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  '¿No recibiste el código?',
                  style: interLightStyle(
                    fSize: 14.0,
                    color: Color(0xff789090),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Reenviar código de acceso',
                  style: interStyle(
                    fSize: 14.0,
                    color: Color(0xffE51F4F),
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 32.0),
                GestureDetector(
                  onTap: () {
                    signIn(context, smsCode);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
