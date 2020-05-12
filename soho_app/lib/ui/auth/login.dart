import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/LoginState.dart';
import 'package:soho_app/Utils/Fonts.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/utils/asset_images.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_product.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginState _loginState = locator<LoginState>();
  String smsCode = "";

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return Platform.isAndroid;
      },
      child: ScopedModel<LoginState>(
        model: _loginState,
        child: ScopedModelDescendant<LoginState>(
          builder: (build, child, model) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: ProductDetailAppBar(isLogin: true),
              resizeToAvoidBottomPadding: true,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 265.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: authImage,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image(
                                  image: splashLogo,
                                  width: 130,
                                ),
                                SizedBox(height: 18.0),
                                Text(
                                  'INICIAR',
                                  style: thinStyle(fSize: 32.0),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'SESIÓN',
                                  style: thinStyle(fSize: 32.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Número de teléfono',
                                style: regularStyle(
                                  fSize: 14.0,
                                  color: Color(0xff565758),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40.0,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.startsWith('+')) {
                                      model.phoneInput = value;
                                    } else {
                                      model.phoneInput = "+" + value;
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: lightStyle(
                                    fSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    hintText: '( +521 )  -  ( 33-33-33-33-33 )',
                                    prefixText: '+',
                                    hintStyle: lightStyle(
                                      fSize: 14.0,
                                      color: Color(0xffC4C4C4),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E4E5),
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E4E5),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E4E5),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32.0),
                              GestureDetector(
                                onTap: () => model.verifyPhone(context),
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: Border.all(
                                      color: Color(0xffCCC5BA),
                                      width: 2
                                    )
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Recibir código',
                                      style: boldStyle(
                                        fSize: 14.0,
                                        color: Color(0xff604848),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.0),
                              Center(
                                child: Text(
                                  'O también puedes entrar usando:',
                                  style: regularStyle(
                                    fSize: 14.0,
                                    color: Color(0xff565758),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.0),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        model.facebookLoginPressed(context).then((error) async {
                                          await showDialog(
                                            context: context,
                                            child: SimpleDialog(
                                              title: Text(error),
                                              children: <Widget>[
                                                SimpleDialogOption(
                                                  child: Text("OK"),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xffCCC5BA),
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Facebook',
                                            style: boldStyle(
                                              fSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await model.googleLoginPressed(context).then((error) async {
                                          await showDialog(
                                            context: context,
                                            child: SimpleDialog(
                                              title: Text(error),
                                              children: <Widget>[
                                                SimpleDialogOption(
                                                  child: Text("OK"),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xffCCC5BA),
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Gmail',
                                            style: boldStyle(
                                              fSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
