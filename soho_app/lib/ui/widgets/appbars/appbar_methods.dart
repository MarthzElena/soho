import 'package:flutter/material.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/ui/payments/add_method.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

class PaymentMethodsAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 15.0,
                    child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        image: detailBack,
                        width: 22.0,
                        height: 22.0,
                      ),
                    ),
                  ),
                  Container(
                    width: 30.0,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddMethodScreen(),
                        ),
                      ),
                      child: Image(
                        image: paymentAdd,
                        width: 30.0,
                        height: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Constants.APP_BAR_HEIGHT + 36.0);
}
