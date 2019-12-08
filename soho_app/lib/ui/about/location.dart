import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_product.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                            style: interThinStyle(fSize: 32.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Laboris adipisicing magna\nconsequat excepteur\nconsectetur eu.',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 24.0),
                        Text(
                          'Sucursal Libertad',
                          style: interBoldStyle(fSize: 16.0),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Image(image: locationPin),
                            SizedBox(width: 20.0),
                            Text(
                              'Av. Chapultepec 77,  Colonia Americana 44160  Guadalajara, MX',
                              style: interLightStyle(
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
                              style: interLightStyle(
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
                              'info@sohomx.com',
                              style: interLightStyle(
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
                        onTap: null,
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
                                style: interBoldStyle(
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
