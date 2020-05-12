import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/OnboardingState.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

import 'history.dart';

class OnboardingThanksScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _OnboardingThanksState();
  }

}

class _OnboardingThanksState extends State<StatefulWidget> {
  OnboardingState model = locator<OnboardingState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<OnboardingState>(
        model: model,
        child: ScopedModelDescendant<OnboardingState>(
          builder: (builder, child, model) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
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
                        SizedBox(height: 100.0),
                        Container(
                          width: double.infinity,
                          height: 265.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: purchasesBag,
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
                                  '¡BIENVENIDO\nA SOHO!',
                                  style: thinStyle(fSize: 32.0),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Escanea este código en\ntu sucursal de Soho\nfavorita. ',
                                  style: lightStyle(
                                    fSize: 14.0,
                                    color: Color(0xff292929),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        Center(
                          child: Container(
                            width: 223.0,
                            height: 223.0,
                            decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(16.0),
                              width: 191.0,
                              height: 191.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: QrImage(
                                data: "",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 67.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            "Tu pedido está listo, escanea este código en el lector de la sucursal de Soho o si aún no quieres cambiarlo, puedes guardarlo en tus pedidos para después.",
                            style: regularStyle(
                              fSize: 14.0,
                              color: Color(0xff292929),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.homePage);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Color(0xffCCC5BA),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Guardar en mis pedidos',
                                  style: boldStyle(
                                    fSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                      ]
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

}