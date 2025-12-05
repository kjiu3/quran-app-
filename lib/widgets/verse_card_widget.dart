import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

/// Widget لعرض الآية بتصميم جميل قابل للمشاركة كصورة
class VerseCardWidget extends StatelessWidget {
  final int surahNumber;
  final int verseNumber;
  final String? verseText;
  final bool showTafsir;
  final String? tafsirText;
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;

  const VerseCardWidget({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
    this.verseText,
    this.showTafsir = false,
    this.tafsirText,
    this.backgroundColor = const Color(0xFF1a4d2e),
    this.textColor = Colors.white,
    this.accentColor = const Color(0xFFffd700),
  });

  @override
  Widget build(BuildContext context) {
    final verse = verseText ?? quran.getVerse(surahNumber, verseNumber);
    final surahNameArabic = quran.getSurahNameArabic(surahNumber);

    return Container(
      width: 800,
      constraints: const BoxConstraints(minHeight: 400),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [backgroundColor, backgroundColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // زخرفة إسلامية كخلفية
          Positioned(
            top: -50,
            right: -50,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.mosque, size: 300, color: textColor),
            ),
          ),

          // المحتوى الرئيسي
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // بسم الله الرحمن الرحيم
                Center(
                  child: Text(
                    'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 24,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),

                const SizedBox(height: 30),

                // الآية
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '﴿ $verse ﴾',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 32,
                          color: textColor,
                          height: 2.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),

                      const SizedBox(height: 16),

                      // معلومات الآية
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'سورة $surahNameArabic - آية $verseNumber',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),

                // التفسير (إن وجد)
                if (showTafsir && tafsirText != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📝 التفسير',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tafsirText!,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: textColor.withValues(alpha: 0.9),
                            height: 1.8,
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تطبيق القرآن الكريم',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    Icon(
                      Icons.book,
                      color: accentColor.withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
