import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Application.dart';

class UserProfileState extends Model{
  // Updated values
  String updatedName = "";
  String updatedEmail = "";
  String updatedPhone = "";
  // Display data
  String name = "";
  String email = "";
  String phone = "";

  void updateDisplayName(String name) {
    this.name = name;
    notifyListeners();
  }

  void updateDisplayEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void updateDisplayPhone(String phone) {
    this.phone = phone;
    notifyListeners();
  }

  void updateUserData() {
    if (Application.currentUser != null) {
      // Update name
      if (updatedName.isNotEmpty) {
        if (updatedName != Application.currentUser.username) {
          Application.currentUser.username = updatedName;
          updateDisplayName(updatedName);
        }
      }
      // Update phone
      if (updatedPhone.isNotEmpty) {
        if (updatedPhone != Application.currentUser.userPhoneNumber) {
          Application.currentUser.userPhoneNumber = updatedPhone;
          updateDisplayPhone(updatedPhone);
        }
      }
      // Update email
      if (updatedEmail.isNotEmpty) {
        if (updatedEmail != Application.currentUser.email) {
          Application.currentUser.email = updatedEmail;
          updateDisplayEmail(updatedEmail);
        }
      }
    }
    notifyListeners();
  }
}