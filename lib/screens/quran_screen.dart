import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../providers/audio_provider.dart';
import '../widgets/error_handler_widget.dart';
import '../widgets/smart_image.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'القرآن الكريم',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_stories, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/mushaf'),
            tooltip: 'المصحف',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/bookmarks'),
            tooltip: 'المفضلات',
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/search'),
            tooltip: 'البحث في القرآن',
          ),
        ],
      ),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, child) {
          // Show error using ErrorHandlerWidget
          if (audioProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ErrorHandlerWidget.showErrorSnackBar(
                context,
                audioProvider.errorMessage!,
                onRetry: () {
                  audioProvider.clearError();
                },
              );
              audioProvider.clearError();
            });
          }

          return Column(
            children: [
              // عرض رسالة الخطأ إذا وجدت
              if (audioProvider.errorMessage != null)
                ErrorHandlerWidget(
                  errorMessage: audioProvider.errorMessage,
                  onDismiss: () => audioProvider.clearError(),
                ),
              // بطاقة آخر قراءة
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(77),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SmartImage(
                      imagePath: 'assets/icons/quran.png',
                      width: 50,
                      height: 50,
                      fallbackIcon: Icons.menu_book,
                      iconColor: Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'آخر قراءة',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'سورة البقرة - الآية 255',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.play_circle_filled,
                        color: Colors.orange,
                        size: 40,
                      ),
                      onPressed: () {
                        // Navigate to tafsir for Ayat Al-Kursi
                        Navigator.pushNamed(
                          context,
                          '/tafsir',
                          arguments: {'surahNumber': 2, 'verseNumber': 255},
                        );
                      },
                    ),
                  ],
                ),
              ),
              // قائمة السور
              Expanded(
                child: ListView.builder(
                  itemCount: 114,
                  itemBuilder: (context, index) {
                    final surahNumber = index + 1;
                    final isCurrentSurah =
                        audioProvider.currentSurahNumber == surahNumber;
                    final isPlaying = audioProvider.isPlaying && isCurrentSurah;
                    final isBuffering =
                        audioProvider.isBuffering && isCurrentSurah;

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              isPlaying || isBuffering
                                  ? Colors.orange
                                  : Colors.orange.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$surahNumber',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        quran.getSurahName(surahNumber),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${quran.getVerseCount(surahNumber)} آية',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // زر التفسير
                          IconButton(
                            icon: const Icon(
                              Icons.menu_book,
                              color: Colors.teal,
                            ),
                            tooltip: 'التفسير',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/tafsir',
                                arguments: {
                                  'surahNumber': surahNumber,
                                  'verseNumber': 1,
                                },
                              );
                            },
                          ),
                          // زر التشغيل
                          isBuffering
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : IconButton(
                                icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  if (isPlaying) {
                                    audioProvider.pause();
                                  } else {
                                    audioProvider.playSurah(surahNumber);
                                  }
                                },
                              ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to tafsir on tap
                        Navigator.pushNamed(
                          context,
                          '/tafsir',
                          arguments: {
                            'surahNumber': surahNumber,
                            'verseNumber': 1,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
