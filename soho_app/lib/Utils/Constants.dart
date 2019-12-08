/// Constants.dart
///
/// This contains all the static and final constants used.
///
/// Created by: Martha Elena Loera

class Constants {

  /// Secure Storage - Auth credentials
  static const KEY_AUTH_TOKEN = "KEY_AUTH_TOKEN";
  static const KEY_AUTH_PROVIDER = "KEY_AUTH_PROVIDER";
  static const KEY_AUTH_PHONE_NUMBER = "KEY_SAVED_PHONE_NUMBER";
  /// Secure Storage - Saved Provider
  static const KEY_FACEBOOK_PROVIDER = "KEY_FACEBOOK_PROVIDER";
  static const KEY_GOOGLE_PROVIDER = "KEY_GOOGLE_PROVIDER";
  static const KEY_PHONE_PROVIDER = "KEY_PHONE_PROVIDER";

  /// Firebase Database keys
  static const DATABASE_KEY_USERS = "usuarios";

  /// Dictionary keys for user
  static const DICT_KEY_EMAIL = "email";
  static const DICT_KEY_NAME = "nombre";
  static const DICT_KEY_LAST_NAME = "apellidos";
  static const DICT_KEY_BIRTH_DATE = "fecha_nacimiento";
  static const DICT_KEY_ID = "id";
  static const DICT_KEY_GENDER = "sexo";
  static const DICT_KEY_PHONE = "telefono";
  static const DICT_KEY_IS_ADMIN = "isAdmin";
  static const DICT_KEY_PAST_ORDERS = "past_orders";
  static const DICT_KEY_ONGOING_ORDERS = "ongoing_orders";

  /// Category Items
  static const PARAM_CATEGORY_NAME = "DIC_KEY_CATEGORY_NAME";

  /// UI Constants
  static const APP_BAR_HEIGHT = 54.0;
}