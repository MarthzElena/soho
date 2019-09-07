import 'package:flutter/material.dart';

import 'package:soho_app/Utils/Constants.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: preferredSize.height,
        child: Row(
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                padding: EdgeInsets.all(0.0),
                child: Image.asset('assets/home/ic_menu.png')
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Image(
                    image: AssetImage('assets/home/menu_logo.png')
                ),
              ),
            ),
            FlatButton(
              onPressed: null,
              padding: EdgeInsets.all(0.0),
              child: Image.asset('assets/home/menu_search.png')
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT);
}