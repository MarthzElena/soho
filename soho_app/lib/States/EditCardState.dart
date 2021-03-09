import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Models/requests/update_card.dart';
import 'package:soho_app/Network/update_card/call.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
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

  Future<String> updateCardData(BuildContext context) async {
    var stringError = "";
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

            stringError = await executeUpdateRequest(cardMonth.toString(), cardYear.toString());
          } else {
            stringError = Constants.INVALID_DATE_ERROR;
            showInvalidExpirationDate(context);
          }
        } else {
          stringError = Constants.INVALID_DATE_ERROR;
          showInvalidExpirationDate(context);
        }

      } else {
        // Update only card name
        locator<CheckMethodsState>().updateName(updatedName);
        stringError = await executeUpdateRequest("", "");
      }
    }
    return stringError;
  }

  Future<String> executeUpdateRequest(String cardMonth, String cardYear) async {
    var stringError = "";
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
    }).catchError((error) {
      stringError = "Error al actualizar los datos de la tarjeta.";
      print("Error in updateCardRequest: ${error.toString()}");
    });
    return stringError;
  }

  Future<void> showInvalidExpirationDate(BuildContext context) async {
    updateSpinner(show: false);
    Fluttertoast.showToast(
        msg: "La fecha de expiración es inválida.",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIos: 4,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0x99E51F4F),
        textColor: Colors.white
    );
  }
}