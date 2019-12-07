import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';

class Application {

  // Current logged in user
  static SohoUserObject currentUser;

  static List<CategoryObject> sohoCategories;

  // Current order for user (items on shopping cart)
  // Once the order is completed, this value should be set to NULL
  static SohoOrderObject currentOrder;


}