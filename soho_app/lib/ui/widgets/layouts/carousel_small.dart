import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/HomePage/HomePageStateController.dart';
import 'package:soho_app/ui/purchases/history.dart';
import 'package:soho_app/ui/widgets/items/item_small.dart';

class SmallCarousel extends StatefulWidget {
  final List<RecentOrdersElement> list;
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
      items: widget.list.map((element) { // TODO: Add default for empty list
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HistoryScreen(isOngoingOrder: element.isCodeValid))
                );
              },
              child: SmallItem(
                category: element.categoryName,
                item: element.name,
                date: element.orderedAt,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
