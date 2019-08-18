import 'package:get_it/get_it.dart';
import 'package:soho_app/Auth/LoginStateController.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/Auth/RegisterStateController.dart';

GetIt locator = GetIt();

void setUpLocator() {
  // Login State
  locator.registerFactory<LoginState>(() => LoginState());
  // Register State
  locator.registerFactory<RegisterState>(() => RegisterState());
  // Home Page State
  locator.registerFactory<HomePageState>(() => HomePageState());

}