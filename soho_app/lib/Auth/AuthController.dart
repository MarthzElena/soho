
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soho_app/Utils/Locator.dart';

class AuthController {

  static final storage = new FlutterSecureStorage();
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final DatabaseReference dataBaseRootRef = FirebaseDatabase.instance.reference().root();
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  String _phoneVerificationId = "";

  // Returns a SohoAuthObject if there's a token saved
  Future<void> getSavedAuthObject() async{

    // Get the user from the saved credentials
    // Read the token (if any)
    await storage.read(key: Constants.KEY_AUTH_TOKEN).then((token) async {
      await storage.read(key: Constants.KEY_AUTH_PROVIDER).then((provider) async {
        bool tokenValid = token != null && token.isNotEmpty;
        bool providerValid = provider != null && provider.isNotEmpty;
        await storage.read(key: Constants.KEY_AUTH_PHONE_NUMBER).then((phone) async {
          String savedPhone = phone == null ? "" : phone;

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
                              }
                            }
                          });
                        }
                      }
                    }
                  }).catchError((facebookLoginError) {
                    print("Facebook Login Error: ${facebookLoginError.toString()}");
                  });
                }
                break;

              case Constants.KEY_GOOGLE_PROVIDER:
                {
                  // Google Login
                  await initiateGoogleLogin();

                }
                break;

              case Constants.KEY_PHONE_PROVIDER:
                {
                  // Phone Login
//                  await initiatePhoneLogin(savedPhone, "", "");
                }
                break;

            }

          }
        });

      });
    });
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

      case Constants.KEY_PHONE_PROVIDER:
        {
          // Logout Phone
          await logoutPhoneUser();
        }
        break;
    }

  }

  Future<void> deleteAuthStoredValues() async {
    await storage.delete(key: Constants.KEY_AUTH_TOKEN).then((_) async {
      await storage.delete(key: Constants.KEY_AUTH_PROVIDER).then((_) async {
        await storage.delete(key: Constants.KEY_AUTH_PHONE_NUMBER).then((_) async {
          // Clear saved user locally
          Application.currentUser = null;
        });
      });
    });
  }

  Future<void> logoutPhoneUser() async {
    await firebaseAuth.signOut().then((_) async {
      await deleteAuthStoredValues();
    });
  }

  Future<void> initiateFacebookLogin() async {
    // TODO: This permissions should be used: 'email,user_gender,user_birthday'
    await facebookLogin.logInWithReadPermissions(['email']).then((facebookLoginResult) async {

      var facebookToken = facebookLoginResult.accessToken.token;
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
            await storage.write(key: Constants.KEY_AUTH_TOKEN, value: facebookToken).then((_) async {
              // Save user to Firebase Auth
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

    }).catchError((error) {
      // TODO: Handle error
      return null;
    });
  }

  Future<void> logoutFacebook() async {
    // Logout from the provider
    await facebookLogin.logOut().then((_) async {
      // Remove values from storage
      await deleteAuthStoredValues();
    });
  }

  Future<void> initiateGoogleLogin() async {
    await googleSignIn.signIn().then((googleSignInAccount) async {

      await googleSignInAccount.authentication.then((googleAuth) async {

        // Get credentials
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
            await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_GOOGLE_PROVIDER).then((_) async {
              await storage.write(key: Constants.KEY_AUTH_TOKEN, value: googleAuth.accessToken);
            });

          });

        }).catchError((fireBaseSignInError) {
          // TODO: Handle error
          print("Sign in Firebase error: ${fireBaseSignInError.toString()}");
        });

      }).catchError((authenticationError) {
        print("Authentication error: ${authenticationError.toString()}");
      });

    }).catchError((signInError) {
      print("Sign in error: ${signInError.toString()}");
    });

  }

  Future<void> logoutGoogle() async {
    // Logout from provider
    await googleSignIn.signOut();
    // Remove stored values
    await deleteAuthStoredValues();
  }

  Future<bool> _isNewUser(String userId) async {
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var savedUser = usersRef.child(userId);

    DataSnapshot item = await savedUser.once().catchError((databaseError) {
      print("Database fetch error: ${databaseError.toString()}");
      return true;
    });
    if (item.value == null) {
      return false;
    } else {
      Map<String, String> user = item.value.cast();
      return user[Constants.DICT_KEY_NAME].isEmpty;
    }
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
    // Update home page state
    locator<HomePageState>().updateDrawer();
    
    await savedUser.once().then((item){
      if (item.value == null) {
        var newUserRef = usersRef.child(userId);
        // Push the new user reference to the database
        newUserRef.set(user).then((_) {
          newUserRef.push();
        });
      } else {
        // Update user values with database
        // TODO
      }
    });
  }

}