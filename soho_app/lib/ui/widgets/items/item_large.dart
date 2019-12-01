import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Fonts.dart';

class LargeItem extends StatelessWidget {
  final dynamic category;

  LargeItem({this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      constraints: BoxConstraints.expand(),
      alignment: Alignment(-1.0, 0.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 190.0,
            // decoration attribute is TEMPORAL
            decoration: BoxDecoration(
              color: Color(0xffF3F1F2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: GestureDetector(
              onTap: () {
                var categoryObject = jsonEncode(category.toJson());
                var route = "CategoryDetail/$categoryObject";
                Navigator.pushNamed(context, route);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                category.subtitle,
                textAlign: TextAlign.start,
                style: interLightStyle(fSize: 12.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Container(
              height: 19.0,
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                category.name,
                textAlign: TextAlign.start,
                style: interMediumStyle(fSize: 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
