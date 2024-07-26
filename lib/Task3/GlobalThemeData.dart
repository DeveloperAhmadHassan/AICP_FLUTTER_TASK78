import 'package:flutter/material.dart';

class GlobalThemData {
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(colorScheme: colorScheme, focusColor: focusColor);
  }
}