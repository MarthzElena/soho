import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';

class ProductItemAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  State<StatefulWidget> createState() {
    
    return _ProductItemAppBarState(height: preferredSize.height);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT);

}

class _ProductItemAppBarState extends State<ProductItemAppBar> {
  final double height;
  
  _ProductItemAppBarState({
    @required this.height
});
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
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
              child: Container(
                constraints: BoxConstraints.expand(),
              ),
            ),
            FlatButton(
                onPressed: () {
                  // TODO: Share!
                },
                padding: EdgeInsets.all(0.0),
                child: Image.asset('assets/category_detail/share.png')
            )
          ],
        ),
      ),
    );
  }

}