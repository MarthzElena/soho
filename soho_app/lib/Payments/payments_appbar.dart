import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PaymentsAppBar extends StatelessWidget {
  final Icon icon;
  final Icon secondaryIcon;
  final String title;
  final VoidCallback action;
  final VoidCallback secondaryAction;

  PaymentsAppBar({
    this.icon,
    this.secondaryIcon,
    this.title = '',
    this.action,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            onPressed: action,
            icon: icon,
            color: Color(0xff002A3A),
            iconSize: 14.0,
          ),
          AutoSizeText(
            title,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'InterUI',
              fontStyle: FontStyle.normal,
            ),
            minFontSize: 12.0,
            maxFontSize: 18.0,
            maxLines: 1,
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          onPressed: secondaryAction,
          icon: secondaryIcon,
          color: Color(0xff002A3A),
          iconSize: 14.0,
        ),
      ],
    );
  }
}
