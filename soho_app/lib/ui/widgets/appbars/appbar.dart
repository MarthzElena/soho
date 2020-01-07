import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: homeHamburger,
                      ),
                    ),
                  ),
                  Image(image: homeLogo),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.search);
                    },
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      alignment: Alignment.centerRight,
                      child: Image(
                        image: homeSearch,
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
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT + 36.0);
}
