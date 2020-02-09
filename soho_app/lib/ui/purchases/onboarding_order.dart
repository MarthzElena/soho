import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/OnboardingState.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_simple.dart';
import 'package:soho_app/ui/widgets/bottoms/onboarding_bottom.dart';

class OnboardingOrderScreen extends StatefulWidget {
  final List<String> details;

  OnboardingOrderScreen({this.details});


  @override
  State<StatefulWidget> createState() {
    return _OnboardingOrderScreen();
  }

}

class _OnboardingOrderScreen extends State<OnboardingOrderScreen> {
  OnboardingState model = locator<OnboardingState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          if (Platform.isAndroid) {
            locator<ProductItemState>().setBottomState(ProductItemState.GO_TO_CHECKOUT_TEXT);
          }
          return Platform.isAndroid;
        },
        child: ScopedModel<OnboardingState>(
          model: model,
          child: ScopedModelDescendant<OnboardingState>(
            builder: (builder, child, model) {
              return Scaffold(
                resizeToAvoidBottomPadding: true,
                backgroundColor: Colors.white,
                bottomNavigationBar: OnboardingBottom(
                  instruction: "Este es el resumen de tu compra. Si necesitas hacer algún cambio usa el botón de regresar.",
                  buttonText1: "Realizar pedido ahora",
                ),
                appBar: SimpleAppBar(type: SimpleAppBarType.ORDER),
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
                                Text(
                                  'Ordenaste',
                                  style: interLightStyle(
                                    fSize: 14.0,
                                    color: Color(0xff789090),
                                  ),
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
                                      "Café de bienvenida",
                                      style: interBoldStyle(fSize: 14.0),
                                    ),
                                    Text(
                                      "GRATIS",
                                      style: avenirHeavyStyle(fSize: 16.0),
                                    ),
                                  ]
                                ),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        model.selectedMilk,
                                        style: interLightStyle(
                                          fSize: 14.0,
                                          color: Color(0xff789090),
                                        ),
                                      ),
                                    ]
                                ),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        model.selectedSugar,
                                        style: interLightStyle(
                                          fSize: 14.0,
                                          color: Color(0xff789090),
                                        ),
                                      ),
                                    ]
                                ),
                                SizedBox(height: 19.0),
                                Divider(
                                  height: 1.0,
                                  color: Color(0xffE5E4E5),
                                ),
                                SizedBox(height: 27.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      'Subtotal',
                                      style: interMediumStyle(
                                        fSize: 14.0,
                                        color: Color(0xff5A6265),
                                      ),
                                    ),
                                    Text(
                                      '\$0.00',
                                      style: interMediumStyle(
                                        fSize: 14.0,
                                        color: Color(0xff5A6265),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      'Propina',
                                      style: interMediumStyle(
                                        fSize: 14.0,
                                        color: Color(0xff5A6265),
                                      ),
                                    ),
                                    Text(
                                        '\$0.00',
                                      style: interMediumStyle(
                                        fSize: 14.0,
                                        color: Color(0xff5A6265),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      'Total',
                                      style: interMediumStyle(),
                                    ),
                                    Text(
                                      '\$0.00',
                                      style: interMediumStyle(fSize: 18.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.0),
                                Divider(
                                  height: 1.0,
                                  color: Color(0xffE5E4E5),
                                ),
                                SizedBox(height: 24.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      'No tienes métodos de pago',
                                      style: interStyle(
                                        fSize: 14.0,
                                        color: Color(0xff5A6265),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Go to add payment method & Update UI
                                      },
                                      child: Text(
                                        'Agregar',
                                        style: interStyle(
                                          fSize: 14.0,
                                          color: Color(0xffE51F4F),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 40.0),
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
        ),
    );
  }

}