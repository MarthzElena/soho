
/// AuthController.dart
///
/// This  class manages the  Authentication process of the user.
///
/// Created by: Martha Elena Loera
///
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController {

  static final storage = new FlutterSecureStorage();
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final DatabaseReference dataBaseRootRef = FirebaseDatabase.instance.reference().root();
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  // Returns a SohoAuthObject if there's a token saved
  static Future<FirebaseUser> getSavedAuthObject() async{

    // Get the user from the saved credentials
    // Read the token (if any)
    String token = await storage.read(key: Constants.KEY_AUTH_TOKEN);
    String provider = await storage.read(key: Constants.KEY_AUTH_PROVIDER);
    bool tokenValid = token != null && token.isNotEmpty;
    bool providerValid = provider != null && provider.isNotEmpty;
    String savedEmail = await storage.read(key: Constants.KEY_SAVED_EMAIL);
    savedEmail = savedEmail == null ? "" : savedEmail;
    String savedPhone = await storage.read(key: Constants.KEY_SAVED_PHONE_NUMBER);

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
            var googleUser = await _initiateGoogleLogin();
            if (googleUser != null) {
              return googleUser;
            }
          }
          break;

        case Constants.KEY_PHONE_PROVIDER:
          {

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

  Future<void> initiatePhoneLogin(String number, String code) async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) async {
      print("VERIFICATION COMPLETE");
      // Save phone number for credentials
      await storage.write(key: Constants.KEY_SAVED_PHONE_NUMBER, value: number);
    };
    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      print("VERIFICATION FAILED");
    };
    final PhoneCodeSent phoneCodeSent = (String verificationId, [int forceResendingToken]) async {
      print("PHONE CODE SENT");
      print(verificationId);
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      print("PHONE RETRIEVAL TIMEOUT");
    };

    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
  }

  static Future<FirebaseUser> _initiateEmailLogin({String userEmail, String userPassword}) async {
    FirebaseUser emailUser = await firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword).catchError((error) {
      // TODO: Handle error
      return null;
    });

    if (emailUser != null) {
      // Save credentials
      await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_EMAIL_PROVIDER);
      String userToken = await emailUser.getIdToken(refresh: true).catchError((error) {
        // TODO: Handle error
        return null;
      });
      await storage.write(key: Constants.KEY_AUTH_TOKEN, value: userToken);

      // Save user to Database
      var userID = emailUser.uid;
      // Only userID is valid since already a user
      var user = SohoUserObject.createUserDictionary(
          lastName: "",
          firstName: "",
          email: userEmail,
          userId: userID,
          birthDate: "",
          gender: "",
          phoneNumber: "");
      await _saveUserToDatabase(user);

      // Return user
      return emailUser;
    } else {
      return null;
    }

  }
  
  Future<FirebaseUser> createUserWithEmail(Map<String, String> user, String password) async {
    // Create Firebase user
    var userID = "";
    var userAuthToken = "";
    FirebaseUser newUser;
    await firebaseAuth.createUserWithEmailAndPassword(email: user[Constants.DICT_KEY_EMAIL], password: password).then((registeredUser) {
      if (registeredUser != null) {
        // Add provider ID to user
        userID = registeredUser.uid;
      }
      newUser = registeredUser;
    }).catchError((error) {
      // TODO: Handle error
      return null;
    });

    // Check if user  and credentials are valid
    if (newUser != null && userID.isNotEmpty) {
      // Save credentials
      await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_EMAIL_PROVIDER);
      await newUser.getIdToken(refresh: true).then((userToken) {
        userAuthToken = userToken;
      }).catchError((error) {
        // TODO: Handle error\
        return null;
      });

      // Save token to local storage
      if (userAuthToken.isNotEmpty) {
        await storage.write(key: Constants.KEY_AUTH_TOKEN, value: userAuthToken);
      }
      // Add id to dictionary
      user[Constants.DICT_KEY_ID] = userID;
      // Save user to DataBase
      var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
      var newUserRef = usersRef.child(userID);
      await newUserRef.set(user).then((_) {
        newUserRef.push();
      });

      return newUser;

    } else {
      // TODO: HAndle error!
      return null;
    }


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
        var birthDate = profile['user_birthday'] == null ? "" : profile['user_birthday'];
        var gender = profile['user_gender'] == null ? "" : profile['user_gender'];

        var user = SohoUserObject.createUserDictionary(
          lastName: lastName,
          firstName: firstName,
          email: email,
          userId: userId,
          birthDate: birthDate,
          gender: gender,
          phoneNumber: ""
        );
        await _saveUserToDatabase(user);

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

  static Future<FirebaseUser> _initiateGoogleLogin() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleAuth = await googleSignInAccount.authentication;

    final googleCredential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken);
    final googleUser = await firebaseAuth.signInWithCredential(googleCredential).catchError((error) {
      // TODO: Handle error
      return null;
    });

    // Create user dictionary for Database
    var user = SohoUserObject.createUserDictionary(
      lastName: "",
      firstName: googleUser.displayName,
      email: googleUser.email,
      userId: googleUser.uid,
      birthDate: "",
      gender: "",
      phoneNumber: googleUser.phoneNumber == null ? "" : googleUser.phoneNumber
    );
    await _saveUserToDatabase(user);

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

  static Future<void> _saveUserToDatabase(Map<String, String> user) async {
    // Check if user already exists in DataBase, and save if not
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var userId = user[Constants.DICT_KEY_ID];
    var savedUser = usersRef.child(userId);

    await savedUser.once().then((item){
      if (item.value == null) {
        var newUserRef = usersRef.child(userId);
        // Push the new user reference to the database
        newUserRef.set(user).then((_) {
          newUserRef.push();
        });

      } else {
        // Create user data from database
        var user = SohoUserObject(
          lastName: item.value[Constants.DICT_KEY_LAST_NAME],
          firstName: item.value[Constants.DICT_KEY_NAME],
          email: item.value[Constants.DICT_KEY_EMAIL],
          userId: item.value[Constants.DICT_KEY_ID],
          userPhoneNumber: item.value[Constants.DICT_KEY_PHONE]
        );
        user.userBirthDate = item.value[Constants.DICT_KEY_BIRTH_DATE];
        user.userGender = item.value[Constants.DICT_KEY_GENDER];

        // Save locally
        Application.currentUser = user;
      }
    });
  }

}