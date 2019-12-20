import 'package:get_it/get_it.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/States/LoginState.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/States/RegisterState.dart';
import 'package:soho_app/States/CategoryItemsState.dart';
import 'package:soho_app/SohoMenu/OrderDetailState.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/States/EditProfileState.dart';
import 'package:soho_app/States/add_method.dart';

GetIt locator = GetIt();

void setUpLocator() {
  // Login State
  locator.registerFactory<LoginState>(() => LoginState());
  // Register State
  locator.registerFactory<RegisterState>(() => RegisterState());

  // Singletons
  locator.registerLazySingleton<AddMethodState>(() => AddMethodState());
  // Category Detail State
  locator.registerLazySingleton<CategoryItemsState>(() => CategoryItemsState());
  // Auth Controller
  locator.registerLazySingleton<AuthController>(() => AuthController());
  // Product item state
  locator.registerLazySingleton<ProductItemState>(() => ProductItemState());
  // Home Page State
  locator.registerLazySingleton<HomePageState>(() => HomePageState());
  // Order Detail State
  locator.registerLazySingleton<OrderDetailState>(() => OrderDetailState());
  // Edit Profile State
  locator.registerLazySingleton<UserProfileState>(() => UserProfileState());
}