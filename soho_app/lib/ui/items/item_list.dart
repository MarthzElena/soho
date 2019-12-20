import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/CategoryItemsState.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_detail.dart';
import 'package:soho_app/ui/widgets/bottoms/bottom.dart';
import 'package:soho_app/ui/widgets/featured/featured_detail.dart';

class ItemList extends StatefulWidget {
  final String categoryObjectString;

  ItemList({this.categoryObjectString});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  CategoryItemsState _categoryItemsState = locator<CategoryItemsState>();

  @override
  Widget build(BuildContext context) {
    CategoryObject category = CategoryObject.fromJson(
      json.decode(widget.categoryObjectString),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<CategoryItemsState>(
        model: _categoryItemsState,
        child: ScopedModelDescendant<CategoryItemsState>(
          builder: (build, child, model) {
            return Scaffold(
              backgroundColor: Color(0xffF3F1F2),
              resizeToAvoidBottomPadding: true,
              appBar: DetailAppBar(),
              bottomNavigationBar: Application.currentOrder != null ? BottomBar(buttonState: "") : SizedBox.shrink(),
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
                        SizedBox(height: 18.0),
                        FeaturedDetailWidget(
                          text1: category.name.toUpperCase(),
                          text2: category.subtitle,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: FutureBuilder(
                            future: SquareHTTPRequest.getCategoryDetail(
                              category.squareID,
                              category.name,
                            ),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                model.updateItems(model.getData(snapshot), context);

                                return Container(
                                  child: ListView(
                                    children: model.widgetsList,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                  ),
                                );
                              } else {
                                return Column(
                                  children: <Widget>[
                                    SizedBox(height: 150.0),
                                    Container(
                                      child: CircularProgressIndicator(),
                                    ),
                                    SizedBox(height: 150.0),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
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
