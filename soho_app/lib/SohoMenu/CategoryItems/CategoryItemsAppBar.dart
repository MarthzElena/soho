import 'package:flutter/material.dart';

import 'package:soho_app/Utils/Constants.dart';

class CategoryItemsAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  State<StatefulWidget> createState() {
    return  _CategoryItemsAppBarState(height: preferredSize.height);
  }


  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT);
  
}

class _CategoryItemsAppBarState extends State<CategoryItemsAppBar> {
  Image listDistribution = Image.asset('assets/category_detail/grid_view.png');
  final double height;

  _CategoryItemsAppBarState({
    @required this.height
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color.fromARGB(100, 240, 236, 238),
        width: MediaQuery.of(context).size.width,
        height: height,
        child: Row(
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
                    onPressed: () {
                      _swapListDistribution();
                    },
                    padding: EdgeInsets.all(0.0),
                    child: listDistribution
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
  }

  void _swapListDistribution() {
    print(listDistribution.image.toString());
  }
}