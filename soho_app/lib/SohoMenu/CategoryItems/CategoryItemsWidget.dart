import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsStateController.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsAppBar.dart';
import 'package:soho_app/Utils/Locator.dart';

class CategoryItemsWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return _CategoryItemsState();
  }

}

class _CategoryItemsState extends State<CategoryItemsWidget> {
  CategoryItemsState categoryItemsState = locator<CategoryItemsState>();
  
  @override
  Widget build(BuildContext context) {
    
    return ScopedModel<CategoryItemsState>(
      model: categoryItemsState,
      child: ScopedModelDescendant<CategoryItemsState>(builder: (builder, child, model) {
        return SafeArea(
          child: Scaffold(
            appBar: CategoryItemsAppBar(),
            body: Container(
              color: Color.fromARGB(100, 240, 236, 238),
            ),
          ),
        );
      }),
    );
  }

}