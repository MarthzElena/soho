import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/SohoMenu/CategoryObject.dart';
import 'package:soho_app/ui/widgets/items/item_small.dart';

class SmallCarousel extends StatefulWidget {
  final List<CategoryObject> list;
  final String backgroundImage;

  SmallCarousel({this.list, this.backgroundImage = ''});

  @override
  _SmallCarouselState createState() => _SmallCarouselState();
}

class _SmallCarouselState extends State<SmallCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      viewportFraction: 0.7,
      initialPage: 1,
      height: 90.0,
      enableInfiniteScroll: false,
      items: widget.list.map((category) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                var categoryObject = jsonEncode(category.toJson());
                var route = "CategoryDetail/$categoryObject";
                Navigator.pushNamed(context, route);
              },
              child: SmallItem(
                category: category.name,
                item: 'English Item',
                date: 'Ago 23 2019',
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
