import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/Auth/SohoUserObject.dart';
import 'package:soho_app/SohoMenu/OrderDetailState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/payments/check_method.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_methods.dart';
import 'package:soho_app/ui/widgets/layouts/spinner.dart';

class MethodsScreenState extends Model {
  bool isSelectingPayment = false;
  bool showSpinner = false;

  void updateState() {
    notifyListeners();
  }

  void updateSpinner({bool show}) {
    showSpinner = show;
    notifyListeners();
  }

}

class MethodsScreen extends StatefulWidget {
  final bool selectingPayment;

  const MethodsScreen({this.selectingPayment});

  @override
  State<StatefulWidget> createState() {
    return _MethodsScreen();
  }

}

class _MethodsScreen extends State<MethodsScreen> {
  MethodsScreenState model = locator<MethodsScreenState>();

  @override
  void initState() {
    super.initState();

    // Notify the state that we want to select a payment method
    model.isSelectingPayment = widget.selectingPayment;
  }

  @override
  Widget build(BuildContext context) {
    var hasPaymentMethods = false;
    if (Application.currentUser != null) {
      hasPaymentMethods = Application.currentUser.cardsReduced.isNotEmpty;
    }

    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: ScopedModel<MethodsScreenState>(
        model: model,
        child: ScopedModelDescendant<MethodsScreenState>(
          builder: (builder, child, model) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
              appBar: PaymentMethodsAppBar(),
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: (Platform.isAndroid)
                      ? SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.light,
                  )
                      : SystemUiOverlayStyle.light.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.dark,
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 265.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: paymentWallet,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      'MÉTODOS\nDE PAGO',
                                      style: interThinStyle(fSize: 32.0),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Laboris adipisicing magna\nconsequat excepteur\nconsectetur eu.', //TODO: Change this!
                                      style: interLightStyle(
                                        fSize: 14.0,
                                        color: Color(0xff292929),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            hasPaymentMethods ? getCardPreview() : getNoPaymentsSaved(),
                          ],
                        ),
                      ),
                      model.showSpinner ?
                      SohoSpinner() : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget getNoPaymentsSaved() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24.0),
          Text(
            'No tienes métodos de pago registrados.',
            style: interBoldStyle(fSize: 16.0),
          ),
          SizedBox(height: 32.0),
        ]
      ),
    );
  }

  List<Widget> getCardItems() {
    var result = List<Widget>();
    if (Application.currentUser != null) {
      for (var card in Application.currentUser.cardsReduced) {
        var cardDetails = Row(
          children: <Widget>[
            Image(image: card.cardType == CardType.masterCard ? masterCard : visaCard),
            SizedBox(width: 20.0),
            Text(
              '****  ****  **** ',
              style: interMediumStyle(
                fSize: 14.0,
                color: Color(0xff5A6265),
              ),
            ),
            Text(
              card.last4,
              style: interMediumStyle(
                fSize: 14.0,
                color: Color(0xff5A6265),
              ),
            ),
          ],
        );
        var cardRow = GestureDetector(
          onTap: () async {
            if (model.isSelectingPayment) {
              // Update spinner
              model.updateSpinner(show: true);
              // Save the card ID to the user and update
              Application.currentUser.selectedPaymentMethod = card.cardId;
              await locator<AppController>().updateUserInDatabase(Application.currentUser.getJson()).then((_) {
                // Notify Shopping cart screen that needs to update
                locator<OrderDetailState>().updateState();
                model.updateSpinner(show: false);
                Navigator.pop(context);

              });
            } else {
              // Set model for check card screen
              locator<CheckMethodsState>().updateValues(card.cardName, card.last4, card.expiration, card.cardType == CardType.masterCard ? 'MASTER CARD' : 'VISA', card.cardId);
              // Push view
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckMethodsScreen())
              );
            }
          },
          child: Column(
            children: <Widget>[
              SizedBox(height: 19.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  cardDetails,
                  Image(image: paymentForward),
                ],
              ),
              SizedBox(height: 19.0),
              Divider(
                height: 1.0,
                color: Color(0xffE5E4E5),
              )
            ],
          ),
        );
        result.add(cardRow);
      }
    }
    return result;
  }

  Widget getCardPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24.0),
          Text(
            'Métodos de pago registrados',
            style: interBoldStyle(fSize: 16.0),
          ),
          SizedBox(height: 32.0),
          Divider(
            height: 1.0,
            color: Color(0xffE5E4E5),
          ),
          Column(
            children: getCardItems(),
          ),
          SizedBox(height: 46.0),
        ],
      ),
    );
  }
}
