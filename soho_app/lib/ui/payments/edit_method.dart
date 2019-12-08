import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_edit_method.dart';

class EditMethodsScreen extends StatefulWidget {
  final String nameOnCard;
  final String cardNumber;
  final String date;
  final String cvv;

  EditMethodsScreen({
    this.nameOnCard = 'Nombre',
    this.cardNumber = '1234123412341234',
    this.date = '00/00',
    this.cvv = '123',
  });

  @override
  _EditMethodsScreenState createState() => _EditMethodsScreenState();
}

class _EditMethodsScreenState extends State<EditMethodsScreen> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerCard = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerCVV = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerName.text = widget.nameOnCard;
    controllerCard.text = widget.cardNumber;
    controllerDate.text = widget.date;
    controllerCVV.text = widget.cvv;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: EditMethodAppBar(),
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            child: TextField(
                              controller: controllerName,
                              onChanged: (value) {},
                              textAlignVertical: TextAlignVertical.center,
                              style: interLightStyle(
                                fSize: 14.0,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'ej. Horacio Solis',
                                hintStyle: interLightStyle(
                                  fSize: 14.0,
                                  color: Color(0xffC4C4C4),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E4E5),
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E4E5),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E4E5),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Text(
                            'Número de tarjeta',
                            style: interStyle(fSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            child: TextField(
                              controller: controllerCard,
                              onChanged: (value) {},
                              textAlignVertical: TextAlignVertical.center,
                              style: interLightStyle(
                                fSize: 14.0,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: '****  ****  ****  ****',
                                hintStyle: interLightStyle(
                                  fSize: 14.0,
                                  color: Color(0xffC4C4C4),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E4E5),
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E4E5),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E4E5),
                                    width: 1.0,
                                  ),
                                ),
                              ),
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
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40.0,
                                      child: TextField(
                                        controller: controllerDate,
                                        onChanged: (value) {},
                                        textAlignVertical: TextAlignVertical.center,
                                        style: interLightStyle(
                                          fSize: 14.0,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          hintText: 'DD / MM',
                                          hintStyle: interLightStyle(
                                            fSize: 14.0,
                                            color: Color(0xffC4C4C4),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(3.0),
                                            borderSide: const BorderSide(
                                              color: Color(0xffE5E4E5),
                                              width: 1.0,
                                            ),
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xffE5E4E5),
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xffE5E4E5),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
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
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40.0,
                                      child: TextField(
                                        controller: controllerCVV,
                                        onChanged: (value) {},
                                        textAlignVertical: TextAlignVertical.center,
                                        style: interLightStyle(
                                          fSize: 14.0,
                                        ),
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () => cvvDialog(context),
                                            icon: Icon(Icons.info),
                                            iconSize: 20.0,
                                            color: Color(0xff5A6265),
                                          ),
                                          contentPadding: EdgeInsets.all(10.0),
                                          hintText: '***',
                                          hintStyle: interLightStyle(
                                            fSize: 14.0,
                                            color: Color(0xffC4C4C4),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(3.0),
                                            borderSide: const BorderSide(
                                              color: Color(0xffE5E4E5),
                                              width: 1.0,
                                            ),
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xffE5E4E5),
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xffE5E4E5),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
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