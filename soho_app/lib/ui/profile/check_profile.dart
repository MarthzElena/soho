import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/EditProfileState.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_edit_method.dart';

class CheckProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String photo;

  CheckProfileScreen({this.name = 'Agrega un nombre de usuario', this.phone = 'Agrega un número de celular', this.email = "Arega un email de usuario", this.photo = ""});

  @override
  _CheckProfileScreenState createState() => _CheckProfileScreenState();
}

class _CheckProfileScreenState extends State<CheckProfileScreen> {
  UserProfileState _state = locator<UserProfileState>();

  @override
  void initState() {
    super.initState();

    // Update displayed data
    _state.updateDisplayEmail(widget.email);
    _state.updateDisplayPhone(widget.phone);
    _state.updateDisplayName(widget.name);
    _state.setPhotoUrl(widget.photo);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<UserProfileState>(
        model: _state,
        child: ScopedModelDescendant<UserProfileState>(
          builder: (builder, child, model) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
              appBar: EditMethodAppBar(title: 'MI PERFIL', isPencil: true, state: EditMethodAppBarState.PROFILE),
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: (Platform.isAndroid)
                      ? SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.light,
                  )
                      : SystemUiOverlayStyle.light.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarBrightness: Brightness.dark,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 32.0),
                          Text(
                            'Información personal',
                            style: interBoldStyle(),
                          ),
                          SizedBox(height: 24.0),
                          Container(
                            width: 64.0,
                            height: 64.0,
                            child: GestureDetector(
                              onTap: () {

                              },
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    child: Container(
                                      height: 64.0,
                                      width: 64.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Color(0xffE6E7EB), width: 1.0),
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                      child: model.photoUrl.isEmpty ?
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(100.0),
                                        ),
                                      ) :
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(model.photoUrl),
                                          )
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Nombre de usuario',
                            style: interStyle(
                              fSize: 14.0,
                              color: Color(0xff565758),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            model.name,
                            style: interLightStyle(
                              fSize: 14.0,
                              color: Color(0xffC4C4C4),
                            ),
                          ),
                          SizedBox(height: 32.0),
                          Text(
                            'Número de celular',
                            style: interStyle(
                              fSize: 14.0,
                              color: Color(0xff565758),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            model.phone,
                            style: interLightStyle(
                              fSize: 14.0,
                              color: Color(0xffC4C4C4),
                            ),
                          ),
                          SizedBox(height: 32.0),
                          Text(
                            'Correo electrónico',
                            style: interStyle(
                              fSize: 14.0,
                              color: Color(0xff565758),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            model.email,
                            style: interLightStyle(
                              fSize: 14.0,
                              color: Color(0xffC4C4C4),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      )
    );
  }
}
