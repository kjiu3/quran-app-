import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مزود إدارة اللغة
class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar', 'SA');
  static const String _languageKey = 'selected_language';

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  /// تحميل اللغة المحفوظة
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);

      if (savedLanguage != null) {
        _locale = _getLocaleFromString(savedLanguage);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  /// تغيير اللغة
  Future<void> setLanguage(String languageCode) async {
    try {
      _locale = _getLocaleFromString(languageCode);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      notifyListeners();
    } catch (e) {
      debugPrint('Error setting language: $e');
    }
  }

  /// الحصول على Locale من كود اللغة
  Locale _getLocaleFromString(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return const Locale('ar', 'SA');
      case 'en':
        return const Locale('en', 'US');
      case 'fr':
        return const Locale('fr', 'FR');
      case 'ur':
        return const Locale('ur', 'PK');
      default:
        return const Locale('ar', 'SA');
    }
  }

  /// الحصول على اسم اللغة الحالية
  String get currentLanguageName {
    switch (_locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ur':
        return 'اردو';
      default:
        return 'العربية';
    }
  }

  /// الحصول على كود اللغة الحالية
  String get currentLanguageCode => _locale.languageCode;

  /// التحقق من اتجاه النص (RTL أو LTR)
  bool get isRTL =>
      _locale.languageCode == 'ar' || _locale.languageCode == 'ur';
}
