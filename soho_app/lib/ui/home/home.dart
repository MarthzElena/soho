import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/widgets/appbars/appbar.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_anon.dart';
import 'package:soho_app/ui/widgets/drawer/drawer_logged.dart';
import 'package:soho_app/ui/widgets/featured/featured.dart';
import 'package:soho_app/ui/widgets/layouts/carousel_large.dart';
import 'package:soho_app/ui/widgets/layouts/carousel_small.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: HomeAppBar(),
        drawer: Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget(),
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
                  SmallCarousel(list: Application.sohoCategories),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
