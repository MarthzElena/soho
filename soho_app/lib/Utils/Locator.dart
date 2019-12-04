import 'package:get_it/get_it.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/Auth/LoginStateController.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/Auth/RegisterStateController.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsStateController.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemStateController.dart';

GetIt locator = GetIt();
CategoryItemsState _categoryItemsState = CategoryItemsState();
AuthController _authController = AuthController();

void setUpLocator() {
  // Login State
  locator.registerFactory<LoginState>(() => LoginState());
  // Register State
  locator.registerFactory<RegisterState>(() => RegisterState());
  // Home Page State
  locator.registerFactory<HomePageState>(() => HomePageState());
  // Product Detail State
  locator.registerFactory<ProductItemState>(() => ProductItemState());

  // Singletons
  // Category Detail State
  locator.registerLazySingleton<CategoryItemsState>(() => _categoryItemsState);
  // Auth Controller
  locator.registerLazySingleton<AuthController>(() => _authController);
}