import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemStateController.dart';
import 'package:soho_app/SohoMenu/ProductItems/VariationItemObject.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_product.dart';
import 'package:soho_app/ui/widgets/bottoms/bottom.dart';

class ProductDetail extends StatefulWidget {
  final ProductItemObject currentProduct;

  ProductDetail({this.currentProduct});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ProductItemState _productItemModel = locator<ProductItemState>();

  @override
  void initState() {
    super.initState();
    _productItemModel.selectedItemPrice = widget.currentProduct.price;
    _productItemModel.initAvailableVariations(widget.currentProduct.productVariations);
  }

  @override
  Widget build(BuildContext context) {
    ProductItemObject product = widget.currentProduct;

    bool isVisible = false;

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<ProductItemState>(
        model: _productItemModel,
        child: ScopedModelDescendant<ProductItemState>(
          builder: (builder, child, model) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: ProductDetailAppBar(),
              bottomNavigationBar: isVisible ? SizedBox.shrink() : BottomBar(),
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: (Platform.isAndroid)
                      ? SystemUiOverlayStyle.dark.copyWith(
                          statusBarColor: Colors.transparent,
                          statusBarBrightness: Brightness.light,
                        )
                      : SystemUiOverlayStyle.light.copyWith(
                          statusBarColor: Colors.transparent,
                          statusBarBrightness: Brightness.dark,
                        ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Container(
                                width: double.infinity,
                                height: 338.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              SizedBox(height: 24.0),
                              Text(
                                product.name,
                                style: interBoldStyle(fSize: 20.0),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                product.description,
                                style: interLightStyle(
                                  fSize: 14.0,
                                  color: Color(0xff5A6265),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "\$${product.price.toString()}",
                                style: interMediumStyle(fSize: 22.0),
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: _getOptionsList(product),
                              ),
                              SizedBox(height: 34.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _getOptionsList(ProductItemObject product) {
    List<Widget> list = List<Widget>();

    // Set variation values
    for (var variationType in _productItemModel.availableVariations.keys) {
      Widget variationName = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 23.0),
          Text(
            '― ' + variationType,
            style: interLightStyle(
              fSize: 14.0,
              color: Color(0xff789090),
            ),
          ),
          SizedBox(height: 23.0),
        ],
      );
      list.add(variationName);

      Map<VariationItemObject, bool> current = _productItemModel.availableVariations[variationType];
      for (var variationElement in current.keys) {
        var value = current[variationElement];
        // TODO: Select Radio or Checkbox depending on variation type
        Widget elementRow = getOptionalVariations(value, variationType, variationElement);
//        Widget elementRow = getRequiredVariations(variationElement, variationType);
        list.add(elementRow);
      }
    }

    // TODO: Fix this with proper button for adding to cart
    // TODO: Only enable button if required variations are selected!!
    /*Widget addToCart = FlatButton(
        onPressed: () {
          // Create a new item with specified settings
          SohoOrderItem selectedItem = _getSelectedProduct(widget.currentProduct);
          // Check if there's an ongoing order
          if (Application.currentOrder == null) {
            Application.currentOrder = SohoOrderObject();
          }
          // Save product to current order
          Application.currentOrder.selectedProducts.add(selectedItem);

          // Go back to CategoryItemsWidget
          // TODO
        },
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            color: Color(0xffE51F4F),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Agregar 1 a la orden',
                  style: interBoldStyle(fSize: 14.0, color: Colors.white),
                ),
                Text(
                  _productItemModel.selectedItemPrice.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ));
    list.add(addToCart);*/

    // Add footer
    /*Widget footer = Image(image: AssetImage('assets/category_detail/footer.png'));
    list.add(footer);*/
    return list;
  }

  Widget getOptionalVariations(
      bool value, String variationType, VariationItemObject variationElement) {
    // Update variation type in model
    _productItemModel.updateVariationType(isRequired: false);

    var widget = Row(
      children: <Widget>[
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Color(0xffE4E4E4),
          ),
          child: Checkbox(
            value: value,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onChanged: (value) {
              _productItemModel.updateCheckboxValue(variationType, variationElement, value);
            },
          ),
        ),
        SizedBox(width: 16.0),
        Text(
          variationElement.name,
          style: avenirHeavyStyle(fSize: 16.0),
        )
      ],
    );
    return widget;
  }

  Widget getRequiredVariations(VariationItemObject selectedVariation, String fromType) {
    // Update variation type in model
    _productItemModel.updateVariationType(isRequired: true);

    var widget = Row(
      children: <Widget>[
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Color(0xffE4E4E4),
          ),
          child: Radio(
              value: selectedVariation,
              groupValue: _productItemModel.getSelectedVariation(fromType),
              onChanged: (VariationItemObject selectedItem) {
                _productItemModel.addVariation(selectedVariation, fromType);
              }),
        ),
        Text(
          selectedVariation.name,
          style: avenirHeavyStyle(fSize: 16.0),
        ),
      ],
    );
    return widget;
  }

  List<Widget> _getDefaultOptions(ProductItemObject product) {
    List<Widget> list = List<Widget>();

    Widget productName = Text(
      product.name,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
    );
    list.add(productName);

    Widget productDescription = Text(
      product.description,
      style: TextStyle(color: Color.fromARGB(255, 90, 98, 101), fontSize: 14.0),
    );
    list.add(productDescription);

    Widget productPrice = Text(
      "\$${product.price.toString()}",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22.0),
    );
    list.add(productPrice);

    return list;
  }

  SohoOrderItem _getSelectedProduct(ProductItemObject fromProductItemObject) {
    // Get id for category
    String categoryId = "";
    for (var category in Application.sohoCategories) {
      if (category.name == fromProductItemObject.category) {
        categoryId = category.squareID;
        break;
      }
    }

    // Create new item for order
    SohoOrderItem newItem = SohoOrderItem(fromProductItemObject.name, categoryId,
        fromProductItemObject.squareID, fromProductItemObject.price);
    newItem.addVariations(_productItemModel.selectedVariations);

    return newItem;
  }
}
