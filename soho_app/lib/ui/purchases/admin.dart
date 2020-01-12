import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:soho_app/Auth/AuthController.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderItem.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderQR.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_history.dart';

class AdminScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AdminScreenState();
  }

}

class _AdminScreenState extends State<AdminScreen> {
  final Map<int, Widget> controlWidgets = const <int, Widget>{
    0: Text('Escanear código'),
    1: Text('Ordenes pendientes'),
  };

  int selectedTab = 0;
  String barcode = "";

  @override
  void initState() {
    super.initState();
    selectedTab = 0;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: HistoryAppBar(titleText: 'APP DEL ADMINISTRADOR'),
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
                    barcode.isEmpty ? _scanButtonWidget() : _codeScannedWidget() :
                    FutureBuilder(
                      future: locator<AuthController>().getKitchenOrders(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return ListView(
                            children: _getPendingOrdersList(snapshot.data),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          );
                        } else {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 150.0),
                                Container(
                                  child: CircularProgressIndicator(),
                                ),
                                SizedBox(height: 150.0),
                              ],
                            ),
                          );
                        }
                      },
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

  Widget _scanButtonWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 32.0),
        Text(
          'Usa la cámara del dispositivo para escanear el código QR en la App del cliente.',
          style: interLightStyle(
            fSize: 14.0,
            color: Color(0xff292929),
          ),
        ),
        SizedBox(height: 44.0),
        GestureDetector(
          onTap: () {
            scan();
          },
          child: Container(
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
              color: Color(0xffF0AB31),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                'Escanear código QR',
                style: interBoldStyle(
                  fSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _codeScannedWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 32.0),
        Text(
          'Usa la cámara del dispositivo para escanear el código QR en la App del cliente.',
          style: interLightStyle(
            fSize: 14.0,
            color: Color(0xff292929),
          ),
        ),
        SizedBox(height: 44.0),
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
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: QrImage(
                data: barcode,
              ),
            ),
          ),
        ),
        SizedBox(height: 32.0),
        GestureDetector(
          onTap: () async {
            // Convert barcode to order
            var sohoOrder = SohoOrderQR.fromJson(json.decode(barcode));
            // Convert to dictionary
            var orderDict = sohoOrder.getJson();
            // Send to kitchen
            await locator<AuthController>().sendOrderToKitchen(orderDict);
          },
          child: Container(
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
              color: Color(0xffE51F4F),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                'Enviar a cocina',
                style: interBoldStyle(
                  fSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _getPendingOrdersList(List<SohoOrderQR> orders) {
    List<Widget> results = List<Widget>();
    results.add(SizedBox(height: 32.0));
    results.add(Text(
      'Revisa el listado de órdenes y cuando estén listas márcalas como completadas.',
      style: interLightStyle(
        fSize: 14.0,
        color: Color(0xff292929),
      ),
    ));
    results.add(SizedBox(height: 44.0));

    for (var order in orders) {
      var column = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 42.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Datos de la orden',
                      style: interBoldStyle(
                        fSize: 14.0,
                        color: Color(0xff5A6265),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      order.order.getCompletedDateWithTime(),
                      style: interLightStyle(
                        fSize: 14.0,
                        color: Color(0xff5A6265),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Orden para ${order.userName}",
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
            Column(
              children: _getProductsList(order.order.selectedProducts),
            ),
            SizedBox(height: 16.0),
            Divider(
              height: 1.0,
              color: Color(0xffE5E4E5),
            ),
            SizedBox(height: 24.0),
            Center(
              child: Text(
                'Total: MX\$${order.order.orderTotal + order.order.tip}0',
                style: interMediumStyle(fSize: 16.0),
              ),
            ),
            SizedBox(height: 24.0),
            GestureDetector(
              onTap: () {
                // TODO: Remove from database kitchen orders
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Color(0xffE51F4F),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                    child: Text(
                      "Orden completada",
                      style: interBoldStyle(
                        fSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 52.0),
            Image(
              image: menuDivider,
            ),
            SizedBox(height: 54.0),
          ]
      );
      results.add(column);
    }

    return results;
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  List<Widget> _getProductsList(List<SohoOrderItem> products) {
    List<Widget> list = List<Widget>();
    for (var product in products) {
      list.add(Row(
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
            product.name,
            style: interMediumStyle(fSize: 14.0),
          ),
        ],
      ));
      list.add(SizedBox(height: 5.0));

    }
    return list;
  }

}