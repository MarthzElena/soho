import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Locator.dart';

class UserProfileState extends Model{
  // Updated values
  String updatedName = "";
  String updatedEmail = "";
  String updatedPhone = "";
  // Display data
  String name = "";
  String email = "";
  String phone = "";
  String photoUrl = "";

  File _imageFile;

  // TODO: Change this with default image
  AssetImage photoPlaceholder = AssetImage('assets/auth/bamboo.png');

  void setPhotoUrl(String photo) {
    this.photoUrl = photo;
    notifyListeners();
  }

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
      notifyListeners();
    }
  }

  void getImageFile(ImageSource source, context) async {
    await ImagePicker.pickImage(source: source).then((image) async {
      await ImageCropper.cropImage(
        sourcePath: image.path,
        maxWidth: 512,
        maxHeight: 512,
      ).then((croppedFile) async {
        await FlutterImageCompress.compressAndGetFile(
          croppedFile.path,
          croppedFile.path,
          quality: 80,
        ).then((compressedFile) async {
          _imageFile = compressedFile;
          photoPlaceholder = AssetImage(compressedFile.path);

          // Upload image
          // If user is not available, name the file with path
          var fileName = _imageFile.path;
          if (Application.currentUser != null) {
            fileName = Application.currentUser.userId;
          }
          await locator<AppController>().saveImageToCloud(fileName, _imageFile).then((imageUrl) {
            // Upload of image is complete, update image
            photoUrl = imageUrl;
            // Update homepage drawer
            locator<HomePageState>().updateDrawer();
            notifyListeners();
          });

          notifyListeners();

          Navigator.of(context).pop();
        });
      });
    });
  }
}