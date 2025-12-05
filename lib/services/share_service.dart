import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran/quran.dart' as quran;
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/verse_card_widget.dart';

/// خدمة مشاركة الآيات
class ShareService {
  static final ScreenshotController _screenshotController =
      ScreenshotController();

  /// مشاركة آية واحدة كنص
  static Future<void> shareVerse({
    required int surahNumber,
    required int verseNumber,
    String? customText,
  }) async {
    final surahName = quran.getSurahName(surahNumber);
    final verseText = customText ?? quran.getVerse(surahNumber, verseNumber);

    final shareText = '''
﴿ $verseText ﴾

📖 سورة $surahName - الآية $verseNumber

— من تطبيق القرآن الكريم
''';

    await Share.share(shareText, subject: 'آية من القرآن الكريم');
  }

  /// مشاركة آية كصورة
  static Future<void> shareVerseAsImage({
    required BuildContext context,
    required int surahNumber,
    required int verseNumber,
    String? verseText,
    Color? backgroundColor,
    Color? textColor,
    Color? accentColor,
  }) async {
    try {
      // إنشاء widget الآية
      final verseCard = VerseCardWidget(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        verseText: verseText,
        backgroundColor: backgroundColor ?? const Color(0xFF1a4d2e),
        textColor: textColor ?? Colors.white,
        accentColor: accentColor ?? const Color(0xFFffd700),
      );

      // التقاط صورة للWidget
      final Uint8List? imageBytes = await _screenshotController
          .captureFromWidget(
            Material(color: Colors.transparent, child: verseCard),
            pixelRatio: 3.0,
            targetSize: const Size(800, 600),
          );

      if (imageBytes == null) {
        throw Exception('فشل في إنشاء الصورة');
      }

      // حفظ الصورة مؤقتاً
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/verse_${surahNumber}_$verseNumber.png',
      );
      await file.writeAsBytes(imageBytes);

      // مشاركة الصورة
      final surahName = quran.getSurahName(surahNumber);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'سورة $surahName - الآية $verseNumber\n— من تطبيق القرآن الكريم',
      );

      // حذف الملف المؤقت بعد المشاركة
      await file.delete();
    } catch (e) {
      debugPrint('خطأ في مشاركة الآية كصورة: $e');
      // Fall back to text sharing
      await shareVerse(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        customText: verseText,
      );
    }
  }

  /// مشاركة آية مع التفسير كصورة
  static Future<void> shareVerseWithTafsirAsImage({
    required BuildContext context,
    required int surahNumber,
    required int verseNumber,
    required String tafsirText,
    String? verseText,
    Color? backgroundColor,
    Color? textColor,
    Color? accentColor,
  }) async {
    try {
      // إنشاء widget الآية مع التفسير
      final verseCard = VerseCardWidget(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        verseText: verseText,
        showTafsir: true,
        tafsirText: tafsirText,
        backgroundColor: backgroundColor ?? const Color(0xFF2c3e50),
        textColor: textColor ?? Colors.white,
        accentColor: accentColor ?? const Color(0xFFe67e22),
      );

      // التقاط صورة للWidget
      final Uint8List? imageBytes = await _screenshotController
          .captureFromWidget(
            Material(color: Colors.transparent, child: verseCard),
            pixelRatio: 3.0,
            targetSize: const Size(800, 800),
          );

      if (imageBytes == null) {
        throw Exception('فشل في إنشاء الصورة');
      }

      // حفظ الصورة مؤقتاً
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/verse_tafsir_${surahNumber}_$verseNumber.png',
      );
      await file.writeAsBytes(imageBytes);

      // مشاركة الصورة
      final surahName = quran.getSurahName(surahNumber);
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'سورة $surahName - الآية $verseNumber مع التفسير\n— من تطبيق القرآن الكريم',
      );

      // حذف الملف المؤقت
      await file.delete();
    } catch (e) {
      debugPrint('خطأ في مشاركة الآية مع التفسير كصورة: $e');
      // Fall back to text sharing
      await shareVerseWithTafsir(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        tafsirText: tafsirText,
      );
    }
  }

  /// مشاركة مجموعة آيات كنص
  static Future<void> shareVerses({
    required int surahNumber,
    required int startVerse,
    required int endVerse,
  }) async {
    final surahName = quran.getSurahName(surahNumber);
    final buffer = StringBuffer();

    for (int i = startVerse; i <= endVerse; i++) {
      final verse = quran.getVerse(surahNumber, i);
      buffer.writeln('﴿ $verse ﴾ ($i)');
      buffer.writeln();
    }

    final shareText = '''
${buffer.toString()}
📖 سورة $surahName - الآيات $startVerse إلى $endVerse

— من تطبيق القرآن الكريم
''';

    await Share.share(shareText, subject: 'آيات من القرآن الكريم');
  }

  /// مشاركة آية مع التفسير كنص
  static Future<void> shareVerseWithTafsir({
    required int surahNumber,
    required int verseNumber,
    required String tafsirText,
  }) async {
    final surahName = quran.getSurahName(surahNumber);
    final verseText = quran.getVerse(surahNumber, verseNumber);

    final shareText = '''
﴿ $verseText ﴾

📖 سورة $surahName - الآية $verseNumber

📝 التفسير:
$tafsirText

— من تطبيق القرآن الكريم
''';

    await Share.share(shareText, subject: 'آية وتفسيرها من القرآن الكريم');
  }

  /// مشاركة رابط السورة (للمستقبل مع deep links)
  static Future<void> shareSurah({required int surahNumber}) async {
    final surahName = quran.getSurahName(surahNumber);
    final surahNameArabic = quran.getSurahNameArabic(surahNumber);
    final verseCount = quran.getVerseCount(surahNumber);

    final shareText = '''
📖 سورة $surahNameArabic ($surahName)

عدد الآيات: $verseCount

— من تطبيق القرآن الكريم
''';

    await Share.share(shareText, subject: 'سورة من القرآن الكريم');
  }

  /// عرض خيارات المشاركة
  static Future<void> showShareOptions({
    required BuildContext context,
    required int surahNumber,
    required int verseNumber,
    String? verseText,
    String? tafsirText,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'خيارات المشاركة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.text_fields),
                  title: const Text('مشاركة كنص'),
                  onTap: () {
                    Navigator.pop(context);
                    shareVerse(
                      surahNumber: surahNumber,
                      verseNumber: verseNumber,
                      customText: verseText,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('مشاركة كصورة'),
                  subtitle: const Text('تصميم جميل للمشاركة'),
                  onTap: () {
                    Navigator.pop(context);
                    shareVerseAsImage(
                      context: context,
                      surahNumber: surahNumber,
                      verseNumber: verseNumber,
                      verseText: verseText,
                    );
                  },
                ),
                if (tafsirText != null) ...[
                  ListTile(
                    leading: const Icon(Icons.auto_stories),
                    title: const Text('مشاركة مع التفسير'),
                    subtitle: const Text('كنص'),
                    onTap: () {
                      Navigator.pop(context);
                      shareVerseWithTafsir(
                        surahNumber: surahNumber,
                        verseNumber: verseNumber,
                        tafsirText: tafsirText,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: const Text('مشاركة مع التفسير كصورة'),
                    subtitle: const Text('تصميم شامل'),
                    onTap: () {
                      Navigator.pop(context);
                      shareVerseWithTafsirAsImage(
                        context: context,
                        surahNumber: surahNumber,
                        verseNumber: verseNumber,
                        tafsirText: tafsirText,
                        verseText: verseText,
                      );
                    },
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
