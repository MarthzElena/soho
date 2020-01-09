import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/SearchState.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_search.dart';
import 'package:soho_app/ui/widgets/featured/featured_detail.dart';

class SearchScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return _SearchScreenState();
  }

}

class _SearchScreenState extends State<SearchScreen> {
  SearchState _model = locator<SearchState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<SearchState>(
          model: _model,
          child: ScopedModelDescendant<SearchState>(
              builder: (builder, child, model) {
                return Scaffold(
                  backgroundColor: Color(0xffF3F1F2),
                  resizeToAvoidBottomPadding: true,
                  appBar: SearchAppBar(),
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
                            SizedBox(height: 20.0),
                            FeaturedDetailWidget(
                              text1: "COFFEE",
                              text2: "Una experiencia en tu mesa",
                              image: "assets/home/search_coffee.png",
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: _model.results.isEmpty ? 
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 150.0),
                                  Container(
                                    child: model.spinner ?
                                    CircularProgressIndicator() :
                                    Text(
                                        "Escribe el nombre de un platillo o bebida.",
                                      style: interLightStyle(
                                        fSize: 14.0,
                                        color: Color(0xff789090),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 150.0),
                                ],
                              ) :
                              ListView(
                                children: model.results,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              ),
                            )
                          ]
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