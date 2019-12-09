import 'package:flutter/material.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemStateController.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class ProductDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLogin;

  ProductDetailAppBar({this.isLogin = false});

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
                  Container(
                    width: isLogin? 24.0 : 10.0,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        locator<ProductItemState>().setBottomState(ProductItemState.GO_TO_CHECKOUT_TEXT);
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        image: isLogin ? menuCross : detailBack,
                      ),
                    ),
                  ),
                  Container(
                    width: 24.0,
                    child: FlatButton(
                      onPressed: null,
                      padding: EdgeInsets.all(0.0),
                      child: Image(image: productShare),
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
