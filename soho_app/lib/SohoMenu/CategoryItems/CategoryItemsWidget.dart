import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';

import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsStateController.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsAppBar.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';

class CategoryItemsWidget extends StatefulWidget {
  final String categoryObjectString;

  const CategoryItemsWidget({
    this.categoryObjectString
  });


  @override
  State<StatefulWidget> createState() {

    return _CategoryItemsState(categoryName: this.categoryObjectString);
  }

}

class _CategoryItemsState extends State<CategoryItemsWidget> {
  CategoryItemsState categoryItemsState = locator<CategoryItemsState>();
  final String categoryName;


  _CategoryItemsState({
    @required this.categoryName
  });

  @override
  Widget build(BuildContext context) {

    var category = json.decode(categoryName);
    print("INIT with ID: ${category[CategoryObject.keyName]}");
    print("INIT with name: ${category[CategoryObject.keySquareId]}");
    print("INIT with subtitle: ${category[CategoryObject.keySubtitle]}");

    return ScopedModel<CategoryItemsState>(
      model: categoryItemsState,
      child: ScopedModelDescendant<CategoryItemsState>(builder: (builder, child, model) {
        return SafeArea(
          child: Scaffold(
            appBar: CategoryItemsAppBar(),
            body: Container(
              color: Color.fromARGB(100, 240, 236, 238),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Text("TEST"),
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
                      )
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

}