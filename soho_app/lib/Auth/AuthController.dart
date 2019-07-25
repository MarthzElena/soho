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

  // Returns a SohoAuthObject if there's a token saved
  Future<FirebaseUser> getSavedAuthObject() async{

    // First check if there's a current  user in FireBase
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    if (currentUser != null) {
      print("**There's a user!!");
      // Return  the  found user
      return currentUser;

    } else {
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

      print("** No user, do osme login!");
      // TODO: FIX THIS
      return null;
    }

  }

  Future<bool> initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
    await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        // TODO: Add some error!
        return false;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        return false;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        // Save auth data and provider
        await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_FACEBOOK_PROVIDER);
        await storage.write(key: Constants.KEY_AUTH_TOKEN, value: facebookLoginResult.accessToken.token);

        return true;

      default:
        return false;
    }
  }


}