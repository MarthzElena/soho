import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_history.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Map<int, Widget> controlWidgets = const <int, Widget>{
    0: Text('Ordenes anteriores'),
    1: Text('Ordenes pendientes'),
  };

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
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
                              'Agosto 13, 2019 12:12 AM',
                              style: interLightStyle(
                                fSize: 14.0,
                                color: Color(0xff5A6265),
                              ),
                            ),
                            Text(
                              'Órden # 62782',
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
                    Row(
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
                          'Té Negro Assam Hunwal',
                          style: interMediumStyle(fSize: 14.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Divider(
                      height: 1.0,
                      color: Color(0xffE5E4E5),
                    ),
                    SizedBox(height: 24.0),
                    Center(
                      child: Text(
                        'Total: MX\$348.00',
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
                            onTap: null,
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
                      ),
                    ),
                    SizedBox(height: 52.0),
                    Image(
                      image: menuDivider,
                    ),
                    SizedBox(height: 52.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
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
                              'Código QR listo',
                              style: interBoldStyle(
                                fSize: 14.0,
                                color: Color(0xff5A6265),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Agosto 13, 2019 12:12 AM',
                              style: interLightStyle(
                                fSize: 14.0,
                                color: Color(0xff5A6265),
                              ),
                            ),
                            Text(
                              'Órden # 62782',
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
                    Row(
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
                          'Té Negro Assam Hunwal',
                          style: interMediumStyle(fSize: 14.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Divider(
                      height: 1.0,
                      color: Color(0xffE5E4E5),
                    ),
                    SizedBox(height: 32.0),
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
