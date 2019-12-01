import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Fonts.dart';

class FeaturedWidget extends StatelessWidget {
  final String image;
  final String text1;
  final String text2;
  final String text3;

  FeaturedWidget({
    this.image = 'assets/home/tmp_background_home.png',
    this.text1 = 'Disfruta una auténtica',
    this.text2 = 'ceremonia',
    this.text3 = 'DE TÉ',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              text1,
              style: interBoldStyle(
                fSize: 17.0,
              ),
            ),
            Text(
              text2,
              style: interELStyle(
                fSize: 27.0,
                spacing: 1.0,
              ),
            ),
            Text(
              text3,
              style: interThinStyle(
                fSize: 51.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
