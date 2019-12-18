import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/SohoMenu/OrderDetailState.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemStateController.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar.dart';
import 'package:soho_app/ui/widgets/bottoms/bottom.dart';
import 'package:soho_app/ui/widgets/featured/featured.dart';
import 'package:soho_app/ui/widgets/layouts/carousel_large.dart';
import 'package:soho_app/ui/widgets/layouts/carousel_small.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomePageState _homePageState = locator<HomePageState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<HomePageState>(
        model: _homePageState,
        child: ScopedModelDescendant<HomePageState>(
          builder: (builder, child, model) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomPadding: true,
              appBar: HomeAppBar(),
              drawer: _homePageState.drawer,
              bottomNavigationBar: Application.currentOrder != null ? BottomBar(buttonState: ProductItemState.GO_TO_CHECKOUT_TEXT) : SizedBox.shrink(),
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
                      children: <Widget>[
                        SizedBox(height: 35.0),
                        FeaturedWidget(),
                        SizedBox(height: 35.0),
                        LargeCarousel(list: Application.sohoCategories),
                        SizedBox(height: 35.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            'Pedido recientemente',
                            style: interBoldStyle(fSize: 16.0),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        model.getOrderList().isEmpty ?
                        Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          height: 90.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Color(0xffE4E4E4))
                          ),
                          child: Center(
                            child: Text(
                              'Todavía no has realizado ninguna orden.',
                              style: interLightStyle(fSize: 12.0),
                            ),
                          ),
                        ) :
                        SmallCarousel(list: model.getOrderList()),
                        SizedBox(height: 16.0),
                      ],
                    ),
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
