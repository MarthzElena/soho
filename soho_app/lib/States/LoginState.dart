import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/ui/auth/register.dart';
import 'package:soho_app/ui/items/onboarding_item.dart';

import '../Auth/SohoUserObject.dart';

class LoginState extends Model {
  TextEditingController phoneInputController = TextEditingController();
  String phoneInput = "";
  String smsCode = "";
  String _phoneVerificationId = "";
  String inputValidationMessage = "";
  AppController authController = locator<AppController>();

  Future<String> facebookLoginPressed(BuildContext context) async {
    var errorValue = "";
    await authController.initiateFacebookLogin().then((error) {
      if (Application.currentUser != null) {
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        errorValue = error.isEmpty ? "Error al iniciar sesión con Facebook." : error;
        Fluttertoast.showToast(
            msg: errorValue,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 4,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0x99E51F4F),
            textColor: Colors.white
        );
      }
    });
    return errorValue;
  }

  Future<String> googleLoginPressed(BuildContext context) async {
    var errorString = "";
    await authController.initiateGoogleLogin().then((error) {
      if (Application.currentUser != null) {
        Navigator.pushNamed(context, Routes.homePage);
      } else {
        errorString = error.isEmpty ? "Error con Google Login" : error;
      }
    });
    return errorString;
  }

  Future<void> signInWithPhoneCredential(BuildContext context, AuthCredential credential) async {
    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential).catchError((signInError) async {
      Fluttertoast.showToast(
          msg: 'Error con el número de télefono',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 5,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0x99E51F4F),
          textColor: Colors.white
      );
    });
    var appController = locator<AppController>();
    if (user != null) {
      bool isNewUser = await appController.isNewUser(user.uid);
      if (isNewUser) {
        // Create user dictionary for Database
        var userDictionary = SohoUserObject.createUserDictionary(
            username: "",
            email: "",
            userId: user.uid,
            phoneNumber: phoneInput,
            isAdmin: false,
            photoUrl: "",
            firstTime: true
        );
        // Get token
        await user.getIdToken(refresh: true).then((token) async {
          await appController.savePhoneCredentials().then((_) async {
            await appController.saveUserToDatabase(userDictionary);
            locator<HomePageState>().updateDrawer();
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }).catchError((tokenError) async {
          Fluttertoast.showToast(
              msg: 'Error con usuario al iniciar sesión con teléfono',
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIos: 5,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Color(0x99E51F4F),
              textColor: Colors.white
          );
        });
        // Go to register to get missing information
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RegisterScreen(phoneInput, user.uid))
        );
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        // Start session in app
        await appController.startSessionFromUserId(user.uid).then((_) {
          var user = Application.currentUser;
          if (user != null && user.isFirstTime) {
            // Go to onboarding
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()));
          }
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Error con usuario al iniciar sesión con teléfono',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 5,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0x99E51F4F),
          textColor: Colors.white
      );
    }
  }

  signIn(BuildContext context, String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _phoneVerificationId,
        smsCode: smsCode,
      );
      await signInWithPhoneCredential(context, credential);
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
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            await signInWithPhoneCredential(context, phoneAuthCredential);
          },
          verificationFailed: (AuthException exception) async {
            Fluttertoast.showToast(
                msg: 'Error con verificación de télefono. Asegurate de incluir el código de país perteneciente al número de teléfono.',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIos: 5,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Color(0x99E51F4F),
                textColor: Colors.white
            );
          });
    } catch (e) {
      handleError(e, context);
    }
  }

  handleError(PlatformException error, BuildContext context) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        Fluttertoast.showToast(
            msg: 'Código de verificación inválido',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 5,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0x99E51F4F),
            textColor: Colors.white
        );
        break;
      default:
        Fluttertoast.showToast(
            msg: 'Error al iniciar sesión con télefono',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 5,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0x99E51F4F),
            textColor: Colors.white
        );
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
            style: thinStyle(fSize: 24.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Ingresa el código de acceso',
                  style: boldStyle(fSize: 14.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Enviamos un mensaje de texto con un código de 6 digitos a tu número celular.',
                  style: lightStyle(fSize: 14.0),
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
                    style: lightStyle(
                      fSize: 14.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: '- - - - - -',
                      counterText: "",
                      hintStyle: lightStyle(
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
                  style: lightStyle(
                    fSize: 14.0,
                    color: Color(0xff789090),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Reenviar código de acceso',
                  style: regularStyle(
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
                        style: boldStyle(
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
