import 'dart:io';

import 'package:flutter/cupertino.dart';
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
                          height: 40.0,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            style: interLightStyle(
                              fSize: 14.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '¿Alérgicos a algun ingrediente? ¿Sin cebolla?',
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
                        Divider(
                          height: 1.0,
                          color: Color(0xffE5E4E5),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '¿Tienes un ',
                              style: interStyle(fSize: 14.0),
                            ),
                            Text(
                              'Código',
                              style: interStyle(
                                fSize: 14.0,
                                color: Color(0xffE51F4F),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Divider(
                          height: 1.0,
                          color: Color(0xffE5E4E5),
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          'Deja una propina',
                          style: interLightStyle(
                            fSize: 14.0,
                            color: Color(0xff789090),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Chip(
                              label: Text(' Otro '),
                              labelStyle: interMediumStyle(
                                fSize: 14.0,
                                color: Color(0xff789090),
                              ),
                              backgroundColor: Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Color(0xff789090),
                                ),
                              ),
                            ),
                            Chip(
                              label: Text('\$10.00'),
                              labelStyle: interMediumStyle(
                                fSize: 14.0,
                                color: Color(0xff789090),
                              ),
                              backgroundColor: Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Color(0xff789090),
                                ),
                              ),
                            ),
                            Chip(
                              label: Text('\$15.00'),
                              labelStyle: interMediumStyle(
                                fSize: 14.0,
                                color: Color(0xff789090),
                              ),
                              backgroundColor: Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Color(0xff789090),
                                ),
                              ),
                            ),
                            Chip(
                              label: Text('\$20.00'),
                              labelStyle: interMediumStyle(
                                fSize: 14.0,
                                color: Color(0xff789090),
                              ),
                              backgroundColor: Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Color(0xff789090),
                                ),
                              ),
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
                              'Subtotal',
                              style: interMediumStyle(
                                fSize: 14.0,
                                color: Color(0xff5A6265),
                              ),
                            ),
                            Text(
                              '\$200.00',
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
                              '\$10.00',
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
                              '\$210.00',
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
                            Row(
                              children: <Widget>[
                                Image(image: purchasesVisa),
                                SizedBox(width: 12.0),
                                Text(
                                  '****  ****  ****',
                                  style: interMediumStyle(
                                    fSize: 14.0,
                                    color: Color(0xff5A6265),
                                  ),
                                ),
                                SizedBox(width: 12.0),
                                Text(
                                  '8763',
                                  style: interMediumStyle(
                                    fSize: 14.0,
                                    color: Color(0xff5A6265),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Cambiar',
                              style: interStyle(
                                fSize: 14.0,
                                color: Color(0xffE51F4F),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 36.0),
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
