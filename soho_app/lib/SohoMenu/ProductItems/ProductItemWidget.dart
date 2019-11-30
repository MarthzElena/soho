import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemAppBar.dart';

import 'package:soho_app/SohoMenu/ProductItems/ProductItemObject.dart';
import 'package:soho_app/SohoMenu/ProductItems/ProductItemStateController.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Locator.dart';

import 'VariationItemObject.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductItemObject currentProduct;

  ProductItemWidget({
    this.currentProduct
  });

  @override
  State<StatefulWidget> createState() {
    return _ProductItemWidgetState();
  }

}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  ProductItemState productItemModel = locator<ProductItemState>();
  final ProductItemAppBar appBar = ProductItemAppBar();

  @override
  Widget build(BuildContext context) {

    ProductItemObject product = widget.currentProduct;

    return ScopedModel<ProductItemState>(
        model: productItemModel,
        child: ScopedModelDescendant<ProductItemState>(builder: (builder, child, model) {
          return SafeArea(
              child: Scaffold(
                appBar: appBar,
                body: ListView(
                  children: _getOptionsList(product),
                ),
              )
          );
        }));
  }

  @override
  void initState(){
    super.initState();

    // Set base price
    productItemModel.selectedItemPrice = widget.currentProduct.price;
    // Init the variations
    productItemModel.initAvailableVariations(widget.currentProduct.productVariations);
  }

  List<Widget> _getOptionsList(ProductItemObject product) {
    List<Widget> list = List<Widget>();

    // Add default options
    list.addAll(_getDefaultOptions(product));

    // Set variation values
    for (var variationType in productItemModel.availableVariations.keys) {
      Widget variationName = Text(
        variationType,
        style: TextStyle(
            color: Color.fromARGB(255, 120, 144, 144),
            fontSize: 14.0
        ),
      );
      list.add(variationName);

      Map<VariationItemObject, bool> current = productItemModel.availableVariations[variationType];
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
    Widget addToCart = FlatButton(
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
          Navigator.pop(context);

        },
        child: Container(
          color: Color.fromARGB(255, 229, 31, 79),
          constraints: BoxConstraints.expand(
              height: 50.0,
              width: 343.0
          ),
          child: Text(
            productItemModel.selectedItemPrice.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        )
    );
    list.add(addToCart);

    // Add footer
    Widget footer = Image(image: AssetImage('assets/category_detail/footer.png'));
    list.add(footer);
    return list;
  }

  Widget getOptionalVariations(bool value, String variationType, VariationItemObject variationElement) {
    // Update variation type in model
    productItemModel.updateVariationType(isRequired: false);

    var widget = Row(
      children: <Widget>[
        Checkbox(
            value: value,
            onChanged: (bool value) {
              productItemModel.updateCheckboxValue(variationType, variationElement, value);
            }
        ),
        Text(
          variationElement.name,
          style: TextStyle(
              color: Color.fromARGB(255, 0, 42, 58),
              fontSize: 16.0
          ),
        )
      ],
    );
    return widget;
  }

  Widget getRequiredVariations(VariationItemObject selectedVariation, String fromType) {
    // Update variation type in model
    productItemModel.updateVariationType(isRequired: true);

    var widget = Row(
      children: <Widget>[
        Radio(
            value: selectedVariation,
            groupValue: productItemModel.getSelectedVariation(fromType),
            onChanged: (VariationItemObject selectedItem) {
              productItemModel.addVariation(selectedVariation, fromType);
            }
          ),
        Text(
          selectedVariation.name,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 42, 58),
            fontSize: 16.0
          )
        )
      ],
    );
    return widget;
  }

  List<Widget> _getDefaultOptions(ProductItemObject product) {
    List<Widget> list = List<Widget>();

    Widget productImage = Padding(
      padding: const  EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        constraints: BoxConstraints.expand(height: 338.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(const Radius.circular(8.0))
        ),
        // TODO: child: Image()
      ),
    );
    list.add(productImage);

    Widget productName = Text(
      product.name,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
    );
    list.add(productName);

    Widget productDescription = Text(
      product.description,
      style: TextStyle(
        color: Color.fromARGB(255, 90, 98, 101),
        fontSize: 14.0
      ),
    );
    list.add(productDescription);

    Widget productPrice = Text(
      "\$${product.price.toString()}",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 22.0
      ),
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
    SohoOrderItem newItem = SohoOrderItem(fromProductItemObject.name, categoryId, fromProductItemObject.squareID, fromProductItemObject.price);
    newItem.addVariations(productItemModel.selectedVariations);

    return newItem;
  }

}