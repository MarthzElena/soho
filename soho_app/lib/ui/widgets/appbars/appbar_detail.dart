import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/CategoryItemsState.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CategoryItemsState _appBarModel = locator<CategoryItemsState>();

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
              ScopedModel<CategoryItemsState>(
                model: _appBarModel,
                child: ScopedModelDescendant<CategoryItemsState>(
                  builder: (build, child, model) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            locator<ProductItemState>().setBottomState(ProductItemState.GO_TO_CHECKOUT_TEXT);
                          },
                          child: Container(
                            width: 45.0,
                            height: preferredSize.height - 40.0,
                            alignment: Alignment.centerLeft,
                            child: Image(
                              image: detailBack,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => model.changeItemsDistribution(context),
                              child: Container(
                                width: 45.0,
                                height: 45.0,
                                alignment: Alignment.center,
                                child: Image(
                                  image: detailMosaic,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            GestureDetector(
                              onTap: null,
                              child: Container(
                                width: 45.0,
                                height: 45.0,
                                alignment: Alignment.center,
                                child: Image(
                                  image: homeSearch,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
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
