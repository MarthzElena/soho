import 'package:flutter/material.dart';

class SohoSpinner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color.fromRGBO(255, 255, 255, 0),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 7.0,
        ),
      ),
    );
  }

}