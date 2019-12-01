import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreConfiguredLayout extends StatelessWidget {
  final Widget buildWidget;
  final bool statusColor;
  final Color backgroundColor;

  PreConfiguredLayout({
    this.buildWidget,
    this.statusColor = true,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomPadding: true,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: (Platform.isAndroid)
                ? statusColor
                    ? SystemUiOverlayStyle.dark.copyWith(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.light,
                      )
                    : SystemUiOverlayStyle.light.copyWith(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.dark,
                      )
                : statusColor
                    ? SystemUiOverlayStyle.dark.copyWith(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.light,
                      )
                    : SystemUiOverlayStyle.light.copyWith(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.dark,
                      ),
            child: buildWidget,
          ),
        ),
      ),
    );
  }
}
