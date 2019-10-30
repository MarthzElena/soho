import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/SohoMenu/CategoryItems/CategoryItemsStateController.dart';

class CategoryItemsAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  State<StatefulWidget> createState() {
    return  _CategoryItemsAppBarState(height: preferredSize.height);
  }


  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT);
  
}

class _CategoryItemsAppBarState extends State<CategoryItemsAppBar> {
  final double height;
  CategoryItemsState appBarModel = locator<CategoryItemsState>();

  _CategoryItemsAppBarState({
    @required this.height
  });

  @override
  Widget build(BuildContext context) {

    return ScopedModel<CategoryItemsState>(
        model: appBarModel,
        child: ScopedModelDescendant<CategoryItemsState>(builder: (builder, child, model) {
          return Scaffold(
            body: Container(
              constraints: BoxConstraints.expand(),
              color: Color.fromARGB(100, 243, 241, 242),
              width: MediaQuery.of(context).size.width,
              height: height,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Image.asset('assets/category_detail/back.png')
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () => model.changeItemsDistribution(),
                          padding: EdgeInsets.all(0.0),
                          child: model.listDistribution
                      ),
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        // TODO: Search!
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Image.asset('assets/home/menu_search.png')
                  )
                ],
              ),
            ),
          );
        })
    );
  }

}