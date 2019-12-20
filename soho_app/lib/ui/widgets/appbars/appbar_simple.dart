import 'package:flutter/material.dart';
import 'package:soho_app/States/CategoryItemsState.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

enum SimpleAppBarType {
  ABOUT,
  ORDER
}
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SimpleAppBarType type;

  SimpleAppBar({this.type});

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
                    onTap: () {
                      switch (type) {
                        case SimpleAppBarType.ABOUT:
                          Navigator.pop(context);
                          break;
                        case SimpleAppBarType.ORDER:
                          Navigator.pop(context);
                          locator<ProductItemState>().setBottomState(ProductItemState.GO_TO_CHECKOUT_TEXT);
                          break;
                        default:
                          Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: detailBack,
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
