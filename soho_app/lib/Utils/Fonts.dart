import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle interStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUI',
    );

TextStyle interThinStyle({double fSize = 16.0, Color color = Colors.black, spacing = 0.0}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIThin',
      letterSpacing: spacing,
    );

TextStyle interLightStyle({double fSize = 16.0, Color color = Colors.black, spacing = 0.0}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUILight',
      letterSpacing: spacing,
    );

TextStyle interELStyle({double fSize = 16.0, Color color = Colors.black, spacing = 0.0}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIExtraLight',
      letterSpacing: spacing,
    );

TextStyle interBlackStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIBlack',
    );

TextStyle interBlackIStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIBlackItalic',
    );

TextStyle interBoldStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIBold',
    );

TextStyle interBoldIStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIBoldItalic',
    );

TextStyle interItalicStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIItalic',
    );

TextStyle interMediumStyle({
  double fSize = 16.0,
  Color color = Colors.black,
  TextDecoration decoration = TextDecoration.none,
}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIMedium',
      decoration: decoration,
    );

TextStyle interMediumIStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'InterUIMediumItalic',
    );
