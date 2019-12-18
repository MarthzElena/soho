import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Models/requests/charge_customer.dart';
import 'package:soho_app/Models/requests/create_customer.dart';
import 'package:soho_app/Network/charge_customer/call.dart';
import 'package:soho_app/Network/create_customer/call.dart';
import 'package:soho_app/Network/get_customer/call.dart';
import 'package:soho_app/Utils/Fonts.dart';
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

  CreditCard testCard;
  Token stripeToken = Token();
  var charge = {'0.01', 'MXN'};

  void getCardInformation() {
    if (nameController.text.trim().isNotEmpty &&
        numberController.text.trim().isNotEmpty &&
        expDateController.text.trim().isNotEmpty &&
        cvvController.text.trim().isNotEmpty) {
      testCard = CreditCard(
        number: numberController.text.trim(),
        expMonth: int.parse(expDateController.text.substring(0, 2).trim()),
        expYear: int.parse(expDateController.text.substring(3, 5).trim()),
        name: nameController.text.trim(),
        cvc: cvvController.text.trim(),
      );

      StripePayment.createTokenWithCard(testCard).then((token) {
        stripeToken = token;
        print('token: ' + stripeToken.toJson().toString());
      }).catchError(setError);
    }
  }

  void chargeCustomer({amounts, customerId, cardId, stripeTnk}) async {
    Future.delayed(Duration(seconds: 1)).then((_) {
      chargeCustomerCall(
        request: ChargeCustomerRequest(
          amount: amounts,
          currency: 'MXN',
          description: '',
          source: cardId,
          customer: customerId,
        ),
        stripeToken: stripeTnk,
      );
    });
  }

  void checkIfCustomerExists({customerId, stripeTkn}) async {
    Future.delayed(Duration(seconds: 1)).then((_) {
      getCustomerCall(customerId: customerId, stripeToken: stripeTkn);
    });
  }

  void createCustomer({stripeTkn}) async {
    Future.delayed(Duration(seconds: 1)).then((_) {
      createCustomerCall(
        request: CreateCustomerRequest(
          description: 'Customer for Soho',
          source: stripeTkn.tokenId,
        ),
        stripeToken: stripeTkn,
      );
    });
  }

  void setError(dynamic error) {
    print('ERROR: ' + error.toString());
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
