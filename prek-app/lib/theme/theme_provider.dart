import 'package:flutter/material.dart';
import 'package:_2025_prek/theme/theme.dart';
import 'package:flutter/scheduler.dart';

/*class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
*/

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  ThemeProvider() {
    // Detects device brightness on startup
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    _isDark = brightness == Brightness.dark;
  }

  bool get isDark => _isDark;

  ThemeData get themeData => _isDark ? darkMode : lightMode;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
