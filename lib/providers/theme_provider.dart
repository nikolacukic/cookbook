import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  var _currentTheme = ThemeMode.light;
  ThemeMode get getCurrentTheme => _currentTheme;

  void switchMode() {
    if (_currentTheme == ThemeMode.light)
      _currentTheme = ThemeMode.dark;
    else
      _currentTheme = ThemeMode.light;
    notifyListeners();
  }
}
