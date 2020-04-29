import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Fonts.dart';

class FeaturedWidget extends StatelessWidget {
  final String image;
  final String text1;
  final String text2;
  final String text3;
  final bool isLeft;

  FeaturedWidget({
    this.image = 'assets/home/tmp_background_home.png',
    this.text1 = 'Disfruta una auténtica',
    this.text2 = 'ceremonia',
    this.text3 = 'DE TÉ',
    this.isLeft = true,
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
          crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              text1,
              style: boldStyle(
                fSize: 17.0,
              ),
            ),
            Text(
              text2,
              style: regularStyle(
                fSize: 29.0,
                fWeight: FontWeight.w300,
              ),
            ),
            Text(
              text3,
              style: regularStyle(
                fSize: 51.0,
                fWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
