import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 15.0,
              child: FlatButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset('assets/home/ic_menu.png')),
            ),
            Image(image: AssetImage('assets/home/menu_logo.png')),
            Container(
              width: 16.0,
              child: FlatButton(
                  onPressed: null,
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset('assets/home/menu_search.png')),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT);
}
