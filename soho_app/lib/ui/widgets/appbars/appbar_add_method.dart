import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/payments/add_method.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class AddMethodAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 22.0,
                    child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        image: menuCross,
                        width: 22.0,
                        height: 22.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  AutoSizeText(
                    'INFORMACIÓN DE LA TARJETA',
                    style: lightStyle(fSize: 18.0),
                    maxLines: 1,
                    maxFontSize: 18.0,
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
