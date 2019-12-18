import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class RegisterState extends Model {

  // Validation tools
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  bool autoValidate = false;

  // Registration field values
  String nameInput = "";
  String lastNameInput = "";
  String emailInput = "";
  String passwordInput = "";
  String phoneNumber = "";


}