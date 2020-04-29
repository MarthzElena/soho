import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_simple.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: SimpleAppBar(),
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
                        image: aboutImage,
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
                            'ACERCA',
                            style: thinStyle(fSize: 32.0),
                          ),
                          Text(
                            'DE SOHO',
                            style: thinStyle(fSize: 32.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Nos esforzamos por\nbrindarte la mejor\nexperiencia.',
                            style: lightStyle(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 24.0),
                        Text(
                          'Occaecat commodo consectetur culpa culpa minim consequat eu aliqua enim dolore aliqua commodo in.',
                          style: boldStyle(fSize: 16.0),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Duis pariatur dolor deserunt sint et pariatur excepteur fugiat proident anim do sunt deserunt. Veniam magna aliquip duis tempor sit velit velit consequat proident. Enim qui cupidatat est eiusmod nisi aute aliqua irure nulla enim ipsum. Incididunt amet proident deserunt esse commodo ipsum cillum consectetur cillum velit incididunt mollit in. Et in ea magna deserunt deserunt enim sint. Veniam reprehenderit mollit non excepteur laborum aliquip commodo irure culpa laboris nostrud. Ut occaecat reprehenderit proident ea consequat adipisicing enim id deserunt nostrud nisi anim. Te amo Max Atte: Raúl. Cillum incididunt exercitation anim et voluptate irure labore elit laborum. Id exercitation irure exercitation aute culpa excepteur veniam aute reprehenderit deserunt minim pariatur amet. Incididunt non velit voluptate cupidatat ex elit dolor adipisicing dolore pariatur. Sint commodo Lorem proident adipisicing amet veniam ut cillum esse ex in consectetur. Adipisicing ipsum duis dolore sit cupidatat nostrud esse non dolor est ad quis culpa duis. Incididunt aliquip esse sit ipsum incididunt. Nulla ad anim elit officia nulla deserunt officia fugiat eu culpa commodo aliqua velit. Reprehenderit dolor aliquip aute esse labore labore id. Velit et magna incididunt sint.',
                          style: lightStyle(fSize: 14.0),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Occaecat commodo consectetur culpa culpa minim consequat eu aliqua enim dolore aliqua commodo in.',
                          style: boldStyle(fSize: 16.0),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Duis pariatur dolor deserunt sint et pariatur excepteur fugiat proident anim do sunt deserunt. Veniam magna aliquip duis tempor sit velit velit consequat proident. Enim qui cupidatat est eiusmod nisi aute aliqua irure nulla enim ipsum. Incididunt amet proident deserunt esse commodo ipsum cillum consectetur cillum velit incididunt mollit in. Et in ea magna deserunt deserunt enim sint. Veniam reprehenderit mollit non excepteur laborum aliquip commodo irure culpa laboris nostrud. Ut occaecat reprehenderit proident ea consequat adipisicing enim id deserunt nostrud nisi anim. Te amo Max Atte: Raúl. Cillum incididunt exercitation anim et voluptate irure labore elit laborum. Id exercitation irure exercitation aute culpa excepteur veniam aute reprehenderit deserunt minim pariatur amet. Incididunt non velit voluptate cupidatat ex elit dolor adipisicing dolore pariatur. Sint commodo Lorem proident adipisicing amet veniam ut cillum esse ex in consectetur. Adipisicing ipsum duis dolore sit cupidatat nostrud esse non dolor est ad quis culpa duis. Incididunt aliquip esse sit ipsum incididunt. Nulla ad anim elit officia nulla deserunt officia fugiat eu culpa commodo aliqua velit. Reprehenderit dolor aliquip aute esse labore labore id. Velit et magna incididunt sint.',
                          style: lightStyle(fSize: 14.0),
                        ),
                        SizedBox(height: 32.0),
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
}
