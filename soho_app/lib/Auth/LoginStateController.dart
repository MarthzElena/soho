import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginState extends Model {
  // TODO: Validate phone and password
  String phoneInput = "";
  String passwordInput = "";
  String _phoneVerificationId = "";

  TextEditingController code1 = TextEditingController();
  TextEditingController code2 = TextEditingController();
  TextEditingController code3 = TextEditingController();
  TextEditingController code4 = TextEditingController();
  TextEditingController code5 = TextEditingController();
  TextEditingController code6 = TextEditingController();

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
      final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
      if (user != null) {
        print("****LOGIN SUCCESS!!!");
      } else {
        print("*** ERROR with user");
      }
    } catch (e) {
      handleError(e, context);
    }
  }

  Future<void> verifyPhone(BuildContext context) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this._phoneVerificationId = verId;
      smsCodeDialog(context).then((_) {
        print('**** SUCCESSSSSS');
      });
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
          smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e, context);
      print("TRY CATCH error: ${e.toString()}");
    }
  }

  handleError(PlatformException error, BuildContext context) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        print("*** INVALID CODE!!");
        break;
      default:
        print("*** SOME ERROR!!");

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
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFieldSoho(controller: code1),
                      TextFieldSoho(controller: code2),
                      TextFieldSoho(controller: code3),
                      TextFieldSoho(controller: code4),
                      TextFieldSoho(controller: code5),
                      TextFieldSoho(controller: code6),
                    ],
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
                    String smsCode = code1.value.text + code2.value.text + code3.value.text + code4.value.text + code5.value.text + code6.value.text;
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
