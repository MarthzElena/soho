import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class SharingAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: productShare,
                      ),
                    ),
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
