import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/ui/widgets/items/item_large.dart';

class LargeCarousel extends StatefulWidget {
  final List<CategoryObject> list;
  final String backgroundImage;

  LargeCarousel({this.list, this.backgroundImage = ''});

  @override
  _LargeCarouselState createState() => _LargeCarouselState();
}

class _LargeCarouselState extends State<LargeCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      viewportFraction: 0.5,
      initialPage: 1,
      height: 245.0,
      enableInfiniteScroll: false,
      items: widget.list.map((category) {
        return Builder(
          builder: (BuildContext context) {
            return LargeItem(category: category);
          },
        );
      }).toList(),
    );
  }
}
