import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_simple.dart';
import 'package:soho_app/ui/widgets/textfields/textfield.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: SimpleAppBar(),
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
                        image: purchasesImage,
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
                            'TU',
                            style: interThinStyle(fSize: 32.0),
                          ),
                          Text(
                            'ORDEN',
                            style: interThinStyle(fSize: 32.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            '¡Ya estamos casi listos\npara empezar a preparar\ntu comida!',
                            style: interLightStyle(
                              fSize: 14.0,
                              color: Color(0xff292929),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Ordenaste',
                              style: interLightStyle(
                                fSize: 14.0,
                                color: Color(0xff789090),
                              ),
                            ),
                            Text(
                              'Agregar algo más',
                              style: interStyle(
                                fSize: 14.0,
                                color: Color(0xffE51F4F),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.0),
                        Divider(
                          height: 1.0,
                          color: Color(0xffE5E4E5),
                        ),
                        SizedBox(height: 18.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Té Negro Assam Hunwal',
                              style: interBoldStyle(fSize: 14.0),
                            ),
                            Text(
                              '\$200.00',
                              style: avenirHeavyStyle(fSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.0),
                        Text(
                          'Agregar una nota',
                          style: interStyle(fSize: 14.0),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60.0,
                          child: TextFieldSoho(
                            controller: null,
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
      ),
    );
  }
}
