import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemStateController.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';

class BottomBar extends StatefulWidget {
  final bool isGoToCheckout;

  BottomBar({this.isGoToCheckout});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  ProductItemState _productItemModel = locator<ProductItemState>();

  @override
  void initState() {
    super.initState();
    if (widget.isGoToCheckout) {
      _productItemModel.setBottomToCheckout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              15.0, // Move to right 10  horizontally
              15.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: ScopedModel<ProductItemState>(
        model: _productItemModel,
        child: ScopedModelDescendant<ProductItemState>(
          builder: (build, child, model) {
            return GestureDetector(
              onTap: () {
                if (_productItemModel.shouldGoToCheckout()) {
                  // Check if user is logged in
                  if (Application.currentUser != null) {
                    // Go to shopping cart
                    Navigator.pushNamed(context, Routes.orderDetail);
                  } else {
                    // Go to login
                    Navigator.pushNamed(context, Routes.login);
                  }
                } else {
                  // Create a new item with specified settings
                  SohoOrderItem selectedItem = _getSelectedProduct();
                  // Check if there's an ongoing order
                  if (Application.currentOrder == null) {
                    Application.currentOrder = SohoOrderObject();
                  }
                  // Save product to current order
                  Application.currentOrder.selectedProducts.add(selectedItem);

                  // Go back to CategoryItemsWidget
                  Navigator.pop(context);
                  // Set button to checkout
                  _productItemModel.setBottomToCheckout();
                }

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 28.0),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Color(0xffE51F4F),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _productItemModel.addToCartText,
                              style: interBoldStyle(fSize: 14.0, color: Colors.white),
                            ),
                            Text(
                              _productItemModel.addToCartPrice,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SohoOrderItem _getSelectedProduct() {
    // Get id for category
    String categoryId = "";
    for (var category in Application.sohoCategories) {
      if (category.name == _productItemModel.currentProduct.category) {
        categoryId = category.squareID;
        break;
      }
    }

    // Create new item for order
    SohoOrderItem newItem = SohoOrderItem(
        _productItemModel.currentProduct.name,
        categoryId,
        _productItemModel.currentProduct.squareID,
        _productItemModel.selectedItemPrice);
    newItem.addVariations(_productItemModel.selectedVariations);

    return newItem;
  }
}
