import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_methods.dart';

class MethodsScreenState extends Model {

  void updateState() {
    notifyListeners();
  }

}

class MethodsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MethodsScreen();
  }

}

class _MethodsScreen extends State<MethodsScreen> {
  MethodsScreenState model = locator<MethodsScreenState>();

  @override
  Widget build(BuildContext context) {
    var hasPaymentMethods = false;
    if (Application.currentUser != null) {
      hasPaymentMethods = Application.currentUser.cardsReduced.isNotEmpty;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<MethodsScreenState>(
        model: model,
        child: ScopedModelDescendant(
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
                  child: SingleChildScrollView(
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
            Image(image: masterCard),
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
        var cardRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            cardDetails,
            Image(image: paymentForward),
          ],
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
          SizedBox(height: 16.0),
          Column(
            children: getCardItems(),
          ),
          SizedBox(height: 16.0),
          Divider(
            height: 1.0,
            color: Color(0xffE5E4E5),
          ),
          SizedBox(height: 46.0),
        ],
      ),
    );
  }
}
