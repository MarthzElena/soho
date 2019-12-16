import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_history.dart';

class HistoryScreen extends StatefulWidget {
  final bool isOngoingOrder;

  HistoryScreen({this.isOngoingOrder});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class OrderListElement {
  String price = "";
  String date = "";
  String codeData = "";
  List<OrderItem> items;
  OrderListElement(this.price, this.date, this.codeData, this.items);
}

class OrderItem {
  String name;
  OrderItem({this.name});
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Map<int, Widget> controlWidgets = const <int, Widget>{
    0: Text('Ordenes anteriores'),
    1: Text('Ordenes pendientes'),
  };

  int selectedTab = 0;
  List<OrderListElement> orderItems = List<OrderListElement>();

  List<OrderListElement> _prepareOrderElements() {
    var list = List<OrderListElement>();
    if (Application.currentUser != null) {
      var orders = selectedTab == 0 ? Application.currentUser.pastOrders : Application.currentUser.ongoingOrders;
      if (orders != null) {
        for (var order in orders) {
          var price = 0.0;
          var itemsList = List<OrderItem>();
          for (var product in order.selectedProducts) {
            price += product.price;
            var orderItem = OrderItem(name: product.name);
            itemsList.add(orderItem);
          }
          var listElement = OrderListElement("\$${price}0", order.getCompletedDateWithTime(), order.qrCodeData, itemsList);
          list.add(listElement);
        }
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    selectedTab = widget.isOngoingOrder ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {

    orderItems = _prepareOrderElements();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: HistoryAppBar(),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32.0),
                    Container(
                      height: 42.0,
                      width: MediaQuery.of(context).size.width,
                      child: MaterialSegmentedControl(
                        horizontalPadding: EdgeInsets.all(0),
                        borderColor: Color(0xffF0AB31),
                        unselectedColor: Colors.white,
                        selectedColor: Color(0xffF0AB31),
                        children: controlWidgets,
                        onSegmentChosen: (int value) {
                          setState(() {
                            selectedTab = value;
                          });
                        },
                        selectionIndex: selectedTab,
                      ),
                    ),
                    selectedTab == 0 ?
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderItems.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          var orderListElement = orderItems[index];
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 42.0),
                                    Image(
                                      image: menuCheck,
                                      color: Color(0xff11E359),
                                    ),
                                    SizedBox(width: 16.0),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Orden completa',
                                          style: interBoldStyle(
                                            fSize: 14.0,
                                            color: Color(0xff5A6265),
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          orderListElement.date,
                                          style: interLightStyle(
                                            fSize: 14.0,
                                            color: Color(0xff5A6265),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Divider(
                                  height: 1.0,
                                  color: Color(0xffE5E4E5),
                                ),
                                SizedBox(height: 16.0),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: orderListElement.items.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    var orderItem = orderListElement.items[index];
                                    return Row(
                                      children: <Widget>[
                                        Container(
                                          width: 24,
                                          height: 24.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xffE5E4E5),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '1',
                                              style: interMediumStyle(fSize: 14.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16.0),
                                        Text(
                                          orderItem.name,
                                          style: interMediumStyle(fSize: 14.0),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                                SizedBox(height: 16.0),
                                Divider(
                                  height: 1.0,
                                  color: Color(0xffE5E4E5),
                                ),
                                SizedBox(height: 24.0),
                                Center(
                                  child: Text(
                                    'Total: MX\$${orderListElement.price}0',
                                    style: interMediumStyle(fSize: 16.0),
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          // TODO: Generate order with data
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width / 2.5,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xffE51F4F),
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Ordenar de nuevo',
                                              style: interBoldStyle(
                                                fSize: 14.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: null,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width / 2.5,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xffF0AB31),
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '¿Necesitas ayuda?',
                                              style: interBoldStyle(
                                                fSize: 14.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 52.0),
                                Image(
                                  image: menuDivider,
                                ),
                              ]
                          );
                        }
                    ) :
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderItems.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        var element = orderItems[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 42.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Image(image: menuQR),
                                SizedBox(width: 16.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Código QR listo',
                                      style: interBoldStyle(
                                        fSize: 14.0,
                                        color: Color(0xff5A6265),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      element.date,
                                      style: interLightStyle(
                                        fSize: 14.0,
                                        color: Color(0xff5A6265),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Divider(
                              height: 1.0,
                              color: Color(0xffE5E4E5),
                            ),
                            SizedBox(height: 16.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: element.items.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                              var orderItem = element.items[index];
                              return Row(
                                children: <Widget>[
                                  Container(
                                    width: 24,
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                      color: Color(0xffE5E4E5),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                      '1',
                                      style: interMediumStyle(fSize: 14.0),
                                      ),
                                    ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Text(
                                      orderItem.name,
                                      style: interMediumStyle(fSize: 14.0),
                                    ),
                                  ],
                                );
                              }
                            ),
                            SizedBox(height: 16.0),
                            Divider(
                              height: 1.0,
                              color: Color(0xffE5E4E5),
                            ),
                            SizedBox(height: 24.0),
                            Center(
                              child: Text(
                                'Total: MX\$${element.price}0',
                                style: interMediumStyle(fSize: 16.0),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Hide qr code
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xffE51F4F),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Ocultar código',
                                          style: interBoldStyle(
                                            fSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: null,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xffF0AB31),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '¿Necesitas ayuda?',
                                          style: interBoldStyle(
                                            fSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 42.0),
                            Center(
                              child: Container(
                                width: 223.0,
                                height: 223.0,
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  width: 191.0,
                                  height: 191.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: QrImage(
                                    data: element.codeData,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 52.0),
                            Image(
                              image: menuDivider,
                            ),
                          ]
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
