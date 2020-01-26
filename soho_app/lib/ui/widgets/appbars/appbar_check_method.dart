import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/payments/add_method.dart';
import 'package:soho_app/ui/payments/edit_method.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class CheckMethodAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String cardType;
  final String name;
  final String number;
  final String date;
  final String selectedCardId;

  CheckMethodAppBar({this.cardType, this.name, this.number, this.date, this.selectedCardId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 22.0,
                        child: FlatButton(
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.all(0.0),
                          child: Image(
                            image: detailBack,
                            width: 22.0,
                            height: 22.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      AutoSizeText(
                        cardType,
                        style: interLightStyle(fSize: 18.0),
                        maxLines: 1,
                        maxFontSize: 18.0,
                      ),
                    ],
                  ),
                  Container(
                    width: 22.0,
                    child: FlatButton(
                      onPressed: () {
                        if (Platform.isIOS) {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext ctxt) {
                              return CupertinoActionSheet(
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      goToEditCard(context);
                                    },
                                    child: Text(
                                      'Editar método de pago',
                                      textAlign: TextAlign.center,
                                      style: interStyle(
                                        fSize: 16.0, color: Color(0xff5A6265)),
                                    )
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      // TODO: Add delete card
                                    },
                                    child: Text(
                                      'Borrar método de pago',
                                      textAlign: TextAlign.center,
                                      style: interStyle(
                                        fSize: 16.0, color: Color(0xff5A6265)),
                                    )
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(ctxt),
                                  child: Text('Cancel')
                                ),
                              );
                            }
                          );
                        } else {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext ctxt) {
                              return Container(
                                child: Wrap(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        goToEditCard(context);
                                      },
                                      child: Container(
                                        height: 56,
                                        child: Center(
                                          child: Text(
                                          'Editar método de pago',
                                          textAlign: TextAlign.center,
                                          style: interStyle(
                                            fSize: 16.0, color: Color(0xff5A6265)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Add delete card
                                      },
                                      child: Container(
                                        height: 56,
                                        child: Center(
                                          child: Text(
                                          'Borrar método de pago',
                                          textAlign: TextAlign.center,
                                          style: interStyle(
                                            fSize: 16.0, color: Color(0xff5A6265)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          );
                        }
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        image: menuMore,
                        width: 22.0,
                        height: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToEditCard(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditMethodsScreen(nameOnCard: name, cardNumber: number, date: date, cardStripeId: selectedCardId))
    );
  }

  Future<void> deleteCreditCard() async {

  }

  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT + 36.0);
}
