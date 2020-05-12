import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/smtp_server.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/items/item_detail.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_history.dart';
import 'package:soho_app/ui/widgets/layouts/spinner.dart';
import 'package:mailer/mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryScreen extends StatefulWidget {
  final bool isOngoingOrder;

  HistoryScreen({this.isOngoingOrder});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class OrderListElement {
  String price = "";
  String date = "";
  String validDays = "0";
  String codeData = "";
  List<OrderSelectedProduct> items;
  SohoOrderObject originalOrder;
  OrderListElement(this.price, this.date, this.codeData, this.items, this.originalOrder, this.validDays);
}

class OrderSelectedProduct {
  String name = "";
  String squareProductId = "";
  String squareCategoryId = "";
  String categoryName = "";
  OrderSelectedProduct(this.name, this.squareProductId, this.squareCategoryId, this.categoryName);
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Map<int, Widget> controlWidgets = const <int, Widget>{
    0: Text('Ordenes anteriores'),
    1: Text('Ordenes pendientes'),
  };

  int selectedTab = 0;
  List<OrderListElement> orderItems = List<OrderListElement>();

  bool showCode = true;
  bool showSpinner = false;
  String emailBody = "";

  void updateSpinner({bool show}) {
    setState(() {
      showSpinner = show;
    });
  }

  List<OrderListElement> _prepareOrderElements() {
    var list = List<OrderListElement>();
    if (Application.currentUser != null) {
      var orders = selectedTab == 0 ? Application.currentUser.pastOrders : Application.currentUser.ongoingOrders;
      if (orders != null) {
        for (var order in orders.reversed) {
          var itemsList = List<OrderSelectedProduct>();
          for (var product in order.selectedProducts) {
            var orderItem = OrderSelectedProduct(product.name, product.productID, product.categoryID, product.categoryName);
            itemsList.add(orderItem);
          }
          var daysDifference = DateTime.now().difference(order.completionDate).inDays;
          var daysLeft = 7 - daysDifference;
          var daysLeftString = daysLeft <= 0 ? "0" : daysLeft.toString();
          var listElement = OrderListElement("\$${order.orderTotal}0", order.getCompletedDateWithTime(), order.qrCodeData, itemsList, order, daysLeftString);
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
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: HistoryAppBar(titleText: 'MIS ÓRDENES'),
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
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Application.currentUser != null ?
                  FutureBuilder(
                      future: locator<AppController>().getUser(forId: Application.currentUser.userId, updateCurrentUser: true),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        orderItems = _prepareOrderElements();
                        if (snapshot.hasData && snapshot.data != null) {
                          return _getDefaultWidget();
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
                      }
                  ) : _getDefaultWidget(),
                ),
                showSpinner ? SohoSpinner() : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getDefaultWidget() {
    return Padding(
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
              borderColor: Color(0xff604848),
              unselectedColor: Colors.white,
              selectedColor: Color(0xff604848),
              children: controlWidgets,
              onSegmentChosen: (int value) {
                setState(() {
                  selectedTab = value;
                });
              },
              selectionIndex: selectedTab,
            ),
          ),
          ListView(
            children: selectedTab == 0 ? _getPastOrdersList() : _getOngoingOrdersList(),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  Widget _getNoOrdersItem() {
    return Column(
      children: <Widget>[
        SizedBox(height: 42.0),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          height: 90.0,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Color(0xffE4E4E4))
          ),
          child: Center(
            child: Text(
              'Todavía no has realizado ninguna orden.',
              style: lightStyle(fSize: 12.0),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _getPastOrdersList() {
    var list = List<Widget>();
    if (orderItems.isEmpty) {
      list.add(_getNoOrdersItem());
    } else {
      for (var element in orderItems) {
        var column = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 42.0),
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
                        style: boldStyle(
                          fSize: 14.0,
                          color: Color(0xff5A6265),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        element.date,
                        style: lightStyle(
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
                children: _getProductsList(element.items, context),
              ),
              SizedBox(height: 16.0),
              Divider(
                height: 1.0,
                color: Color(0xffE5E4E5),
              ),
              SizedBox(height: 24.0),
              Center(
                child: Text(
                  'Total: MX${element.price}',
                  style: regularStyle(fSize: 16.0),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  await sendEmail(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Color(0xffCCC5BA),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                    child: Text(
                      '¿Necesitas ayuda?',
                      style: boldStyle(
                        fSize: 14.0,
                        color: Colors.white,
                      ),
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
        list.add(column);
      }
    }
    return list;
  }

  List<Widget> _getOngoingOrdersList() {
    var list = List<Widget>();
    if (orderItems.isEmpty) {
      list.add(_getNoOrdersItem());
    } else {
      for (var element in orderItems) {
        var column = Column(
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
                        'Quedan ${element.validDays} días para canjear el código QR',
                        style: boldStyle(
                          fSize: 14.0,
                          color: Color(0xff5A6265),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        element.date,
                        style: lightStyle(
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
                children: _getProductsList(element.items, context),
              ),
              SizedBox(height: 16.0),
              Divider(
                height: 1.0,
                color: Color(0xffE5E4E5),
              ),
              SizedBox(height: 24.0),
              Center(
                child: Text(
                  'Total: MX${element.price}',
                  style: regularStyle(fSize: 16.0, fWeight: FontWeight.w600),
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
                        setState(() {
                          showCode = !showCode;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Color(0xffCCC5BA),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Center(
                          child: Text(
                            showCode ? 'Ocultar código' : 'Mostrar código',
                            style: boldStyle(
                              fSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await sendEmail(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Color(0xffCCC5BA),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Center(
                          child: Text(
                            '¿Necesitas ayuda?',
                            style: boldStyle(
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
              showCode ? Center(
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
              ) : SizedBox.shrink(),
              SizedBox(height: 52.0),
              Image(
                image: menuDivider,
              ),
            ]
        );
        list.add(column);
      }
    }
    return list;
  }

  List<Widget> _getProductsList(List<OrderSelectedProduct> products, BuildContext context) {
    List<Widget> list = List<Widget>();
    for (var product in products) {
      list.add(GestureDetector(
        onTap: () async {
          updateSpinner(show: true);
          await locator<SquareHTTPRequest>().getProductById(product.squareProductId, product.squareCategoryId, product.categoryName).then((product) async {
            updateSpinner(show: false);
            if (product != null) {
              Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProductDetail(
                    currentProduct: product,
                  ),
                ),
              );
            } else {
              await showDialog(
                context: context,
                child: SimpleDialog(
                  title: Text("Product no longer available"),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            }
          });
        },
        child: Row(
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
                  style: regularStyle(fSize: 14.0),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              product.name,
              style: regularStyle(fSize: 14.0),
            ),
          ],
        ),
      ));
      list.add(SizedBox(height: 5.0));

    }
    return list;
  }

  Future<void> sendEmail(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "¿Necesitas ayuda?",
            style: thinStyle(fSize: 24.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Envíanos un correo y nos pondremos en contacto contigo.',
                  style: boldStyle(fSize: 14.0),
                ),
                SizedBox(height: 15.0),
                TextField(
                  onChanged: (value) {
                    emailBody = value;
                  },
                  scrollPhysics: BouncingScrollPhysics(),
                  minLines: 10,
                  maxLines: 15,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  style: lightStyle(
                    fSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Escribe aquí...',
                    counterText: "",
                    hintStyle: lightStyle(
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
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () async {
                    // Make sure there's a logged in user
                    var loggedUserName = Application.currentUser != null ? Application.currentUser.username : "";
                    var loggedUserEmail = Application.currentUser != null ? Application.currentUser.email : "";
                    if (loggedUserEmail.isNotEmpty && loggedUserName.isNotEmpty) {
                      // Send email
                      String username = 'sohotestemail@gmail.com';
                      String pwd = 'J\$8gsgUAhc5\\d4qX';
                      final smtpServer = gmail(username, pwd);
                      final message = Message();
                      message.from = Address(loggedUserEmail, loggedUserName);
                      message.recipients.add(Constants.SOHO_SUPPORT_EMAIL);
                      message.subject = "Mensaje de soporte de $loggedUserName [$loggedUserEmail]";
                      message.text = emailBody;
                      message.envelopeFrom = loggedUserEmail;

                      try {
                        Navigator.pop(context);
                        updateSpinner(show: true);
                        await send(message, smtpServer);
                        updateSpinner(show: false);
                        // Notify user
                        Fluttertoast.showToast(
                          msg: "Mensaje enviado.",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIos: 2,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Color(0xCCB9E1D8),
                          textColor: Colors.white
                        );

                      } on MailerException catch(e) {
                        Fluttertoast.showToast(
                            msg: "Error al enviar email.",
                            toastLength: Toast.LENGTH_LONG,
                            timeInSecForIos: 4,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color(0x99E51F4F),
                            textColor: Colors.white
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "No se encontró un usuario activo.",
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIos: 4,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Color(0x99E51F4F),
                          textColor: Colors.white
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Color(0xffF0AB31),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                      child: Text(
                        'Enviar correo',
                        style: boldStyle(
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
        );
      }
    );
  }

}
