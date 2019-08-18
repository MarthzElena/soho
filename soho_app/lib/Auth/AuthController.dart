
/// AuthController.dart
///
/// This  class manages the  Authentication process of the user.
///
/// Created by: Martha Elena Loera
///
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AuthControllerUtilities.dart';

class AuthController {

  final storage = new FlutterSecureStorage();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference dataBaseRootRef = FirebaseDatabase.instance.reference().root();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  // Returns a SohoAuthObject if there's a token saved
  Future<FirebaseUser> getSavedAuthObject({String password = ""}) async{

    // Get the user from the saved credentials
    // Read the token (if any)
    String token = await storage.read(key: Constants.KEY_AUTH_TOKEN);
    String provider = await storage.read(key: Constants.KEY_AUTH_PROVIDER);
    bool tokenValid = token != null && token.isNotEmpty;
    bool providerValid = provider != null && provider.isNotEmpty;
    String savedEmail = await storage.read(key: Constants.KEY_SAVED_EMAIL);
    savedEmail = savedEmail == null ? "" : savedEmail;

    if (tokenValid && providerValid) {

      switch (provider) {
        case Constants.KEY_FACEBOOK_PROVIDER:
          {
            // Facebook Login
            var facebookUser = firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: token));
            if (facebookUser != null) {
              return facebookUser;
            }
          }
          break;

        case Constants.KEY_GOOGLE_PROVIDER:
          {
            // Google Login
            var googleUser = await initiateGoogleLogin();
            if (googleUser != null) {
              return googleUser;
            }
          }
          break;

        case Constants.KEY_EMAIL_PROVIDER:
          {
            // Email Login
            if (password.isNotEmpty && savedEmail.isNotEmpty) {
              var emailUser = await initiateEmailLogin(userEmail: savedEmail, userPassword: password);
              if (emailUser != null) {
                return emailUser;
              }
            } else {
              //TODO: handle error!!
              return null;
            }
          }
          break;

      }

    }

    return null;

  }

  Future<void> logoutUser() async {
    // Get the current Auth provider
    String provider = await storage.read(key: Constants.KEY_AUTH_PROVIDER);
    // Logo utt he  respective provider
    switch (provider) {
      case Constants.KEY_FACEBOOK_PROVIDER:
        {
          // Logout Facebook
          await logoutFacebook();
        }
        break;

      case Constants.KEY_GOOGLE_PROVIDER:
        {
          // Logout Google
          await logoutGoogle();
        }
        break;

      case Constants.KEY_EMAIL_PROVIDER:
        {
          // Logout Email
          await logoutEmailUSer();
        }
        break;
    }

  }

  Future<void> deleteAuthStoredValues() async {
    await storage.delete(key: Constants.KEY_AUTH_TOKEN);
    await storage.delete(key: Constants.KEY_AUTH_PROVIDER);
  }

  Future<FirebaseUser> initiateEmailLogin({String userEmail, String userPassword}) async {
    FirebaseUser emailUser = await firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword).catchError((error) {
      // TODO: Handle error
      return null;
    });

    // Save credentials
    await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_EMAIL_PROVIDER);
    String userToken = await emailUser.getIdToken(refresh: true).catchError((error) {
      // TODO: Handle error
      return null;
    });
    await storage.write(key: Constants.KEY_AUTH_TOKEN, value: userToken);

    // Return user
    return emailUser;

  }

  Future<void> logoutEmailUSer() async {
    // Logout from Firebase
    await firebaseAuth.signOut();
    // Delete saved values for Auth
    await deleteAuthStoredValues();
  }

  Future<FirebaseUser> initiateFacebookLogin() async {
    // TODO: This permissions should be used: 'email,user_gender,user_birthday'
    var facebookLoginResult =
    await facebookLogin.logInWithReadPermissions(['email']).catchError((error) {
      // TODO: Handle error
      return null;
    });

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        // TODO: Handle error
        return null;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        return null;
      case FacebookLoginStatus.loggedIn:
        // Save auth data and provider
        await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_FACEBOOK_PROVIDER);
        await storage.write(key: Constants.KEY_AUTH_TOKEN, value: facebookLoginResult.accessToken.token);

        // Save user to  Firebase Auth
        var facebookToken = facebookLoginResult.accessToken.token;
        var facebookUser = await firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: facebookToken)).catchError((error) {
          // TODO: Handle error
          return null;
        });

        // Get user data
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,user_gender,user_birthday&access_token=$facebookToken');
        var profile = json.decode(graphResponse.body);
        var email = profile['email'].toString();
        var firstName = profile['first_name'].toString();
        var lastName = profile['last_name'].toString();
        var userId = profile['id'].toString();
        // TODO: Get this values later!
        var birthDate = profile['user_birthday'];
        var gender = profile['user_gender'];

        // Check if user already exists in DataBase, and save if not
        var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);

        var savedUser = usersRef.child(userId);

        savedUser.once().then((item){
          if (item.value == null) {
            var newUserRef = usersRef.child(userId);
            // Create the dictionary and parse it
            var user = AuthControllerUtilities.createUserDictionary(lastName, firstName, email, userId, "", "", "");
            // Push the new user reference to the database
            newUserRef.set(user).then((_) {
              newUserRef.push();
            });

          } else {
            // Get user data from database
            // TODO: Do something with this user
          }
        });

        return facebookUser;

      default:
        return null;
    }
  }

  Future<void> logoutFacebook() async {
    // Logout from the provider
    await facebookLogin.logOut();
    // Remove values from storage
    await deleteAuthStoredValues();
  }

  Future<FirebaseUser> initiateGoogleLogin() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleAuth = await googleSignInAccount.authentication;

    final googleCredential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken);
    final googleUser = await firebaseAuth.signInWithCredential(googleCredential).catchError((error) {
      // TODO: Handle error
      return null;
    });

    // Make sure to save credentials only if login is completed
    await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_GOOGLE_PROVIDER);
    await storage.write(key: Constants.KEY_AUTH_TOKEN, value: googleAuth.accessToken);

    return googleUser;

  }

  Future<void> logoutGoogle() async {
    // Logout from provider
    await googleSignIn.signOut();
    // Remove stored values
    await deleteAuthStoredValues();
  }


}