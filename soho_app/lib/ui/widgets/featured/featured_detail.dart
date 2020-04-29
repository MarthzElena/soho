import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Fonts.dart';

class FeaturedDetailWidget extends StatelessWidget {
  final String image;
  final String text1;
  final String text2;
  final int backgroundColor;

  FeaturedDetailWidget({
    this.image = '',
    this.text1 = 'CEREMONIAS\n DE TÉ',
    this.text2 = 'Una experiencia en tu\n mesa',
    this.backgroundColor = 0xffF3F1F2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(backgroundColor),
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
            style: regularStyle(
              fSize: 32.0,
              fWeight: FontWeight.w300,
            ),
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.0),
          AutoSizeText(
            text2,
            style: regularStyle(
              fSize: 16.0,
              fWeight: FontWeight.w300,
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
