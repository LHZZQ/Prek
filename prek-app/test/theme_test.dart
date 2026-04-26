import 'package:_2025_prek/theme/theme.dart';
import 'package:_2025_prek/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('theme definitions', () {
    test('lightMode use bright colors', () {
      expect(lightMode.brightness, Brightness.light);
      expect(lightMode.colorScheme.background, Colors.black);
      expect(lightMode.colorScheme.primary, Colors.black);
    });

    test('darkMode use dark colors', () {
      expect(darkMode.brightness, Brightness.dark);
      expect(darkMode.colorScheme.background, Colors.white);
      expect(darkMode.colorScheme.primary, Colors.white);
    });
  });

  group('ThemeProvider', () {
    test('starts with lightMode', () {
      final provider = ThemeProvider();
      expect(provider.themeData, same(lightMode));
    });

    /*test('themeData setter updates theme and notifies listeners', () {
      final provider = ThemeProvider();
      var notifyCount = 0;

      provider.addListener(() {
        notifyCount++;
      });

      provider.themeData = darkMode;

      expect(provider.themeData, same(darkMode));
      expect(notifyCount, 1);
    });
    */

    test('switches between light and dark', () {
      final provider = ThemeProvider();

      provider.toggleTheme();
      expect(provider.themeData, same(darkMode));

      provider.toggleTheme();
      expect(provider.themeData, same(lightMode));
    });
  });
}
