import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/SohoMenu/SohoOrders/SohoOrderObject.dart';
import 'package:soho_app/ui/purchases/history.dart';
import 'package:soho_app/ui/widgets/items/item_small.dart';

class SmallCarousel extends StatefulWidget {
  final List<SohoOrderObject> list;
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
      items: widget.list.map((order) { // TODO: Add default for empty list
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HistoryScreen(isOngoingOrder: order.isQRCodeValid))
                );
              },
              child: SmallItem(
                category: order.selectedProducts.first.categoryName,
                item: order.selectedProducts.first.name,
                date: order.getCompletedDateShort(),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
