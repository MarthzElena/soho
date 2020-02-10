import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Models/requests/add_new_card.dart';
import 'package:soho_app/Models/requests/charge_customer.dart';
import 'package:soho_app/Models/requests/create_customer.dart';
import 'package:soho_app/Models/requests/update_card.dart';
import 'package:soho_app/Models/responses/create_customer.dart';
import 'package:soho_app/Network/add_new_card/call.dart';
import 'package:soho_app/Network/charge_customer/call.dart';
import 'package:soho_app/Network/create_customer/call.dart';
import 'package:soho_app/Network/delete_card/call.dart';
import 'package:soho_app/Network/get_all_cards/call.dart';
import 'package:soho_app/Network/get_customer/call.dart';
import 'package:soho_app/Network/update_card/call.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/payments/methods.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:stripe_payment/stripe_payment.dart';

class AddMethodState extends Model {
  TextEditingController nameController = TextEditingController();
  MaskedTextController numberController = MaskedTextController(
    text: '',
    mask: '0000-0000-0000-0000',
  );
  MaskedTextController expDateController = MaskedTextController(
    text: '',
    mask: '00/00',
  );
  TextEditingController cvvController = TextEditingController();

  CreditCard card;
  Token cardToken = Token();
  var charge = {'0.01', 'MXN'};
  bool showSpinner = false;

  void updateSpinner({bool show}) {
    showSpinner = show;
    notifyListeners();
  }

  void clearControllerValues() {
    nameController.text = "";
    numberController.text = "";
    expDateController.text = "";
    cvvController.text = "";
  }

  Future<String> getCardInformation(BuildContext context) async {
    var stringError = "";
    if (nameController.text.trim().isNotEmpty &&
        numberController.text.trim().isNotEmpty &&
        expDateController.text.trim().isNotEmpty &&
        cvvController.text.trim().isNotEmpty &&
        Application.currentUser != null) {
      // Show spinner
      updateSpinner(show: true);
      card = CreditCard(
        number: numberController.text.trim(),
        expMonth: int.parse(expDateController.text.substring(0, 2).trim()),
        expYear: int.parse(expDateController.text.substring(3, 5).trim()),
        name: nameController.text.trim(),
        cvc: cvvController.text.trim(),
      );
      var email = Application.currentUser.email;

      await StripePayment.createTokenWithCard(card).then((token) async {
        cardToken = token;

        // Check if customer is new
        if (Application.currentUser.stripeId.isEmpty) {
          // Create new customer
          var request = CreateCustomerRequest(
            description: nameController.text.trim(),
            source: cardToken.tokenId.trim(),
            email: email,
          );
          await createCustomerCall(request: request).then((response) async {
            // Add Stripe id to the current user
            await Application.currentUser.addStripeId(response.id).then((result) async {
              await completeCardInformation(result, context);

            }).catchError((error) {
              setError(error, "Error in addStripeId: ");
              stringError = "Error al agregar ID de Sripe";
            });
          }).catchError((error) {
            setError(error, "Error in createCustomerCall: ");
            stringError = "Error al crear cliente de Stripe";
          });
        } else {
          // Add new card to existing customer
          var request = AddNewCardRequest(source: cardToken.tokenId.trim());
          await addNewCardCall(request: request, customerId: Application.currentUser.stripeId).then((response) async {
            // Add card added to user info for UI purposes
            await completeCardInformation(true, context).catchError((error) {
              setError(error, "Error in completeCardInformation: ");
              stringError = "Error al agregar datos de tarjeta al usuario";
            });
          }).catchError((error) {
            setError(error, "Error in addNewCardCall: ");
            stringError = "Error al agregar nueva tarjeta";
          });
        }


      }).catchError((error) {
        setError(error, "Error in createTokenWithCard: ");
        stringError = "Error al guardar tarjeta";
      });
    } else {
      // TODO: Show missing info error
      stringError = "Falta información de la tarjeta";
    }
    // Make sure spinner is dismissed
    updateSpinner(show: false);
    return stringError;
  }

  Future<void> completeCardInformation(bool result, BuildContext context) async {
    // Update local user cards info
    await Application.currentUser.getCardsShortInfo();
    // Verify if add method was successful
    if (!result) {
      // TODO: Handle error fail to save card
    }
    // Update methods screen state and pop view
    locator<MethodsScreenState>().updateState();
    Navigator.pop(context);
  }

  void checkIfCustomerExists({customerId, stripeTkn}) async {
    Future.delayed(Duration(seconds: 1)).then((_) {
      getCustomerCall(customerId: customerId);
    });
  }

  void setError(dynamic error, String info) {
    print('$info: ' + error.toString());
  }

  Future<void> cvvDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image(
                  image: menuCross,
                  width: 22.0,
                  height: 22.0,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '¿No sabes que es el código CVV?',
                  style: interBoldStyle(fSize: 14.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'El código CVV son los tres números que se encuentran al reverso de tu tarjeta.',
                  style: interLightStyle(fSize: 14.0),
                ),
                SizedBox(height: 20.0),
                Image(
                  image: blueCard,
                  width: MediaQuery.of(context).size.width,
                  height: 157.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
