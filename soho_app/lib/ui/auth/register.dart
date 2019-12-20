import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/RegisterState.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class RegisterScreen extends StatefulWidget {
  final String phone;
  final String userId;

  RegisterScreen(this.phone, this.userId);

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterState _registerState = locator<RegisterState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async => false,
        child: ScopedModel<RegisterState>(
          model: _registerState,
          child: ScopedModelDescendant<RegisterState>(
              builder: (build, child, model) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  resizeToAvoidBottomPadding: true,
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
                                  image: registerImage,
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
                                      'COMPLETA',
                                      style: interThinStyle(fSize: 32.0),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'TU CUENTA',
                                      style: interThinStyle(fSize: 32.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Nombre',
                                    style: interStyle(
                                      fSize: 14.0,
                                      color: Color(0xff565758),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40.0,
                                    child: TextField(
                                      onChanged: (value) {
                                        model.nameInput = value;
                                      },
                                      textAlignVertical: TextAlignVertical.center,
                                      style: interLightStyle(
                                        fSize: 14.0,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: 'Tu nombre',
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
                                  SizedBox(height: 24.0),
                                  Text(
                                    'Apellido',
                                    style: interStyle(
                                      fSize: 14.0,
                                      color: Color(0xff565758),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40.0,
                                    child: TextField(
                                      onChanged: (value) {
                                        model.lastNameInput = value;
                                      },
                                      textAlignVertical: TextAlignVertical.center,
                                      style: interLightStyle(
                                        fSize: 14.0,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: 'Escribe aquí tu apellido',
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
                                  SizedBox(height: 24.0),
                                  Text(
                                    'Correo electrónico',
                                    style: interStyle(
                                      fSize: 14.0,
                                      color: Color(0xff565758),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40.0,
                                    child: TextField(
                                      onChanged: (value) {
                                        // TODO: Validate email
                                        model.emailInput = value;

                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: interLightStyle(
                                        fSize: 14.0,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: 'disfruta@tucafe.com',
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
                                  SizedBox(height: 47.0),
                                  GestureDetector(
                                    onTap: () async {
                                      await model.createAccount(context, widget.phone, widget.userId);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xffF0AB31),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Registrar cuenta',
                                          style: interBoldStyle(
                                            fSize: 14.0,
                                            color: Colors.white,
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
                      ),
                    ),
                  ),
                );
              }
          ),
        )
    );
  }

}