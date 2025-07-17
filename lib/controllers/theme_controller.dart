import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ThemeChange extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;
  ThemeMode get currentTheme => _currentTheme;

  themeChange(bool isDark) {
    if (isDark) {
      _currentTheme = ThemeMode.dark;
    } else {
      _currentTheme = ThemeMode.light;
    }
    return;
  }

  void toggleTheme() async {
    if (_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;

      log('Dark Theme ${_currentTheme.toString()}');
      await setValue('is_dark', true);
    } else {
      _currentTheme = ThemeMode.light;
      log('Light Theme ${_currentTheme.toString()}');
      await setValue('is_dark', false);
    }
    notifyListeners();
  }
}
