import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/providers/theme_provider.dart';
import 'package:quran_app/providers/settings_provider.dart';
import 'package:quran_app/providers/audio_provider.dart';
import 'package:quran_app/providers/radio_provider.dart';
import 'package:quran_app/providers/search_provider.dart';
import 'package:quran_app/providers/bookmark_provider.dart';
import 'package:quran_app/providers/prayer_times_provider.dart';
import 'package:quran_app/screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar', null);
  });

  // Helper function to create the test widget with all providers
  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => RadioProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  // Helper function to create the test widget wrapping MyApp with all providers
  Widget createMyAppTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => RadioProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
      ],
      child: const MyApp(),
    );
  }

  testWidgets('MyApp should build without errors', (WidgetTester tester) async {
    // Set a large enough screen size to avoid overflow
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createMyAppTestWidget());
    expect(find.byType(MaterialApp), findsOneWidget);

    // Reset window size
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('HomeScreen should display app title', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('تطبيق إسلامي'), findsOneWidget);
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('HomeScreen should display Quran feature', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('القرآن الكريم'), findsWidgets);
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('HomeScreen should display settings icon', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.settings), findsOneWidget);
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('HomeScreen should display theme toggle icon', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Icon &&
            (widget.icon == Icons.dark_mode || widget.icon == Icons.light_mode),
      ),
      findsOneWidget,
    );
    addTearDown(tester.view.resetPhysicalSize);
  });
}
