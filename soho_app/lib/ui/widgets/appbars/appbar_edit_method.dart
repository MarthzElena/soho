import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soho_app/Auth/AppController.dart';
import 'package:soho_app/States/EditCardState.dart';
import 'package:soho_app/States/EditProfileState.dart';
import 'package:soho_app/Utils/Application.dart';
import 'package:soho_app/Utils/Constants.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/Utils/Routes.dart';
import 'package:soho_app/ui/utils/asset_images.dart';

enum EditMethodAppBarState {
  PROFILE,
  PAYMENT_METHODS
}

class EditMethodAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isPencil;
  final EditMethodAppBarState state;

  EditMethodAppBar({
    this.title = 'EDITAR MÉTODO DE PAGO',
    this.isPencil = false,
    this.state = EditMethodAppBarState.PAYMENT_METHODS
  });

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 22.0,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.all(0.0),
                          child: Image(
                            image: isPencil ? detailBack : menuCross,
                            width: 22.0,
                            height: 22.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      AutoSizeText(
                        title,
                        style: interLightStyle(fSize: 18.0),
                        maxLines: 1,
                        maxFontSize: 18.0,
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox.shrink()),
                  Container(
                    width: 22.0,
                    child: FlatButton(
                      onPressed: () async {
                        switch (state) {
                          case EditMethodAppBarState.PROFILE:
                            if (isPencil) {
                              Navigator.pushNamed(context, Routes.editProfile);
                            } else {
                              // Save data
                              locator<UserProfileState>().updateUserData();
                              await locator<AppController>().updateUserInDatabase(Application.currentUser.getJson()).then((_) {
                                Navigator.pop(context);
                              });
                            }
                            break;
                          case EditMethodAppBarState.PAYMENT_METHODS:
                            // Call method to update from model
                            var model = locator<EditCardState>();
                            model.updateSpinner(show: true);
                            await model.updateCardData().then((_) {
                              model.updateSpinner(show: false);
                              Navigator.pop(context);
                            }).catchError((error) {
                              // TODO: Handle update card error
                            });
                            break;
                        }
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        image: isPencil ? menuPencil : menuCheck,
                        width: 22.0,
                        height: 22.0,
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
