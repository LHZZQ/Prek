import 'package:_2025_prek/theme/theme.dart';
import 'package:_2025_prek/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
  });

  tearDown(() {
    binding.platformDispatcher.clearPlatformBrightnessTestValue();
  });

  group('theme definitions', () {
    test('lightMode use bright colors', () {
      final expectedTheme = ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(primary: Colors.black),
      );

      expect(lightMode.brightness, Brightness.light);
      expect(
        lightMode.colorScheme.background,
        expectedTheme.colorScheme.background,
      );
      expect(lightMode.colorScheme.primary, expectedTheme.colorScheme.primary);
    });

    test('darkMode use dark colors', () {
      final expectedTheme = ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(primary: Colors.white),
      );

      expect(darkMode.brightness, Brightness.dark);
      expect(
        darkMode.colorScheme.background,
        expectedTheme.colorScheme.background,
      );
      expect(darkMode.colorScheme.primary, expectedTheme.colorScheme.primary);
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
