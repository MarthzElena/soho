import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/purchases/history.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_share.dart';
import 'package:flutter_share_file/flutter_share_file.dart';

class ThanksScreen extends StatefulWidget {
  final String qrCodeData;

  ThanksScreen(this.qrCodeData);

  @override
  _ThanksScreenState createState() => _ThanksScreenState();
}

class _ThanksScreenState extends State<ThanksScreen> {
  GlobalKey _globalKey = GlobalKey();
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: SharingAppBar(),
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
                  RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      color: Colors.white,
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
                                image: purchasesBag,
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
                                    'GRACIAS\nPOR TU\nCOMPRA',
                                    style: interThinStyle(fSize: 32.0),
                                  ),
                                  SizedBox(height: 4.0),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Escanea este código en\ntu sucursal de Soho\nfavorita. ',
                                      style: interLightStyle(
                                        fSize: 14.0,
                                        color: Color(0xff292929),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Ver ubicación',
                                          style: interStyle(
                                            fSize: 14.0,
                                            color: Color(0xffE51F4F),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.0),
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
                                  data: widget.qrCodeData,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HistoryScreen(isOngoingOrder: true)),
                              ModalRoute.withName(Routes.homePage)
                            );
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
                                'Guardar en mis pedidos',
                                style: interBoldStyle(
                                  fSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '🎁  ¿Tu orden es un regalo?',
                                  style: interBoldStyle(fSize: 14.0),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Envía esta compra a tu novia, tu mamá, o tu mejor amigo. Él o ella podrá redimirlo en la sucursal de SOHO.',
                                  style: interLightStyle(fSize: 14.0),
                                ),
                                SizedBox(height: 24.0),
                                GestureDetector(
                                  onTap: () {
                                    _shareCode();
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
                                        'Enviar código QR',
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
      ),
    );
  }

  Future<void> _shareCode() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      FlutterShareFile.shareImage(file.path, 'image.png', 'Share image test');

    } catch(e) {
      print("Error while sharing code: ${e.toString()}");
    }
  }
}
