import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/radio_provider.dart';
import 'providers/search_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/prayer_times_provider.dart';
import 'providers/tafsir_provider.dart';
import 'providers/statistics_provider.dart';
import 'providers/language_provider.dart';
import 'providers/auth_provider.dart';
import 'routes.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // ملف firebase_options.dart لم يتم تكوينه بعد
    // سيعمل التطبيق بدون Firebase حتى يتم تشغيل flutterfire configure
    debugPrint('Firebase not configured yet: $e');
  }

  await initializeDateFormatting('ar', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => RadioProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        ChangeNotifierProvider(create: (_) => TafsirProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'تطبيق القرآن الكريم',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'SA'),
            Locale('en', 'US'),
            Locale('fr', 'FR'),
            Locale('ur', 'PK'),
          ],
          locale: languageProvider.locale,
          initialRoute: '/',
          routes: AppRoutes.routes,
          onGenerateRoute:
              (settings) =>
                  AppRoutes.onGenerateRoute(settings) ??
                  AppRoutes.unknownRoute(settings),
        );
      },
    );
  }
}
