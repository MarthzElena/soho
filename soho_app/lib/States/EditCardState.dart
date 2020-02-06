import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Models/requests/update_card.dart';
import 'package:soho_app/Network/update_card/call.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/payments/check_method.dart';

class EditCardState extends Model {
  // Selected card ID
  String selectedCardId = "";

  // Updated values
  String updatedName = "";
  String updatedMonth = "";
  String updatedYear = "";
  String updatedCVV = "";

  bool showSpinner = false;

  // Editing controllers
  TextEditingController nameController = TextEditingController();
  MaskedTextController expDateController = MaskedTextController(
    text: '',
    mask: '00/00',
  );

  void updateSpinner({bool show}) {
    showSpinner = show;
    notifyListeners();
  }

  void initData(String cardId, String name, String date) {
    updatedName = "";
    updatedMonth = "";
    updatedYear = "";
    updatedCVV = "";

    nameController.text = name;
    expDateController.text = date;

    selectedCardId = cardId;
  }

  Future<void> updateCardData() async {
    if (Application.currentUser != null) {
      if (updatedMonth.isNotEmpty && updatedYear.isNotEmpty) {
        // Validate date is future date
        var monthToday = DateTime.now().month;
        var yearToday = DateTime.now().year;
        var cardMonth = int.parse(updatedMonth);
        // Get current year first 2 digits
        var currentYearString = yearToday.toString();
        var first2 = currentYearString.substring(0,2);
        var cardYear = int.parse("$first2$updatedYear");
        if (yearToday.compareTo(cardYear) < 0) {
          if (monthToday.compareTo(cardMonth) < 0) {
            // Update data on model for check_method.dart
            locator<CheckMethodsState>().updateDate("$updatedMonth/$updatedYear");
            // Check if name needs to be updated
            if (updatedName.isNotEmpty) {
              locator<CheckMethodsState>().updateName(updatedName);
            }

            await executeUpdateRequest(cardMonth.toString(), cardYear.toString());
          } else {
            showInvalidExpirationDate();
          }
        } else {
          showInvalidExpirationDate();
        }

      } else {
        // Update only card name
        locator<CheckMethodsState>().updateName(updatedName);
        await executeUpdateRequest("", "");
      }
    }
  }

  Future<void> executeUpdateRequest(String cardMonth, String cardYear) async {
    // Validation for empty name is done in the request
    var request = UpdateCardRequest(name: updatedName, expMonth: cardMonth, expYear: cardYear);
    await updateCardCall(request: request, customerId: Application.currentUser.stripeId, cardId: selectedCardId).then((response) {
      // Update the card info
      for (var card in Application.currentUser.cardsReduced) {
        if (card.cardId == response.id) {
          card.cardName = response.name;
          // Get new expiration date
          var yearString = response.expYear.toString().substring(2);
          var monthString = response.expMonth < 10 ? "0${response.expMonth.toString()}" : response.expMonth.toString();
          card.expiration = "$monthString / $yearString";
          break;
        }
      }
      print("BACK TO VIEW CARD");
    }).catchError((error) {
      // TODO: Handle error
      print("Error in updateCardRequest: ${error.toString()}");
    });
  }

  void showInvalidExpirationDate() {
    // TODO: Show UI that expiration date is invalid
    print("EXPIRATION DATE INVALID");
  }
}