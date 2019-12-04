import 'package:flutter/material.dart';
import 'package:soho_app/Payments/payments_appbar.dart';
import 'package:soho_app/Utils/Constants.dart';

class CardInformationScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APP_BAR_HEIGHT),
        child: PaymentsAppBar(
          icon: Icon(Icons.close),
          secondaryIcon: Icon(null),
          title: 'INFORMACIÓN DE LA TARJETA',
          action: null,
          secondaryAction: null,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 34.0),
            Text(
              'Nombre en la tarjeta',
              style: TextStyle(
                fontFamily: 'InterUI',
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 40.0,
              child: TextField(

              ),
            ),
          ],
        ),
      ),
    );
  }
}
