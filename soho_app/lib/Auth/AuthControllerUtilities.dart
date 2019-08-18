import 'dart:convert';

class AuthControllerUtilities {


  static Map<String, dynamic> createUserDictionary(String lastName, String firstName, String email, String userId, String birthDate, String gender, String phoneNumber) {
    // Create string
    var userString = '{"apellidos":"$lastName", "nombre":"$firstName","email":"$email","fecha_nacimiento":"$birthDate","id":"$userId","sexo":"$gender","telefono":"$phoneNumber"}';
    Map<String, dynamic> user = json.decode(userString);
    return user;
  }

}