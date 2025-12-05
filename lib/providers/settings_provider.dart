import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _fontSizeKey = 'fontSize';
  static const String _fontFamilyKey = 'fontFamily';
  static const String _primaryColorKey = 'primaryColor';

  double _fontSize = 16.0;
  String _fontFamily = 'Amiri';
  Color _primaryColor = Colors.orange;

  final List<String> availableFonts = [
    'Amiri',
    'Cairo',
    'Noor',
    'Quran',
  ];

  final List<Color> availableColors = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.teal,
  ];

  SettingsProvider() {
    _loadSettings();
  }

  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  Color get primaryColor => _primaryColor;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
    _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Amiri';
    _primaryColor = Color(prefs.getInt(_primaryColorKey) ?? Colors.orange.toARGB32());
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    if (size >= 12.0 && size <= 24.0) {
      _fontSize = size;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, size);
      notifyListeners();
    }
  }

  Future<void> setFontFamily(String family) async {
    if (availableFonts.contains(family)) {
      _fontFamily = family;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fontFamilyKey, family);
      notifyListeners();
    }
  }

  Future<void> setPrimaryColor(Color color) async {
    if (availableColors.contains(color)) {
      _primaryColor = color;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_primaryColorKey, color.toARGB32());
      notifyListeners();
    }
  }

  TextTheme get textTheme {
    return TextTheme(
      bodyLarge: TextStyle(
        fontSize: _fontSize,
        fontFamily: _fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: _fontSize - 2,
        fontFamily: _fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: _fontSize + 6,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
        color: _primaryColor,
      ),
    );
  }
}