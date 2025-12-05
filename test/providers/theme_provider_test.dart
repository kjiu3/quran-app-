import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    test('Initial theme should be light mode', () {
      expect(themeProvider.isDarkMode, false);
    });

    test('toggleTheme should switch between light and dark mode', () async {
      // Initially light mode
      expect(themeProvider.isDarkMode, false);

      // Toggle to dark mode
      await themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, true);

      // Toggle back to light mode
      await themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, false);
    });
  });
}
