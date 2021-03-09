import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/SquarePOS/SquareHTTPRequest.dart';
import 'package:soho_app/States/HomePageState.dart';
import 'package:soho_app/States/ProductItemState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar.dart';
import 'package:soho_app/ui/widgets/bottoms/bottom.dart';
import 'package:soho_app/ui/widgets/featured/featured.dart';
import 'package:soho_app/ui/widgets/layouts/carousel_large.dart';
import 'package:soho_app/ui/widgets/layouts/carousel_small.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:soho_app/Utils/FBPush.dart';
import 'package:soho_app/ui/widgets/layouts/spinner.dart';
import 'package:connectivity/connectivity.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomePageState _homePageState = locator<HomePageState>();
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();

    // INIT MESSAGING
    final FirebaseMessaging _fireBaseMsg = FirebaseMessaging();
    _fireBaseMsg.requestNotificationPermissions();
    setupFireBase(_fireBaseMsg);

    // Init connectivity listener
    _connectivity.initMethod();
    _connectivity.myStream.listen((source) async {
      if (source != null) {
        _source = source;
        switch (_source.keys.toList()[0]) {
          case ConnectivityResult.mobile:
          case ConnectivityResult.wifi:
            if (Application.sohoCategories.isEmpty) {
              // Get categories
              locator<SquareHTTPRequest>().getSquareCategories().then((categories) {
                if (categories.isNotEmpty) {
                  Application.sohoCategories = categories;
                }
              });
            }

            if (Application.featuredProduct.isEmpty) {
              // Get featured products
              await locator<AppController>().getFeaturedImageFromStorage();
            }

            // Get logged uer
            await locator<AppController>().getSavedAuthObject();

            _homePageState.updateState();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: ScopedModel<HomePageState>(
        model: _homePageState,
        child: ScopedModelDescendant<HomePageState>(
          builder: (builder, child, model) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomPadding: true,
              appBar: HomeAppBar(),
              drawer: _homePageState.drawer,
              bottomNavigationBar: Application.currentOrder != null ? BottomBar(buttonState: ProductItemState.GO_TO_CHECKOUT_TEXT) : SizedBox.shrink(),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 35.0),
                            Application.featuredProduct.isEmpty ? FeaturedWidget() :
                            Container(
                              height: 300.0,
                              width: double.infinity,
                              child: Image(image: NetworkImage(Application.featuredProduct)),
                            ),
                            SizedBox(height: 35.0),
                            Application.sohoCategories.isNotEmpty ?
                            LargeCarousel(list: Application.sohoCategories) :
                            Container(
                              margin: EdgeInsets.only(left: 16.0, right: 16.0),
                              height: 245.0,
                              width: double.infinity,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(
                                    'Debes tener conexión a internet para poder visualizar el menú de SOHO.',
                                    style: lightStyle(fSize: 24.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 35.0),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Pedido recientemente',
                                style: boldStyle(fSize: 16.0),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            model.getOrderList().isEmpty ?
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
                            ) :
                            SmallCarousel(list: model.getOrderList()),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                      model.showSpinner ? SohoSpinner() : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initMethod() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      print("SOCKET EXEPTION");
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
