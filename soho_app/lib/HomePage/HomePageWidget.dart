import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/HomePage/HomePageAppBar.dart';

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


    return ScopedModel<HomePageState>(
      model: homePageState,
      child: ScopedModelDescendant<HomePageState>(builder: (builder, child, model) {
        // Previously load the categories
        // Check for empty categories is still needed
        if (Application.sohoCategories.isNotEmpty) {
          return SafeArea(
            child: Scaffold(
              drawer: Drawer(), // TODO: Add menu!
              appBar: HomePageAppBar(),
              body: Container(
                color: Colors.white,
                child: _createCategoriesList(backgroundImage, Application.sohoCategories),
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              drawer: Drawer(), // TODO: Add menu!
              appBar: HomePageAppBar(),
              body: Container(
                color: Colors.white,
                child: new FutureBuilder(
                    future: SquareHTTPRequest.getSquareCategories(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return _createCategoriesList(backgroundImage, _getData(snapshot));
                      } else {
                        return Container(
                          // TODO: Fix this with a spinner!!
                          constraints: BoxConstraints.expand(),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'LOADING...!!',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500

                              ),
                            ),
                          ),
                        );
                      }
                    }
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  List<CategoryObject> _getData(AsyncSnapshot snapshot) {
    return List.from(snapshot.data);
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
                child: Image(
                    image: backgroundImage
                ),
              ),
            ), // Background image
            Padding(
              padding: EdgeInsets.only(top: 49.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 17.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Disfruta una auténtica',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ceremonia',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 29.0,
                            letterSpacing: 1.0
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'DE TÉ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 51.0,
                            letterSpacing: 0.0
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ) // Header text
          ],
        ), // //  Background image and text
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 48.0),
            child: CarouselSlider(
              viewportFraction: 0.5,
              height: 245.0,
              items: list.map((category) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
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
                                  color: Color.fromARGB(255, 242, 242, 242)
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.categoryDetail);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  category.subtitle,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12.0
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                category.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500

                                ),
                              ),
                            )
                          ],
                        )
                    );
                  },
                );
              }).toList(),
            )
        ), // Categories carousel
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Pedido recientemente',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
          ),
        ) // Pedido recientemente
      ],
    );
  }

}