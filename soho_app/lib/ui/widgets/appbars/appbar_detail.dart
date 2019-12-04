import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF3F1F2),
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 10.0,
                    child: FlatButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.all(0.0),
                        child: Image(image: detailBack)),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 16.0,
                        child: FlatButton(
                          onPressed: null,
                          padding: EdgeInsets.all(0.0),
                          child: Image(image: detailMosaic),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Container(
                        width: 16.0,
                        child: FlatButton(
                          onPressed: null,
                          padding: EdgeInsets.all(0.0),
                          child: Image(image: homeSearch),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT + 36.0);
}