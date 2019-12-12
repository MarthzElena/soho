import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Application.dart';

class EditProfileState extends Model{
  String updatedName = "";
  String updatedEmail = "";
  String updatedPhone = "";

  void updateUserData() {
    if (Application.currentUser != null) {
      // Update name
      if (updatedName.isNotEmpty) {
        if (updatedName != Application.currentUser.username) {
          Application.currentUser.username = updatedName;
        }
      }
      // Update phone
      if (updatedPhone.isNotEmpty) {
        if (updatedPhone != Application.currentUser.userPhoneNumber) {
          Application.currentUser.userPhoneNumber = updatedPhone;
        }
      }
      // Update email
      if (updatedEmail.isNotEmpty) {
        if (updatedEmail != Application.currentUser.email) {
          Application.currentUser.email = updatedEmail;
        }
      }
    }
  }
}