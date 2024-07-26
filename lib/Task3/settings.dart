import 'package:aicp_internship/Task3/color_ext.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  Color _primarySwatch = HexColor.fromHexStr("#2196F3");
  Color _textSwatch = HexColor.fromHexStr("#2196F3");
  Color? _lightTextSwatch = HexColor.fromHexStr("#2196F3");
  Color _secondarySwatch = HexColor.fromHexStr("#BBDEFB");
  double _fontSize = 16.0; /// Default font size

  Color get primarySwatch => _primarySwatch;
  Color get textSwatch => _textSwatch;
  Color get secondarySwatch => _secondarySwatch;
  Color? get lightTextSwatch => _lightTextSwatch;
  double get fontSize => _fontSize;

  void setPrimarySwatch(Color color) {
    _primarySwatch = color;
    notifyListeners();
  }

  void setTextSwatch(Color color) {
    _textSwatch = color;
    notifyListeners();
  }

  void setSecondarySwatch(Color color) {
    _secondarySwatch = color;
    notifyListeners();
  }
  void setLightTextSwatch(Color color) {
    _lightTextSwatch = color;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }
}
