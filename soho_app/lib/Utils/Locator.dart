import 'package:get_it/get_it.dart';
import 'package:soho_app/Auth/LoginStateController.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';

GetIt locator = GetIt();

void setUpLocator() {
  // Login State
  locator.registerFactory<LoginState>(() => LoginState());
  // Home Page State
  locator.registerFactory<HomePageState>(() => HomePageState());
}