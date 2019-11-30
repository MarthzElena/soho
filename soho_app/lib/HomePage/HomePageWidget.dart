import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/HomePage/HomePageAppBar.dart';
import 'package:soho_app/HomePage/HomePageMenu/LoggedInUserMenuWidget.dart';
import 'package:soho_app/HomePage/HomePageMenu/NoUserMenuWidget.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageWidget> {
  HomePageState homePageState = locator<HomePageState>();

  // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
    // TODO: Replace this with  an image from the cloud (since it will be changing)
    var backgroundImage = AssetImage('assets/home/tmp_background_home.png');
    Widget drawer = Application.currentUser == null ? NoUserMenuWidget() : LoggedInUserMenuWidget();

    return ScopedModel<HomePageState>(
      model: homePageState,
      child: ScopedModelDescendant<HomePageState>(builder: (builder, child, model) {
        // Previously load the categories
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            drawer: drawer,
            appBar: HomePageAppBar(),
            body: Container(
              child: _createCategoriesList(backgroundImage, Application.sohoCategories),
            ),
          ),
        );
      }),
    );
  }

  Widget _createCategoriesList(AssetImage backgroundImage, List<CategoryObject> list) {
    return ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 27.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Image(image: backgroundImage),
              ),
            ), // Background image
            Padding(
              padding: EdgeInsets.only(top: 49.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 22.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Disfruta una auténtica',
                        textAlign: TextAlign.start,
                        style: interBoldStyle(fSize: 17.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 21.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ceremonia',
                        textAlign: TextAlign.start,
                        style: interELStyle(
                          fSize: 27.0,
                          spacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'DE TÉ',
                        textAlign: TextAlign.start,
                        style: interThinStyle(fSize: 51.0),
                      ),
                    ),
                  )
                ],
              ),
            ) // Header text
          ],
        ), // //  Background image and text
        Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 48.0),
            child: CarouselSlider(
              viewportFraction: 0.5,
              initialPage: 1,
              height: 245.0,
              enableInfiniteScroll: false,
              items: list.map((category) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        height: 245.0,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        constraints: BoxConstraints.expand(),
                        alignment: Alignment(-1.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 190.0,
                              // decoration attribute is TEMPORAL
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 242, 242, 242),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  var categoryObject = jsonEncode(category.toJson());
                                  var route = "CategoryDetail/$categoryObject";
                                  Navigator.pushNamed(context, route);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  category.subtitle,
                                  textAlign: TextAlign.start,
                                  style: interLightStyle(fSize: 12.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                height: 19.0,
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  category.name,
                                  textAlign: TextAlign.start,
                                  style: interMediumStyle(fSize: 16.0),
                                ),
                              ),
                            )
                          ],
                        ));
                  },
                );
              }).toList(),
            )), // Categories carousel
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Pedido recientemente',
            style: interBoldStyle(fSize: 16.0),
          ),
        ) // Pedido recientemente
      ],
    );
  }
}
