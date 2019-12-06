import 'package:get_it/get_it.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Auth/LoginStateController.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/Auth/RegisterStateController.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsStateController.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemStateController.dart';

GetIt locator = GetIt();

void setUpLocator() {
  // Login State
  locator.registerFactory<LoginState>(() => LoginState());
  // Register State
  locator.registerFactory<RegisterState>(() => RegisterState());

  // Singletons
  // Category Detail State
  locator.registerLazySingleton<CategoryItemsState>(() => CategoryItemsState());
  // Auth Controller
  locator.registerLazySingleton<AuthController>(() => AuthController());
  // Product item state
  locator.registerLazySingleton<ProductItemState>(() => ProductItemState());
  // Home Page State
  locator.registerLazySingleton<HomePageState>(() => HomePageState());
}