import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Fonts.dart';

class FeaturedDetailWidget extends StatelessWidget {
  final String image;
  final String text1;
  final String text2;

  FeaturedDetailWidget({
    this.image = '',
    this.text1 = 'CEREMONIAS\n DE TÉ',
    this.text2 = 'Una experiencia en tu\n mesa',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffF3F1F2),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerLeft,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          AutoSizeText(
            text1,
            style: interThinStyle(
              fSize: 32.0,
            ),
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.0),
          AutoSizeText(
            text2,
            style: interLightStyle(
              fSize: 14.0,
            ),
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 72.0),
        ],
      ),
    );
  }
}
