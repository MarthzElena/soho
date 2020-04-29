import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/add_method.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_add_method.dart';
import 'package:soho_app/ui/widgets/layouts/spinner.dart';
import 'package:stripe_payment/stripe_payment.dart';

class AddMethodScreen extends StatefulWidget {
  @override
  _AddMethodScreenState createState() => _AddMethodScreenState();
}

class _AddMethodScreenState extends State<AddMethodScreen> {
  final AddMethodState _model = locator<AddMethodState>();

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'pk_test_DnGfNpmvTCOsPiTIzl2OULKk',
        merchantId: 'hola@marthaloera.com',
        androidPayMode: 'test',
      ),
    );
    _model.clearControllerValues();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: ScopedModel<AddMethodState>(
        model: _model,
        child: ScopedModelDescendant<AddMethodState>(
          builder: (build, child, model) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
              appBar: AddMethodAppBar(),
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                child: GestureDetector(
                  onTap: () async {
                    model.getCardInformation(context).then((error) async {
                      if (error.isNotEmpty) {
                        Fluttertoast.showToast(
                            msg: error,
                            toastLength: Toast.LENGTH_LONG,
                            timeInSecForIos: 4,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color(0x99E51F4F),
                            textColor: Colors.white
                        );
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(

                      color: Color(0xffE51F4F),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                      child: Text(
                        'Guardar',
                        style: boldStyle(
                          fSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                                      style: regularStyle(fSize: 14.0),
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40.0,
                                      child: TextField(
                                        controller: model.nameController,
                                        onChanged: (value) {},
                                        textAlignVertical: TextAlignVertical.center,
                                        style: lightStyle(
                                          fSize: 14.0,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          hintText: 'ej. Horacio Solis',
                                          hintStyle: lightStyle(
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
                                      style: regularStyle(fSize: 14.0),
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 60.0,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        maxLength: 19,
                                        controller: model.numberController,
                                        onChanged: (value) {},
                                        textAlignVertical: TextAlignVertical.center,
                                        style: lightStyle(
                                          fSize: 14.0,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          hintText: '****  ****  ****  ****',
                                          counterText: "",
                                          hintStyle: lightStyle(
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
                                                style: regularStyle(fSize: 14.0),
                                              ),
                                              SizedBox(height: 8.0),
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 60.0,
                                                child: TextField(
                                                  controller: model.expDateController,
                                                  maxLength: 5,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.all(10.0),
                                                    hintText: 'MM / AA',
                                                    counterText: "",
                                                    hintStyle: lightStyle(
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
                                                style: regularStyle(fSize: 14.0),
                                              ),
                                              SizedBox(height: 8.0),
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 60.0,
                                                child: TextField(
                                                  maxLength: 3,
                                                  keyboardType: TextInputType.number,
                                                  controller: model.cvvController,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: lightStyle(
                                                    fSize: 14.0,
                                                  ),
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      onPressed: () => model.cvvDialog(context),
                                                      icon: Icon(Icons.info),
                                                      iconSize: 20.0,
                                                      color: Color(0xff5A6265),
                                                    ),
                                                    contentPadding: EdgeInsets.all(10.0),
                                                    hintText: '***',
                                                    counterText: "",
                                                    hintStyle: lightStyle(
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
                      model.showSpinner ? SohoSpinner() : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
