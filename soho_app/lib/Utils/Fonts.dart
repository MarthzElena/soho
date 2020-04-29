import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle regularStyle({
  double fSize = 16.0,
  Color color = Colors.black,
  TextDecoration decoration = TextDecoration.none,
  FontWeight fWeight = FontWeight.w500,
}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'Lato',
      decoration: decoration,
      fontWeight: fWeight
    );

TextStyle thinStyle({double fSize = 16.0, Color color = Colors.black, spacing = 0.0}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoThin',
      letterSpacing: spacing,
    );

TextStyle thinItalicStyle({double fSize = 16.0, Color color = Colors.black, spacing = 0.0}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoThinItalic',
      letterSpacing: spacing,
    );

TextStyle lightStyle({double fSize = 16.0, Color color = Colors.black, spacing = 0.0}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoLight',
      letterSpacing: spacing,
    );

TextStyle lightItalicStyle({double fSize = 16.0, Color color = Colors.black, spacing = 0.0}) =>
    TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoLightItalic',
      letterSpacing: spacing,
    );

TextStyle blackStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoBlack',
    );

TextStyle blackItalicStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoBlackItalic',
    );

TextStyle boldStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoBold',
    );

TextStyle boldItalicStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoBoldItalic',
    );

TextStyle italicStyle({double fSize = 16.0, Color color = Colors.black}) => TextStyle(
      color: color,
      fontSize: fSize,
      fontFamily: 'LatoItalic',
    );
