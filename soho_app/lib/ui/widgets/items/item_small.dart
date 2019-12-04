import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Fonts.dart';

class SmallItem extends StatelessWidget {
  final String category;
  final String item;
  final String date;

  SmallItem({this.category = '', this.item = '', this.date = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF3F1F2),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category,
                      style: interMediumStyle(fSize: 12.0),
                    ),
                    Text(
                      item,
                      style: interMediumStyle(fSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Ordenado: $date',
                      style: interMediumStyle(fSize: 10.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
