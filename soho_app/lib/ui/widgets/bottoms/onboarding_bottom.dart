import 'package:flutter/material.dart';
import 'package:soho_app/States/OnboardingState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/auth/login.dart';
import 'package:soho_app/ui/purchases/onboarding_order.dart';
import 'package:soho_app/ui/purchases/onboarding_thanks.dart';

class OnboardingBottom extends StatefulWidget {
  final String instruction;
  final String buttonText1;
  final String buttonText2;

  OnboardingBottom({this.instruction, this.buttonText1, this.buttonText2 = ""});

  @override
  State<StatefulWidget> createState() {
    return _OnboardingBottom();
  }

}

class _OnboardingBottom extends State<OnboardingBottom> {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 170.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 25.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                15.0, // Move to right 10  horizontally
                15.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () async {
            switch (widget.buttonText1) {
              case "Agregar 1 a la orden":
                if (Application.currentUser != null) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OnboardingOrderScreen()));
                } else {
                  // Go to login
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())
                  );
                }
                break;
              case "Realizar pedido ahora":
                if (Application.currentUser != null) {
                  var model = locator<OnboardingState>();
                  await Application.currentUser.completeOnboardingOrder(model.selectedMilk, model.selectedSugar, Application.currentUser.username).then((codeData) {
                    model.qrData = codeData;
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OnboardingThanksScreen()));
                  });
                }
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.instruction,
                    style: regularStyle(
                      fSize: 14.0,
                      color: Color(0xff292929),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xffE51F4F),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: widget.buttonText2.isNotEmpty ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.buttonText1,
                          style: boldStyle(fSize: 14.0, color: Colors.white),
                        ),
                        Text(
                          widget.buttonText2,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ) :
                    Center(
                      child: Text(
                        widget.buttonText1,
                        style: boldStyle(fSize: 14.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.0),
              ],
            ),
          ),
        ),
    );
  }

}