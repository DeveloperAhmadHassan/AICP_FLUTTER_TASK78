import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light(); // Initial theme

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners(); // Notify listeners to rebuild
  }
}
