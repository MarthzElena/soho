
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderQR.dart';
import 'package:soho_app/States/HomePageState.dart';
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

  final storage = locator<FlutterSecureStorage>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final DatabaseReference dataBaseRootRef = FirebaseDatabase.instance.reference().root();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  // Returns a SohoAuthObject if there's a token saved
  Future<void> getSavedAuthObject() async{

    // Get the user from the saved credentials
    // Check if Firebase has a stored user
    await firebaseAuth.currentUser().then((user) async {
      if (user != null) {
        // Update user token and  get user from database
        await user.getIdToken(refresh: true);
        await startSessionFromUserId(user.uid);
      }
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
    await storage.delete(key: Constants.KEY_AUTH_PROVIDER).then((_) async {
      // Clear saved user locally
      Application.currentUser = null;
    });
  }

  Future<void> savePhoneCredentials() async {
    await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_PHONE_PROVIDER);
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
            // Save user to Firebase Auth
            await firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: facebookToken)).then((user) async {
              var firebaseId = user.uid;
              // Get user data
              await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=$facebookToken').then((graphResponse) async {
                var profile = json.decode(graphResponse.body);
                var email = profile['email'].toString();
                var username = profile['name'].toString();
                var userId = firebaseId;
                var photoUrl = "";
                var picture = profile['picture'];
                if (picture != null) {
                  var pictureData = picture['data'];
                  if (pictureData != null) {
                    photoUrl = pictureData['url'];
                  }
                }

                var user = SohoUserObject.createUserDictionary(
                    username: username,
                    email: email,
                    userId: userId,
                    photoUrl: photoUrl,
                    phoneNumber: "",
                    isAdmin: false,
                    firstTime: true
                );
                await saveUserToDatabase(user);
              });
            });
          }).catchError((error) {
            // TODO: Handle error
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
              username: googleUser.displayName,
              email: googleUser.email,
              userId: googleUser.uid,
              photoUrl: googleUser.photoUrl,
              phoneNumber: googleUser.phoneNumber == null ? "" : googleUser.phoneNumber,
              isAdmin: false
          );

          await saveUserToDatabase(user).then((_) async {

            // Make sure to save credentials only if login is completed
            await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_GOOGLE_PROVIDER);

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

  Future<bool> isNewUser(String userId) async {
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var savedUser = usersRef.child(userId);

    DataSnapshot item = await savedUser.once().catchError((databaseError) {
      print("Database fetch error: ${databaseError.toString()}");
      return true;
    });
    if (item.value == null) {
      // Something failed, treat user as new
      return true;
    } else {
      LinkedHashMap linkedMap = item.value;
      Map<String, dynamic> user = linkedMap.cast();
      if (user == null) {
        // Something failed, treat user as new
        return true;
      } else {
        if (user[SohoUserObject.keyUsername].isEmpty) {
          // User is new
          return true;
        } else {
          // User is not new, update values with database and save locally
          var sohoUser = SohoUserObject(
              username: user[SohoUserObject.keyUsername],
              email: user[SohoUserObject.keyEmail] == null ? "" : user[SohoUserObject.keyImageUrl],
              userId: user[SohoUserObject.keyUserId],
              photoUrl: user[SohoUserObject.keyImageUrl] == null ? "" : user[SohoUserObject.keyImageUrl],
              userPhoneNumber: user[SohoUserObject.keyPhone] == null ? "" : user[SohoUserObject.keyImageUrl]
          );

          // Save locally
          Application.currentUser = sohoUser;
          // Update home page state
          locator<HomePageState>().updateDrawer();
          return false;
        }
      }
    }
  }

  Future<void> startSessionFromUserId(String userId) async {
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var savedUser = usersRef.child(userId);

    await savedUser.once().then((item) async {
      if (item != null && item.value != null) {
        LinkedHashMap linkedMap = item.value;
        Map<String, dynamic> user = linkedMap.cast();
        if (user != null) {
          // Create local user
          var sohoUser = SohoUserObject.fromJson(user);
          // Save locally
          Application.currentUser = sohoUser;
          // Update home page state
          locator<HomePageState>().updateDrawer();
        }
      }
    }).catchError((databaseError) {
      print("Database fetch error: ${databaseError.toString()}");
    });
  }

  Future<void> updateUserInDatabase(Map<String, dynamic> user) async {
    // Get user from database
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var userId = user[SohoUserObject.keyUserId];
    var userDB = usersRef.child(userId);

    await userDB.set(user);

  }

  Future<bool> saveUserToDatabase(Map<String, dynamic> user) async {
    // Check if user already exists in DataBase, and save if not
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var userId = user[SohoUserObject.keyUserId];
    var savedUser = usersRef.child(userId);

    // Create Soho user
    var sohoUser = SohoUserObject(
        username: user[SohoUserObject.keyUsername],
        email: user[SohoUserObject.keyEmail],
        userId: user[SohoUserObject.keyUserId],
        photoUrl: user[SohoUserObject.keyImageUrl],
        userPhoneNumber: user[SohoUserObject.keyPhone]
    );

    // Save locally
    Application.currentUser = sohoUser;
    // Update home page state
    locator<HomePageState>().updateDrawer();
    
    await savedUser.once().then((item) async {
      if (item.value == null) {
        var newUserRef = usersRef.child(userId);
        // Push the new user reference to the database
        await newUserRef.set(user).then((_) {
          newUserRef.push();
        });
      } else {
        // Update user values with database
        if (item.value != null) {
          LinkedHashMap linkedMap = item.value;
          Map<String, dynamic> userDict = linkedMap.cast();
          if (userDict != null) {
            // Save locally
            Application.currentUser = SohoUserObject.fromJson(userDict);
            // Update home page state
            locator<HomePageState>().updateDrawer();
          }
        }
      }
      return true;
    });

    return true;
  }

  Future<String> saveImageToCloud(String fileName, File file) async {
    var storageReference = firebaseStorage.ref().child(fileName);
    final uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final String url = await downloadUrl.ref.getDownloadURL();
    if (Application.currentUser != null) {
      Application.currentUser.photoUrl = url;
    }
    return url;
  }

  Future<void> completeKitchenOrder(DateTime completionDate, String username) async {
    var kitchenOrdersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_KITCHEN_ORDERS);
    // Get existing orders
    await kitchenOrdersRef.once().then((value) async {
      if (value != null && value.value != null) {
        List<dynamic> linkedMap = value.value;
        List<Map<String, dynamic>> updatedOrders = List<Map<String, dynamic>>();
        for (var element in linkedMap) {
          var sohoOrder = SohoOrderQR();
          sohoOrder.parseLinkedList(element);
          // Only add if it is not the completed order
          if (sohoOrder.userName != username || sohoOrder.order.completionDate.toIso8601String() != completionDate.toIso8601String()) {
            // Add to updated orders for database
            updatedOrders.add(sohoOrder.getJson());
          }
        }
        await kitchenOrdersRef.set(updatedOrders);
      }
    });
  }

  Future<void> sendOrderToKitchen(Map<String, dynamic> order, DateTime completionDate) async {
    var kitchenOrdersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_KITCHEN_ORDERS);

    // Get user from DB
    var savedUser = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS).child(order[SohoOrderQR.keyUserId]);
    // Remove order from user ongoing orders
    await savedUser.once().then((item) async {
      if (item.value != null) {
        LinkedHashMap linkedMap = item.value;
        Map<String, dynamic> userDict = linkedMap.cast();
        if (userDict != null) {
          var orderUser = SohoUserObject.fromJson(userDict);
          var ongoingOrders = orderUser.ongoingOrders;
          var index = 0;
          for (var ongoing in ongoingOrders) {
            if (ongoing.completionDate == completionDate) {
              var completedOrder = orderUser.ongoingOrders.removeAt(index);
              completedOrder.isQRCodeValid = false;
              orderUser.pastOrders.add(completedOrder);
              await updateUserInDatabase(orderUser.getJson());
              break;
            }
            index += 1;
          }
        }
      }
    });

    // Get existing values
    await kitchenOrdersRef.once().then((value) async {
      if (value.value == null) {
        // List is empty, add first value
        var newKitchenOrder = kitchenOrdersRef.child("0");
        await newKitchenOrder.set(order).then((_) {
          newKitchenOrder.push();
        });
      } else {
        // List already exists, update
        List<dynamic> linkedMap = value.value;
        List<Map<String, dynamic>> updatedOrders = List<Map<String, dynamic>>();
        for (var element in linkedMap) {
          var sohoOrder = SohoOrderQR();
          sohoOrder.parseLinkedList(element);
          updatedOrders.add(sohoOrder.getJson());
        }
        // Add new element
        updatedOrders.add(order);
        await kitchenOrdersRef.set(updatedOrders);

      }
    }).catchError((error) {
      //TODO: handle error
      print("Error from updating kitchen orders database ${error.toString()}");
    });

  }

  Future<List<SohoOrderQR>> getKitchenOrders() async {
    var result = List<SohoOrderQR>();
    var kitchenOrdersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_KITCHEN_ORDERS);
    await kitchenOrdersRef.once().then((item){
      if (item != null && item.value != null) {
        List<dynamic> linkedMap = item.value;
        for (var element in linkedMap) {
          var sohoOrder = SohoOrderQR();
          sohoOrder.parseLinkedList(element);
          result.add(sohoOrder);
        }
      }
    }).catchError((error) {
      //TODO: handle error
      print("Error from database ${error.toString()}");
    });

    return result;

  }

}