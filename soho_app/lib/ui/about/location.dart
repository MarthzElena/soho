import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_product.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: ProductDetailAppBar(),
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
                        image: locationImage,
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
                            'UBICACIÓN',
                            style: thinStyle(fSize: 32.0),
                          ),
                          SizedBox(height: 4.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              '¡Ven! Te estamos esperando para ofrecerte una experiencia única.',
                              style: lightStyle(
                                fSize: 14.0,
                                color: Color(0xff292929),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 24.0),
                        Text(
                          'Sucursal Libertad',
                          style: boldStyle(fSize: 16.0),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Image(image: locationPin),
                            SizedBox(width: 20.0),
                            Text(
                              'Av. Chapultepec 77,  Colonia Americana 44160  Guadalajara, MX',
                              style: lightStyle(
                                fSize: 14.0,
                                color: Color(0xff5A6265),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Image(image: locationPhone),
                            SizedBox(width: 20.0),
                            Text(
                              '+52 1 (33) 1417 1084',
                              style: lightStyle(
                                fSize: 14.0,
                                color: Color(0xffE51F4F),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Image(image: locationMail),
                            SizedBox(width: 20.0),
                            Text(
                              Constants.SOHO_SUPPORT_EMAIL,
                              style: lightStyle(
                                fSize: 14.0,
                                color: Color(0xffE51F4F),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 46.0),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 292.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: locationMap,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () async {
                          final sohoLocation = "https://goo.gl/maps/9TezLUL4XyVFsv3w9";
                          if (await canLaunch(sohoLocation)) {
                            await launch(sohoLocation);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Busca SOHO en tu aplicación de mapas favorita.",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIos: 4,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Color(0x99E51F4F),
                                textColor: Colors.white
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 40.0),
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Color(0xffE51F4F),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Center(
                              child: Text(
                                'Obtener Indicaciones',
                                style: boldStyle(
                                  fSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
