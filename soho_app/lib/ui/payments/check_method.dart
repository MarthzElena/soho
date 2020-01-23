import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_check_method.dart';

class CheckMethodsScreen extends StatefulWidget {
  final String nameOnCard;
  final String cardNumber;
  final String date;

  CheckMethodsScreen({
    this.nameOnCard = 'Nombre',
    this.cardNumber = '1234',
    this.date = '00/00',
  });

  @override
  _CheckMethodsScreenState createState() => _CheckMethodsScreenState();
}

class _CheckMethodsScreenState extends State<CheckMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: CheckMethodAppBar(cardType: 'MASTER CARD'),
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
                            widget.nameOnCard,
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
                            "**** **** **** ${widget.cardNumber}",
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
                                      widget.date,
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
          ),
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
