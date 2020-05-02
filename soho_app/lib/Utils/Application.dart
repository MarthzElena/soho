import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';

class Application {

  // Current logged in user
  static SohoUserObject currentUser;

  static List<CategoryObject> sohoCategories = List<CategoryObject>();

  // Current order for user (items on shopping cart)
  // Once the order is completed, this value should be set to NULL
  static SohoOrderObject currentOrder;

  // URL for featured product photo (home featured image)
  static String featuredProduct = "";

  // Stripe Secret Key
  static String stripeSecretKey = 'sk_test_mqnEbY0xP8nctWWQ8PHMnJ7k009KT8V3LN';

}