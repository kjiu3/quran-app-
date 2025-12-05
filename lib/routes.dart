// cSpell:words azkar Azkar mushaf Mushaf مسار افتراضي حالة عدم وجود المسار المطلوب خطأ الصفحة غير موجودة
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/radio_screen.dart';
import 'screens/hadith_screen.dart';
import 'screens/audio_screen.dart';
import 'screens/azkar_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/mushaf_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tasbih_screen.dart';
import 'screens/allah_names_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/search_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/tafsir_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/login_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/quran': (context) => const QuranScreen(),
    '/hadith': (context) => const HadithScreen(),
    '/azkar': (context) => const AzkarScreen(),
    '/qibla': (context) => const QiblaScreen(),
    '/radio': (context) => const RadioScreen(),
    '/audio': (context) => const AudioScreen(),
    '/calendar': (context) => const CalendarScreen(),
    '/mushaf': (context) => const MushafScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/tasbih': (context) => const TasbihScreen(),
    '/allah_names': (context) => const AllahNamesScreen(),
    '/notifications': (context) => const NotificationsScreen(),
    '/search': (context) => const SearchScreen(),
    '/bookmarks': (context) => const BookmarksScreen(),
    '/prayer_times': (context) => const PrayerTimesScreen(),
    '/statistics': (context) => const StatisticsScreen(),
    '/login': (context) => const LoginScreen(),
    // التفسير يحتاج معاملات، لذلك يتم التعامل معه في onGenerateRoute
  };

  // معالجة المسارات مع المعاملات
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/tafsir') {
      final args = settings.arguments as Map<String, dynamic>?;
      final surahNumber = args?['surahNumber'] ?? 1;
      final verseNumber = args?['verseNumber'] ?? 1;
      return MaterialPageRoute(
        builder:
            (context) => TafsirScreen(
              surahNumber: surahNumber,
              verseNumber: verseNumber,
            ),
      );
    }
    return null;
  }

  // مسار افتراضي في حالة عدم وجود المسار المطلوب
  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            appBar: AppBar(title: const Text('خطأ')),
            body: const Center(child: Text('الصفحة غير موجودة')),
          ),
    );
  }
}
