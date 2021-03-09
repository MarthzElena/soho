import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/OnboardingState.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_logo_only.dart';
import 'package:soho_app/ui/widgets/bottoms/onboarding_bottom.dart';

class OnboardingScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _OnboardingScreen();
  }

}

class _OnboardingScreen extends State<OnboardingScreen> {
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
              backgroundColor: Colors.white,
              appBar: LogoAppBar(),
              bottomNavigationBar: model.showBottom ?
              OnboardingBottom(
                  instruction: "Perfecto, todo listo. Ahora haz tap en este botón y vamos a confirmar tu orden.",
                  buttonText1: "Agregar 1 a la orden",
                  buttonText2: "GRATIS") : SizedBox.shrink(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Container(
                                  width: double.infinity,
                                  height: 338.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  // TODO: Add child with image
                                ),
                                SizedBox(height: 24.0),
                                Text(
                                  "¡Recibe un café GRATIS!",
                                  style: boldStyle(fSize: 20.0),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "Personaliza tu café y estaremos listos para agregarlo al carrito.",
                                  style: lightStyle(
                                    fSize: 14.0,
                                    color: Color(0xff5A6265),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  "GRATIS",
                                  style: regularStyle(fSize: 22.0),
                                ),
                                SizedBox(height: 36.0),
                                Text(
                                  '― Leche',
                                  style: lightStyle(
                                    fSize: 14.0,
                                    color: Color(0xff789090),
                                  ),
                                ),
                                SizedBox(height: 23.0),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Leche entera",
                                          groupValue: model.selectedMilk,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedMilk(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Leche entera",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Leche deslactosada",
                                          groupValue: model.selectedMilk,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedMilk(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Leche deslactosada",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Leche de almendras",
                                          groupValue: model.selectedMilk,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedMilk(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Leche de almendras",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Leche de nueces",
                                          groupValue: model.selectedMilk,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedMilk(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Leche de nueces",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Leche de coco",
                                          groupValue: model.selectedMilk,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedMilk(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Leche de coco",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Sin leche",
                                          groupValue: model.selectedMilk,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedMilk(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Sin leche",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 36.0),
                                Text(
                                  '― Endulzante',
                                  style: lightStyle(
                                    fSize: 14.0,
                                    color: Color(0xff789090),
                                  ),
                                ),
                                SizedBox(height: 36.0),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Miel en polvo",
                                          groupValue: model.selectedSugar,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedSugar(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Miel en polvo",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Stevia",
                                          groupValue: model.selectedSugar,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedSugar(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Stevia",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Azúcar",
                                          groupValue: model.selectedSugar,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedSugar(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Azúcar",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Azúcar mascabado",
                                          groupValue: model.selectedSugar,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedSugar(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Azúcar mascabado",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Splenda",
                                          groupValue: model.selectedSugar,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedSugar(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Splenda",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Color(0xffE4E4E4),
                                      ),
                                      child: Radio(
                                          value: "Sin endulzante",
                                          groupValue: model.selectedSugar,
                                          onChanged: (String selectedItem) {
                                            model.updateSelectedSugar(selectedItem);
                                          }),
                                    ),
                                    Text(
                                      "Sin endulzante",
                                      style: regularStyle(fSize: 16.0, fWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 33.0)
                              ],
                            ),
                          ),
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