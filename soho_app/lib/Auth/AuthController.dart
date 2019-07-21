/// AuthController.dart
///
/// This  class manages the  Authentication process of the user.
///
/// Created by: Martha Elena Loera
///
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Constants.dart';


class AuthController {

  // Returns a SohoAuthObject if there's a token saved
  Future<void> getSavedAuthObject() async{
    // Create a secure storage
    final storage = new FlutterSecureStorage();
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

  }



}