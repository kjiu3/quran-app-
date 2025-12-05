import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../providers/tafsir_provider.dart';
import '../services/share_service.dart';

class TafsirScreen extends StatefulWidget {
  final int surahNumber;
  final int verseNumber;

  const TafsirScreen({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
  });

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {
  @override
  void initState() {
    super.initState();
    // جلب التفسير عند بدء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TafsirProvider>().getTafsir(
        widget.surahNumber,
        widget.verseNumber,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(
          'تفسير ${quran.getSurahName(widget.surahNumber)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // زر المشاركة
          Consumer<TafsirProvider>(
            builder: (context, provider, child) {
              final tafsir = provider.currentTafsir;
              return IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                tooltip: 'مشاركة',
                onPressed:
                    tafsir == null
                        ? null
                        : () {
                          ShareService.showShareOptions(
                            context: context,
                            surahNumber: tafsir.surahNumber,
                            verseNumber: tafsir.verseNumber,
                            verseText: tafsir.verseText,
                            tafsirText: tafsir.tafsirText,
                          );
                        },
              );
            },
          ),
          // اختيار مصدر التفسير
          Consumer<TafsirProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.library_books, color: Colors.white),
                tooltip: 'مصدر التفسير',
                onSelected: (source) {
                  provider.setTafsirSource(source);
                  provider.getTafsir(
                    provider.currentTafsir?.surahNumber ?? widget.surahNumber,
                    provider.currentTafsir?.verseNumber ?? widget.verseNumber,
                  );
                },
                itemBuilder: (context) {
                  return provider.availableTafsirSources.map((source) {
                    return PopupMenuItem<String>(
                      value: source,
                      child: Row(
                        children: [
                          Icon(
                            source == provider.selectedTafsirSource
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: Colors.teal,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(source),
                        ],
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<TafsirProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text(
                    'جاري تحميل التفسير...',
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ],
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.clearError();
                      provider.getTafsir(
                        widget.surahNumber,
                        widget.verseNumber,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final tafsir = provider.currentTafsir;
          if (tafsir == null) {
            return const Center(child: Text('لا يوجد تفسير متاح'));
          }

          return Column(
            children: [
              // معلومات الآية
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.teal.withAlpha(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${quran.getSurahName(tafsir.surahNumber)} - الآية ${tafsir.verseNumber}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),

              // محتوى التفسير
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // بطاقة نص الآية
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal.shade50,
                                Colors.teal.shade100,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.format_quote, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Text(
                                    'نص الآية',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tafsir.verseText,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Amiri',
                                  height: 2,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // بطاقة التفسير
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.menu_book,
                                    color: Colors.brown,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'التفسير (${tafsir.tafsirSource})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Text(
                                tafsir.tafsirText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.8,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.justify,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // أزرار التنقل
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(50),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // الآية السابقة
                    ElevatedButton.icon(
                      onPressed: () => provider.previousVerse(),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('السابقة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),

                    // رقم الآية الحالية
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${tafsir.verseNumber}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),

                    // الآية التالية
                    ElevatedButton.icon(
                      onPressed: () => provider.nextVerse(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('التالية'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
