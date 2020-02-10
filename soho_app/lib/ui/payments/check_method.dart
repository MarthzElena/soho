import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_check_method.dart';
import 'package:soho_app/ui/widgets/layouts/spinner.dart';

class CheckMethodsScreen extends StatefulWidget {

  @override
  _CheckMethodsScreenState createState() => _CheckMethodsScreenState();
}

class CheckMethodsState extends Model {
  String nameOnCard = 'Nombre';
  String cardNumber = '1234';
  String cardDate = '00/00';
  String cardType = 'MASTER CARD';
  String selectedCardId = "";
  bool showSpinner = false;

  void updateSpinner({bool show}) {
    showSpinner = show;
    notifyListeners();
  }

  void updateValues(String name, String number, String date, String type, String cardId) {
    nameOnCard = name;
    cardNumber = number;
    cardDate = date;
    cardType = type;
    selectedCardId = cardId;

    notifyListeners();
  }

  void updateName(String name) {
    nameOnCard = name;
    notifyListeners();
  }

  void updateDate(String date) {
    cardDate = date;
    notifyListeners();
  }
}

class _CheckMethodsScreenState extends State<CheckMethodsScreen> {
  CheckMethodsState _model = locator<CheckMethodsState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: ScopedModel<CheckMethodsState>(
        model: _model,
        child: ScopedModelDescendant<CheckMethodsState>(
          builder: (build, child, model) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
              appBar: CheckMethodAppBar(cardType: model.cardType, name: model.nameOnCard, number: model.cardNumber, date: model.cardDate, selectedCardId: model.selectedCardId),
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
                    children: <Widget>[
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 32.0),
                                    Text(
                                      'Nombre en la tarjeta',
                                      style: interStyle(fSize: 14.0),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      model.nameOnCard,
                                      style: interLightStyle(
                                        fSize: 14.0,
                                        color: Color(0xffC4C4C4),
                                      ),
                                    ),
                                    SizedBox(height: 40.0),
                                    Text(
                                      'Número de tarjeta',
                                      style: interStyle(fSize: 14.0),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      "**** **** **** ${model.cardNumber}",
                                      style: interLightStyle(
                                        fSize: 14.0,
                                        color: Color(0xffC4C4C4),
                                      ),
                                    ),
                                    SizedBox(height: 40.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Fecha de Expiración',
                                                style: interStyle(fSize: 14.0),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                model.cardDate,
                                                style: interLightStyle(
                                                  fSize: 14.0,
                                                  color: Color(0xffC4C4C4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'CVV',
                                                style: interStyle(fSize: 14.0),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                "***",
                                                style: interLightStyle(
                                                  fSize: 14.0,
                                                  color: Color(0xffC4C4C4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      model.showSpinner ? SohoSpinner() : SizedBox.shrink(),
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
