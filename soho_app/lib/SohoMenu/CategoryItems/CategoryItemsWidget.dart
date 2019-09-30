import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';

import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsStateController.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsAppBar.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';

import 'CategoryItemObject.dart';

class CategoryItemsWidget extends StatefulWidget {
  final String categoryObjectString;

  const CategoryItemsWidget({
    this.categoryObjectString
  });


  @override
  State<StatefulWidget> createState() {

    return _CategoryItemsState(categoryObject: this.categoryObjectString);
  }

}

class _CategoryItemsState extends State<CategoryItemsWidget> {
  CategoryItemsState categoryItemsState = locator<CategoryItemsState>();
  final String categoryObject;


  _CategoryItemsState({
    @required this.categoryObject
  });

  @override
  Widget build(BuildContext context) {

    CategoryObject category = CategoryObject.fromJson(json.decode(categoryObject));

    return ScopedModel<CategoryItemsState>(
      model: categoryItemsState,
      child: ScopedModelDescendant<CategoryItemsState>(builder: (builder, child, model) {
        return SafeArea(
          child: Scaffold(
            appBar: CategoryItemsAppBar(),
            body: Container(
              color: Color.fromARGB(100, 243, 241, 242),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0, top: 12.0),
                          child: Column(
                            children: [
                              Container(
                                width: 220,
                                child: Text(
                                  category.name.toUpperCase(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 32
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Text(
                                  category.subtitle,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 41, 41, 41)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ), // Top section
                  Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(8.0),
                          topRight: const Radius.circular(8.0)
                        ),
                      ),
                      child: new FutureBuilder(
                          future: SquareHTTPRequest.getCategoryDetail(category.squareID),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Container(
                                height: 450,
                                child: ListView(
                                  children: _getData(snapshot).map((subCategoryItem) {
                                    return  Builder(
                                      builder: (BuildContext context) {
                                        return Row(
                                          children: <Widget>[
                                            Text(subCategoryItem.subcategoryName),
                                            Text("Element count ${subCategoryItem.items.length}")
                                          ],
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            } else {
                              return Container(
                                // TODO: Fix this with a spinner!!
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
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  List<SubcategoryItems> _getData(AsyncSnapshot snapshot) {
    CategoryItemObject categoryItem = snapshot.data;
    if (categoryItem != null) {
      return categoryItem.allItems;
    }
    return List<SubcategoryItems>();
  }

}