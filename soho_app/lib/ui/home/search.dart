import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soho_app/States/SearchState.dart';
import 'package:soho_app/Utils/Locator.dart';
import 'package:soho_app/ui/widgets/appbars/appbar_search.dart';

class SearchScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return _SearchScreenState();
  }

}

class _SearchScreenState extends State<SearchScreen> {
  SearchState _model = locator<SearchState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: ScopedModel<SearchState>(
          model: _model,
          child: ScopedModelDescendant<SearchState>(
              builder: (builder, child, model) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  resizeToAvoidBottomPadding: true,
                  appBar: SearchAppBar(),
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