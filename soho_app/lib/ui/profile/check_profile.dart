import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_edit_method.dart';

class CheckProfileScreen extends StatefulWidget {
  final String name;
  final String phone;

  CheckProfileScreen({this.name = 'Nombre', this.phone = '33 1417 1084'});

  @override
  _CheckProfileScreenState createState() => _CheckProfileScreenState();
}

class _CheckProfileScreenState extends State<CheckProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: EditMethodAppBar(title: 'MI PERFIL', isPencil: true),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32.0),
                    Text(
                      'Información personal',
                      style: interBoldStyle(),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      width: 64.0,
                      height: 64.0,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            child: Container(
                              height: 64.0,
                              width: 64.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xffE6E7EB), width: 1.0),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 24.0,
                              width: 24.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Center(
                                child: Image(
                                  image: menuCamera,
                                  width: 20.0,
                                  height: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Nombre de usuario',
                      style: interStyle(
                        fSize: 14.0,
                        color: Color(0xff565758),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.name,
                      style: interLightStyle(
                        fSize: 14.0,
                        color: Color(0xffC4C4C4),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      'Número de celular',
                      style: interStyle(
                        fSize: 14.0,
                        color: Color(0xff565758),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.phone,
                      style: interLightStyle(
                        fSize: 14.0,
                        color: Color(0xffC4C4C4),
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
}