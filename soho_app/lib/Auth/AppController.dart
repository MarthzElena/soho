
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderQR.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soho_app/Utils/Locator.dart';

class AppController {

  final storage = locator<FlutterSecureStorage>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final DatabaseReference dataBaseRootRef = FirebaseDatabase.instance.reference().root();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookLogin = FacebookAuth.instance;

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
    // Logout the user
    await logoutPhoneUser();
  }

  void deleteAuthStoredValues() {
    // Clear saved user locally
    Application.currentUser = null;
  }

  Future<void> savePhoneCredentials() async {
    await storage.write(key: Constants.KEY_AUTH_PROVIDER, value: Constants.KEY_PHONE_PROVIDER);
  }

  Future<void> logoutPhoneUser() async {
    await firebaseAuth.signOut().then((_) async {
      deleteAuthStoredValues();
    });
  }

  Future<String> initiateFacebookLogin() async {
    var errorString = "";
    await facebookLogin.login(permissions: ['email']).then((result) async {
      if (result.status == 200) {
        await firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: result.accessToken.token)).then((user) async {
          var firebaseId = user.uid;
          // Get user data
          await facebookLogin.getUserData(fields: "email, name, picture").then((userData) async {
            if (userData != null) {
              var email = userData["email"].toString();
              var name = userData["name"].toString();
              var pictureDict = userData["picture"];
              var pictureData = pictureDict["data"];
              var pictureURL = pictureData["url"].toString();
              // Save user data to DB
              var user = SohoUserObject.createUserDictionary(
                  username: name,
                  email: email,
                  userId: firebaseId,
                  photoUrl: pictureURL,
                  phoneNumber: "",
                  isAdmin: false,
                  firstTime: true
              );
              await saveUserToDatabase(user);
            } else {
              errorString = "Error al iniciar sesión con Facebook.";
            }
          });
        });
      } else if (result.status == 403){
        print("CancelledByUser");
      } else {
        print("Error");
        errorString = "Error al iniciar sesión con Facebook.";
      }
    }).catchError((error) {
      errorString = "Error al iniciar sesión con Facebook.";
      return errorString;
    });

    return errorString;
  }

  Future<String> initiateGoogleLogin() async {
    var errorString = "";
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

          await saveUserToDatabase(user);

        }).catchError((fireBaseSignInError) {
          errorString = "Error al iniciar sesión con Google.";
        });

      }).catchError((authenticationError) {
        print("Authentication error: ${authenticationError.toString()}");
        errorString = "Error al validar usuario";
      });

    }).catchError((signInError) {
      print("Sign in error: ${signInError.toString()}");
      errorString = "Error durante Login";
    });
    return errorString;

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
          // Update payments info
          await Application.currentUser.getCardsShortInfo();
          // Update home page state
          locator<HomePageState>().updateDrawer();
        }
      }
    }).catchError((databaseError) {
      print("Database fetch error: ${databaseError.toString()}");
    });
  }

  Future<SohoUserObject> getUser({String forId, bool updateCurrentUser}) async {
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var user = usersRef.child(forId);
    SohoUserObject sohoUser;

    await user.once().then((item) async {
      if (item != null && item.value != null) {
        LinkedHashMap linkedMap = item.value;
        Map<String, dynamic> user = linkedMap.cast();
        if (user != null) {
          // Create local user
          sohoUser = SohoUserObject.fromJson(user);
          // Validate ongoing orders are still valid
          List<SohoOrderObject> invalidOrder = List<SohoOrderObject>();
          for (var order in sohoUser.ongoingOrders) {
            var orderDate = order.completionDate;
            if (!isQrCodeValid(orderDate)) {
              sohoUser.pastOrders.add(order);
              invalidOrder.add(order);
            }
          }
          // Remove invalid orders
          for (var oldOrder in invalidOrder) {
            sohoUser.ongoingOrders.remove(oldOrder);
          }
          if (invalidOrder.isNotEmpty) {
            await updateUserInDatabase(sohoUser.getJson());
            if (updateCurrentUser) {
              Application.currentUser = sohoUser;
            }
          }
        }
      }
      return null;
    });

    return sohoUser;
  }

  Future<void> updateUserInDatabase(Map<String, dynamic> user) async {
    // Get user from database
    var usersRef = dataBaseRootRef.child(Constants.DATABASE_KEY_USERS);
    var userId = user[SohoUserObject.keyUserId];
    var userDB = usersRef.child(userId);

    await userDB.set(user);

  }

  Future<void> saveUserToDatabase(Map<String, dynamic> user) async {
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
            // Update payments info
            await Application.currentUser.getCardsShortInfo();
          }
        }
      }
    });
  }

  Future<void> getFeaturedImageFromStorage() async {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      var featuredPhotosArray = dataBaseRootRef.child(Constants.DATABASE_KEY_FEATURED_IMAGES);
      // Get photos array
      await featuredPhotosArray.once().then((array) async {
        if (array.value != null) {
          LinkedHashMap linkedMap = array.value;
          if (linkedMap != null) {
           var max = linkedMap.entries.length;
           if (max > 0) {
             var index = Random().nextInt(max);
             var photoUrl = linkedMap.entries.elementAt(index).value.toString();
             if (photoUrl != null && photoUrl.isNotEmpty) {
               // Get storage reference
               await firebaseStorage.getReferenceFromUrl(photoUrl).then((storageReference) async {
                 if (storageReference != null) {
                   final String photoUrl = await storageReference.getDownloadURL();
                   // Save image to Application
                   if (photoUrl != null && photoUrl.isNotEmpty) {
                     Application.featuredProduct = photoUrl;
                     locator<HomePageState>().updateState();
                   } else {
                     Application.featuredProduct = "";
                   }
                 }
               }).catchError((_) {
                 Application.featuredProduct = "";
               });
             } else {
               Application.featuredProduct = "";
             }
           } else {
             Application.featuredProduct = "";
           }
          } else {
            Application.featuredProduct = "";
          }
        } else {
          Application.featuredProduct = "";
        }
      }).catchError((error) {
        Application.featuredProduct = "";
      });
    });
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

  Future<String> sendOrderToKitchen(Map<String, dynamic> order, DateTime completionDate) async {
    var errorString = "";
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
      errorString = "Error al obtener órdenes de cocina de la base de datos.";
    });
    return errorString;
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
      print("Error from database ${error.toString()}");
      result = List<SohoOrderQR>();
    });

    return result;

  }

  bool isQrCodeValid(DateTime codeGenerated) {
    var currentDate = DateTime.now();
    final daysDifference = currentDate.difference(codeGenerated).inDays;
    final daysAbsolute = daysDifference.abs();

    return daysAbsolute <= 7;
  }

}