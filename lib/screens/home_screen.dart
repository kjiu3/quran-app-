import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../models/feature.dart';
import '../widgets/feature_card.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // قائمة الميزات
    final List<Feature> features = [
      // القرآن الكريم يحتفظ بأيقونته الخاصة
      Feature(
        title: l10n.quran,
        icon: 'assets/icons/quran.png',
        route: '/quran',
      ),
      // الميزات التالية تستخدم أيقونات مادّة بدلاً من صور مفقودة
      Feature(title: l10n.radio, materialIcon: Icons.radio, route: '/radio'),
      Feature(
        title: l10n.hadithLibrary,
        materialIcon: Icons.menu_book,
        route: '/hadith',
      ),
      Feature(
        title: l10n.audioLibrary,
        materialIcon: Icons.headphones,
        route: '/audio',
      ),
      Feature(
        title: l10n.azkarPrayers,
        materialIcon: Icons.auto_awesome,
        route: '/azkar',
      ),
      Feature(
        title: l10n.allahNames,
        materialIcon: Icons.star,
        route: '/allah_names',
      ),
      Feature(title: l10n.qibla, materialIcon: Icons.explore, route: '/qibla'),
      Feature(
        title: l10n.hijriCalendar,
        materialIcon: Icons.calendar_today,
        route: '/calendar',
      ),
      Feature(
        title: l10n.tasbih,
        materialIcon: Icons.fingerprint,
        route: '/tasbih',
      ),
      Feature(
        title: l10n.notifications,
        materialIcon: Icons.notifications,
        route: '/notifications',
      ),
      Feature(
        title: l10n.myStatistics,
        materialIcon: Icons.bar_chart,
        route: '/statistics',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: Text(
          l10n.islamicApp,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: l10n.settings,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip:
                    themeProvider.isDarkMode
                        ? l10n.lightMode
                        : l10n.darkModeLabel,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // التاريخ الهجري
            Builder(
              builder: (context) {
                final hijriDate = HijriCalendar.now();
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    '${_toArabicNumber(hijriDate.hDay)} - ${hijriDate.longMonthName} - ${_toArabicNumber(hijriDate.hYear)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                );
              },
            ),
            // التاريخ الميلادي
            Builder(
              builder: (context) {
                final now = DateTime.now();
                final arabicFormat = DateFormat('EEEE، d MMMM yyyy', 'ar');
                return Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.center,
                  child: Text(
                    _toArabicNumber(arabicFormat.format(now)),
                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                  ),
                );
              },
            ),
            // بطاقة القرآن الكريم - قابلة للنقر
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/quran'),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(50),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'assets/icons/quran_logo.png',
                        height: 100,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.menu_book,
                              size: 64,
                              color: Colors.orange,
                            ),
                      ),
                      Text(
                        l10n.quran,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                    ],
                  ),
                ),
              ),
            ),
            // شبكة الميزات
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount:
                    features.length -
                    1, // استثناء القرآن الكريم لأنه موجود بالفعل
                itemBuilder: (context, index) {
                  // تخطي القرآن الكريم
                  int actualIndex = index >= 0 ? index + 1 : index;
                  return FeatureCard(
                    feature: features[actualIndex],
                    animationDelay: index,
                  );
                },
              ),
            ),
            // آية قرآنية في الأسفل
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    'وَقُلْ رَبِّ أَنْزِلْنِي مُنْزَلًا مُبَارَكًا وَأَنْتَ خَيْرُ الْمُنْزِلِينَ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'المؤمنون - ٢٩',
                    style: TextStyle(fontSize: 14, color: Colors.teal),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لتحويل الأرقام الإنجليزية إلى عربية
  String _toArabicNumber(dynamic input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = input.toString();
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}
