import 'package:flutter/material.dart';
import 'package:soho_app/States/CategoryItemsState.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 50.0,
                      height: preferredSize.height - 40.0,
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: detailBack,
                      ),
                    ),
                  ),
                  Text(
                    'MIS ÓRDENES',
                    style: interLightStyle(fSize: 18.0),
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
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT + 36);
}
