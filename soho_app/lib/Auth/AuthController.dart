/// AuthController.dart
///
/// This  class manages the  Authentication process of the user.
///
/// Created by: Martha Elena Loera
///
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthController {

  final storage = new FlutterSecureStorage();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Returns a SohoAuthObject if there's a token saved
  Future<FirebaseUser> getSavedAuthObject() async{

    // Get the user from the saved credentials
    // Read the token (if any)
    String token = await storage.read(key: Constants.KEY_AUTH_TOKEN);
    String provider = await storage.read(key: Constants.KEY_AUTH_PROVIDER);
    bool tokenValid = token != null && token.isNotEmpty;
    bool providerValid = provider != null && provider.isNotEmpty;

    if (tokenValid && providerValid) {

      switch (provider) {
        case Constants.KEY_FACEBOOK_PROVIDER:
          {
            // Facebook Login
            var facebookUser = firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: token)).catchError((error) {
              //TODO: handle error!!
              return null;
            });
            if (facebookUser != null) {
              return facebookUser;
            }
          }
          break;

        case Constants.KEY_GOOGLE_PROVIDER:
          {
            // Google Login
          }
          break;

        case Constants.KEY_EMAIL_PROVIDER:
          {
            // Email Login
          }
          break;

      }

    }

    return null;

  }

  Future<FirebaseUser> initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
    await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        // TODO: Add some error!
        return null;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        return null;
      case FacebookLoginStatus.loggedIn:
        // Save auth data and provider
        await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_FACEBOOK_PROVIDER);
        await storage.write(key: Constants.KEY_AUTH_TOKEN, value: facebookLoginResult.accessToken.token);

        // Save user to  Firebase
        var facebookUser = firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: facebookLoginResult.accessToken.token));

        return facebookUser;

      default:
        return null;
    }
  }


}