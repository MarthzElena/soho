import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Models/requests/charge_customer.dart';
import 'package:soho_app/Network/charge_customer/call.dart';
import 'package:soho_app/SohoMenu/OrderDetailState.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/auth/login.dart';
import 'package:soho_app/ui/purchases/thanks.dart';

class BottomBar extends StatefulWidget {
  final String buttonState;

  BottomBar({this.buttonState});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  ProductItemState _productItemModel = locator<ProductItemState>();

  @override
  void initState() {
    super.initState();
    _productItemModel.setBottomState(widget.buttonState);
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
              onTap: () async {
                if (_productItemModel.shouldGoToCheckout()) {
                  // Check if user is logged in
                  if (Application.currentUser != null) {
                    // Go to shopping cart
                    Navigator.pushNamed(context, Routes.orderDetail);
                  } else {
                    // Go to login
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())
                    );

                  }
                  // Set bottom to complete order
                  _productItemModel.setBottomState(ProductItemState.COMPLETE_ORDER);
                } else if (_productItemModel.shouldGoToCompleteOrder()) {
                  // Only continue if there is an ongoing order and a logged in user
                  var currentOrder = Application.currentOrder;
                  var currentUser = Application.currentUser;
                  if (currentOrder != null && currentUser != null) {
                    if (currentUser.selectedPaymentMethod.isNotEmpty) {
                      // Get all info needed for payment
                      var model = locator<OrderDetailState>();
                      var amountTotal = model.orderTotal + model.currentTip;
                      var amountInt = amountTotal.round() * 100;
                      var amount = amountInt.toString(); // Amount needs to include decimal zeros without the point
                      var currency = 'MXN';
                      var description = currentOrder.getSelectedProductDescription();
                      var source = currentUser.selectedPaymentMethod;
                      var customer = currentUser.stripeId;
                      var chargeRequest = ChargeCustomerRequest(amount: amount, currency: currency, description: description, source: source, customer: customer);
                      model.updateSpinner(show: true);
                      // TODO: UNCOMMENT THIS TO ACTIVATE PAYMENTS!!
//                      await chargeCustomerCall(request: chargeRequest).then((response) async {
                        await Application.currentUser.completeOrder(Application.currentOrder).then((codeData) {
                          model.updateSpinner(show: false);
                          // Reset current order
                          Application.currentOrder = null;
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ThanksScreen(codeData))
                          );
                        });
//                      }).catchError((error) {
//                        // TODO: Handle error with payment
//                        print("Error with chargeCustomerCall: ${error.toString()}");
//                      });

                    } else {
                      // TODO: Show error on missing payment
                      await showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text("No hay método de pago"),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    // TODO: Go to home? Show error!
                    await showDialog(
                      context: context,
                      child: SimpleDialog(
                        title: Text("No hay una órden en curso"),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
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
                  _productItemModel.setBottomState(ProductItemState.GO_TO_CHECKOUT_TEXT);
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
                        child: _productItemModel.addToCartPrice.isEmpty ?
                        Center(
                          child: Text(
                            _productItemModel.addToCartText,
                            style: interBoldStyle(fSize: 14.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ) :
                        Row(
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
    String categoryName = "";
    for (var category in Application.sohoCategories) {
      if (category.name == _productItemModel.currentProduct.category) {
        categoryId = category.squareID;
        categoryName = category.name;
        break;
      }
    }

    // Create new item for order
    SohoOrderItem newItem = SohoOrderItem(
        _productItemModel.currentProduct.name,
        _productItemModel.currentProduct.imageUrl,
        categoryId,
        categoryName,
        _productItemModel.currentProduct.squareID,
        _productItemModel.selectedItemPrice,
        _productItemModel.currentProduct.fromState,
        _productItemModel.currentProduct.locationId);
    newItem.addVariations(_productItemModel.selectedVariations);

    return newItem;
  }
}
