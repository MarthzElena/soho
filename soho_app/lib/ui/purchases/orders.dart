import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/SohoMenu/OrderDetailState.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_simple.dart';
import 'package:soho_app/ui/widgets/bottoms/bottom.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class OrderElement {
  String name = "";
  String price = "";
  OrderElement({this.name = "", this.price = ""});
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderElement> orderItems = List<OrderElement>();
  OrderDetailState _model = locator<OrderDetailState>();
  double subTotal = 0.0;

  List<OrderElement> _prepareOrderElements() {
    var list = List<OrderElement>();

    if (Application.currentOrder != null) {
      for (var product in Application.currentOrder.selectedProducts) {
        var price = "\$${product.price}0";
        var productElement = OrderElement(name: product.name, price: price);
        list.add(productElement);
        // Add variations
        for (var variationType in product.productVariations) {
          for (var variation in variationType.variations) {
            var itemVariation = OrderElement(name: variation.name);
            list.add(itemVariation);
          }
        }
        // Add empty element for space between products
        list.add(OrderElement());
        // Add price to subTotal
        subTotal += product.price;
      }
    } else {
      list.add(OrderElement(name: "No olvides agregar productos a tu pedido!"));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {

    orderItems = _prepareOrderElements();

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<OrderDetailState>(
        model: _model,
        child: ScopedModelDescendant<OrderDetailState>(
          builder: (builder, child, model) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
              bottomNavigationBar: BottomBar(buttonState: ProductItemState.COMPLETE_ORDER),
              appBar: SimpleAppBar(type: SimpleAppBarType.ORDER),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 265.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: purchasesImage,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  'TU',
                                  style: interThinStyle(fSize: 32.0),
                                ),
                                Text(
                                  'ORDEN',
                                  style: interThinStyle(fSize: 32.0),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '¡Ya estamos casi listos\npara empezar a preparar\ntu comida!',
                                  style: interLightStyle(
                                    fSize: 14.0,
                                    color: Color(0xff292929),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Ordenaste',
                                    style: interLightStyle(
                                      fSize: 14.0,
                                      color: Color(0xff789090),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      locator<ProductItemState>().setBottomState(ProductItemState.GO_TO_CHECKOUT_TEXT);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Agregar algo más',
                                      style: interStyle(
                                        fSize: 14.0,
                                        color: Color(0xffE51F4F),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.0),
                              Divider(
                                height: 1.0,
                                color: Color(0xffE5E4E5),
                              ),
                              SizedBox(height: 18.0),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: orderItems.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  var element = orderItems[index];
                                  if (element.name.isEmpty) {
                                    return SizedBox(height: 10.0);
                                  } else if (element.price.isEmpty) {
                                    return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            element.name,
                                            style: interLightStyle(
                                              fSize: 14.0,
                                              color: Color(0xff789090),
                                            ),
                                          ),
                                        ]
                                    );
                                  } else {
                                    return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            element.name,
                                            style: interBoldStyle(fSize: 14.0),
                                          ),
                                          Text(
                                            element.price,
                                            style: avenirHeavyStyle(fSize: 16.0),
                                          ),
                                        ]
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 32.0),
                              Text(
                                'Agregar una nota',
                                style: interStyle(fSize: 14.0),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40.0,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: interLightStyle(
                                    fSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    hintText: '¿Alérgicos a algun ingrediente? ¿Sin cebolla?',
                                    hintStyle: interLightStyle(
                                      fSize: 14.0,
                                      color: Color(0xffC4C4C4),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E4E5),
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E4E5),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E4E5),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.0),
                              Divider(
                                height: 1.0,
                                color: Color(0xffE5E4E5),
                              ),
                              SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () => model.updateShowCode(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '¿Tienes un ',
                                      style: interStyle(fSize: 14.0),
                                    ),
                                    Text(
                                      'Código',
                                      style: interStyle(
                                        fSize: 14.0,
                                        color: Color(0xffE51F4F),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    Text(
                                      '?',
                                      style: interStyle(fSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                              model.showCode ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 24.0),
                                  Text(
                                    'Ingrese código',
                                    style: interStyle(fSize: 14.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40.0,
                                    child: TextField(
                                      onChanged: (value) {
                                        // TODO: Add change to price
                                      },
                                      textAlignVertical: TextAlignVertical.center,
                                      style: interLightStyle(
                                        fSize: 14.0,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: '--------------------',
                                        hintStyle: interLightStyle(
                                          fSize: 14.0,
                                          color: Color(0xffC4C4C4),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(3.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xffE5E4E5),
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffE5E4E5),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffE5E4E5),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                ],
                              ) : SizedBox.shrink(),
                              SizedBox(height: 16.0),
                              Divider(
                                height: 1.0,
                                color: Color(0xffE5E4E5),
                              ),
                              SizedBox(height: 24.0),
                              Text(
                                'Deja una propina',
                                style: interLightStyle(
                                  fSize: 14.0,
                                  color: Color(0xff789090),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      model.updateShowCustomTip();
                                    },
                                    child: Chip(
                                      label: Text(' Otro '),
                                      labelStyle: interMediumStyle(
                                        fSize: 14.0,
                                        color: model.isTipOther() ? Colors.white : Color(0xff789090),
                                      ),
                                      backgroundColor: model.isTipOther() ? Color(0xffF0AB31) : Colors.white,
                                      shape: StadiumBorder(
                                        side: BorderSide(
                                          color: model.isTipOther() ? Color(0xffF0AB31) : Color(0xff789090),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      model.updateTip(OrderDetailState.TIP_TEN);
                                    },
                                    child: Chip(
                                      label: Text('\$10.00'),
                                      labelStyle: interMediumStyle(
                                        fSize: 14.0,
                                        color: model.isTipTen() ? Colors.white : Color(0xff789090),
                                      ),
                                      backgroundColor: model.isTipTen() ? Color(0xffF0AB31) : Colors.white,
                                      shape: StadiumBorder(
                                        side: BorderSide(
                                          color: model.isTipTen() ? Color(0xffF0AB31) : Color(0xff789090),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      model.updateTip(OrderDetailState.TIP_FIFTEEN);
                                    },
                                    child: Chip(
                                      label: Text('\$15.00'),
                                      labelStyle: interMediumStyle(
                                        fSize: 14.0,
                                        color: model.isTipFifteen() ? Colors.white : Color(0xff789090),
                                      ),
                                      backgroundColor: model.isTipFifteen() ? Color(0xffF0AB31) : Colors.white,
                                      shape: StadiumBorder(
                                        side: BorderSide(
                                          color: model.isTipFifteen() ? Color(0xffF0AB31) : Color(0xff789090),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      model.updateTip(OrderDetailState.TIP_TWENTY);
                                    },
                                    child: Chip(
                                      label: Text('\$20.00'),
                                      labelStyle: interMediumStyle(
                                        fSize: 14.0,
                                        color: model.isTipTwenty() ? Colors.white : Color(0xff789090),
                                      ),
                                      backgroundColor: model.isTipTwenty() ? Color(0xffF0AB31) : Colors.white,
                                      shape: StadiumBorder(
                                        side: BorderSide(
                                          color: model.isTipTwenty() ? Color(0xffF0AB31) : Color(0xff789090),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              model.showCustomTip ?
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 24.0),
                                  Text(
                                    'Ingrese cantidad personalizada',
                                    style: interStyle(fSize: 14.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40.0,
                                    child: TextField(
                                      onChanged: (value) {
                                        model.updateTip(double.parse(value));
                                      },
                                      keyboardType: TextInputType.number,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: interLightStyle(
                                        fSize: 14.0,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: '\$0.00',
                                        hintStyle: interLightStyle(
                                          fSize: 14.0,
                                          color: Color(0xffC4C4C4),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(3.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xffE5E4E5),
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffE5E4E5),
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffE5E4E5),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ) : SizedBox.shrink(),
                              SizedBox(height: 24.0),
                              Divider(
                                height: 1.0,
                                color: Color(0xffE5E4E5),
                              ),
                              SizedBox(height: 24.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    'Subtotal',
                                    style: interMediumStyle(
                                      fSize: 14.0,
                                      color: Color(0xff5A6265),
                                    ),
                                  ),
                                  Text(
                                    '\$${subTotal}0',
                                    style: interMediumStyle(
                                      fSize: 14.0,
                                      color: Color(0xff5A6265),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    'Propina',
                                    style: interMediumStyle(
                                      fSize: 14.0,
                                      color: Color(0xff5A6265),
                                    ),
                                  ),
                                  Text(
                                    '\$${model.currentTip}0',
                                    style: interMediumStyle(
                                      fSize: 14.0,
                                      color: Color(0xff5A6265),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    'Total',
                                    style: interMediumStyle(),
                                  ),
                                  Text(
                                    '\$${subTotal + model.currentTip}0',
                                    style: interMediumStyle(fSize: 18.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.0),
                              Divider(
                                height: 1.0,
                                color: Color(0xffE5E4E5),
                              ),
                              SizedBox(height: 24.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image(image: purchasesVisa),
                                      SizedBox(width: 12.0),
                                      Text(
                                        '****  ****  ****',
                                        style: interMediumStyle(
                                          fSize: 14.0,
                                          color: Color(0xff5A6265),
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      Text(
                                        '8763',
                                        style: interMediumStyle(
                                          fSize: 14.0,
                                          color: Color(0xff5A6265),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Cambiar',
                                    style: interStyle(
                                      fSize: 14.0,
                                      color: Color(0xffE51F4F),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 36.0),
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
}
