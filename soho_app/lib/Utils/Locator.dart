import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/States/EditCardState.dart';
import 'package:soho_app/States/LoginState.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/States/OnboardingState.dart';
import 'package:soho_app/States/RegisterState.dart';
import 'package:soho_app/States/CategoryItemsState.dart';
import 'package:soho_app/SohoMenu/OrderDetailState.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/States/EditProfileState.dart';
import 'package:soho_app/States/SearchState.dart';
import 'package:soho_app/States/add_method.dart';
import 'package:soho_app/ui/payments/check_method.dart';
import 'package:soho_app/ui/payments/methods.dart';

GetIt locator = GetIt();

void setUpLocator() {
  // Login State
  locator.registerFactory<LoginState>(() => LoginState());
  // Register State
  locator.registerFactory<RegisterState>(() => RegisterState());

  // Singletons
  locator.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  locator.registerLazySingleton<OnboardingState>(() => OnboardingState());
  locator.registerLazySingleton<AddMethodState>(() => AddMethodState());
  locator.registerLazySingleton<MethodsScreenState>(() => MethodsScreenState());
  locator.registerLazySingleton<EditCardState>(() => EditCardState());
  locator.registerLazySingleton<CategoryItemsState>(() => CategoryItemsState());
  locator.registerLazySingleton<AppController>(() => AppController());
  locator.registerLazySingleton<ProductItemState>(() => ProductItemState());
  locator.registerLazySingleton<HomePageState>(() => HomePageState());
  locator.registerLazySingleton<OrderDetailState>(() => OrderDetailState());
  locator.registerLazySingleton<UserProfileState>(() => UserProfileState());
  locator.registerLazySingleton<SearchState>(() => SearchState());
  locator.registerLazySingleton<SquareHTTPRequest>(() => SquareHTTPRequest());
  locator.registerLazySingleton<CheckMethodsState>(() => CheckMethodsState());
}