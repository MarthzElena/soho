
import 'dart:collection';

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
  Future<bool> getSavedAuthObject() async{

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
            await firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: token)).then((facebookUser) async {
              if (facebookUser != null) {
                // Get provider data
                for (var data in facebookUser.providerData) {
                  if (data.providerId == "facebook.com") {
                    var userId = data.uid;
                    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
                    var savedUser = usersRef.child(userId);
                    // Get user from database
                    await savedUser.once().then((item) {
                      if (item != null) {
                        LinkedHashMap linkedMap = item.value;
                        Map<String, String> dictionary = linkedMap.cast();
                        if (dictionary != null) {
                          SohoUserObject sohoUser = SohoUserObject.sohoUserObjectFromDictionary(dictionary);
                          // Save locally
                          Application.currentUser = sohoUser;
                          return true;
                        }
                      }

                      return false;
                    });
                  }
                }
              }
            });
          }
          break;

        case Constants.KEY_GOOGLE_PROVIDER:
          {
            // Google Login
            await initiateGoogleLogin().then((_) {
              if (Application.currentUser != null) {
                return true;
              } else {
                return false;
              }
            });

          }
          break;

        case Constants.KEY_PHONE_PROVIDER:
          {

          }
          break;

      }

    }

    return false;

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
    await storage.delete(key: Constants.KEY_AUTH_TOKEN).then((_) async {
      await storage.delete(key: Constants.KEY_AUTH_PROVIDER).then((_) async {
        // Clear saved user locally
        Application.currentUser = null;
      });
    });
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

  Future<FirebaseUser> initiateEmailLogin({String userEmail, String userPassword}) async {
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

  Future<void> initiateFacebookLogin() async {
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
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;

      case FacebookLoginStatus.loggedIn:
        // Save auth data and provider
        await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_FACEBOOK_PROVIDER).then((_) async {
          await storage.write(key: Constants.KEY_AUTH_TOKEN, value: facebookLoginResult.accessToken.token).then((_) async {
            // Save user to  Firebase Auth
            var facebookToken = facebookLoginResult.accessToken.token;
            await firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: facebookToken)).then((user) async {
              // Get user data
              await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$facebookToken').then((graphResponse) async {
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
              });
          });

          }).catchError((error) {
            // TODO: Handle error
          });
        });

        break;

      default:
        break;
    }
  }

  Future<void> logoutFacebook() async {
    // Logout from the provider
    await facebookLogin.logOut().then((_) async {
      // Remove values from storage
      await deleteAuthStoredValues();
    });
  }

  Future<void> initiateGoogleLogin() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleAuth = await googleSignInAccount.authentication;

    final googleCredential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken);
    await firebaseAuth.signInWithCredential(googleCredential).then((googleUser) async {
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
      await _saveUserToDatabase(user).then((_) async {
        // Make sure to save credentials only if login is completed
        await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_GOOGLE_PROVIDER);
        await storage.write(key: Constants.KEY_AUTH_TOKEN, value: googleAuth.accessToken);
      });

    }).catchError((error) {
      // TODO: Handle error
      print('ERROR X ' + error);
    });

  }

  Future<void> logoutGoogle() async {
    // Logout from provider
    await googleSignIn.signOut();
    // Remove stored values
    await deleteAuthStoredValues();
  }

  Future<void> _saveUserToDatabase(Map<String, String> user) async {
    // Check if user already exists in DataBase, and save if not
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var userId = user[Constants.DICT_KEY_ID];
    var savedUser = usersRef.child(userId);

    // Create Soho user
    var sohoUser = SohoUserObject(
        lastName: user[Constants.DICT_KEY_LAST_NAME],
        firstName: user[Constants.DICT_KEY_NAME],
        email: user[Constants.DICT_KEY_EMAIL],
        userId: user[Constants.DICT_KEY_ID],
        userPhoneNumber: user[Constants.DICT_KEY_PHONE]
    );
    sohoUser.userBirthDate = user[Constants.DICT_KEY_BIRTH_DATE];
    sohoUser.userGender = user[Constants.DICT_KEY_GENDER];

    // Save locally
    Application.currentUser = sohoUser;

    await savedUser.once().then((item){
      if (item.value == null) {
        var newUserRef = usersRef.child(userId);
        // Push the new user reference to the database
        newUserRef.set(user).then((_) {
          newUserRef.push();
        });
      }
    });
  }

}