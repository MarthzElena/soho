import 'package:get_it/get_it.dart';
import 'package:soho_app/Auth/LoginStateController.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/Auth/RegisterStateController.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsStateController.dart';

GetIt locator = GetIt();

void setUpLocator() {
  // Login State
  locator.registerFactory<LoginState>(() => LoginState());
  // Register State
  locator.registerFactory<RegisterState>(() => RegisterState());
  // Home Page State
  locator.registerFactory<HomePageState>(() => HomePageState());
  // Category Detail State
  locator.registerFactory<CategoryItemsState>(() => CategoryItemsState());

}