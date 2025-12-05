import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../providers/audio_provider.dart';
import '../models/reciter.dart';
import '../widgets/error_handler_widget.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Reciter? _selectedReciter;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedReciter = Reciter.famousReciters.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'الصوتيات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'القراء', icon: Icon(Icons.person)),
            Tab(text: 'السور', icon: Icon(Icons.menu_book)),
          ],
        ),
      ),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, child) {
          return Column(
            children: [
              // عرض الخطأ إذا وجد
              if (audioProvider.errorMessage != null)
                ErrorHandlerWidget(
                  errorMessage: audioProvider.errorMessage,
                  onDismiss: () => audioProvider.clearError(),
                  onRetry: () {
                    audioProvider.clearError();
                  },
                ),

              // مشغل الصوت المصغر
              if (audioProvider.isPlaying || audioProvider.isBuffering)
                _buildMiniPlayer(audioProvider),

              // محتوى التبويبات
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRecitersTab(audioProvider),
                    _buildSurahsTab(audioProvider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// بناء مشغل الصوت المصغر
  Widget _buildMiniPlayer(AudioProvider audioProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة التحميل أو التشغيل
          if (audioProvider.isBuffering)
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 24,
              ),
            ),
          const SizedBox(width: 12),

          // معلومات السورة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audioProvider.currentSurahNumber != null &&
                          audioProvider.currentSurahNumber! > 0
                      ? quran.getSurahName(audioProvider.currentSurahNumber!)
                      : 'جاري التحميل...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (_selectedReciter != null)
                  Text(
                    _selectedReciter!.name,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          // أزرار التحكم
          IconButton(
            icon: Icon(
              audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              if (audioProvider.isPlaying) {
                audioProvider.pause();
              } else {
                audioProvider.resume();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.white, size: 28),
            onPressed: () => audioProvider.stop(),
          ),
        ],
      ),
    );
  }

  /// بناء تبويب القراء
  Widget _buildRecitersTab(AudioProvider audioProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: Reciter.famousReciters.length,
      itemBuilder: (context, index) {
        final reciter = Reciter.famousReciters[index];
        final isSelected = _selectedReciter?.id == reciter.id;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Card(
            elevation: isSelected ? 4 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side:
                  isSelected
                      ? const BorderSide(color: Colors.orange, width: 2)
                      : BorderSide.none,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor:
                    isSelected ? Colors.orange : Colors.orange.shade100,
                radius: 28,
                child: Icon(
                  Icons.person,
                  color: isSelected ? Colors.white : Colors.orange,
                  size: 28,
                ),
              ),
              title: Text(
                reciter.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.orange : Colors.black87,
                ),
              ),
              subtitle: Text(
                reciter.style,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing:
                  isSelected
                      ? const Icon(Icons.check_circle, color: Colors.orange)
                      : null,
              onTap: () {
                setState(() {
                  _selectedReciter = reciter;
                });
                // الانتقال لتبويب السور
                _tabController.animateTo(1);
              },
            ),
          ),
        );
      },
    );
  }

  /// بناء تبويب السور
  Widget _buildSurahsTab(AudioProvider audioProvider) {
    // تصفية السور حسب البحث
    final filteredSurahs =
        List.generate(114, (i) => i + 1).where((surahNum) {
          if (_searchQuery.isEmpty) return true;
          final surahName = quran.getSurahName(surahNum);
          return surahName.contains(_searchQuery);
        }).toList();

    return Column(
      children: [
        // شريط البحث
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن سورة...',
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            textAlign: TextAlign.right,
          ),
        ),

        // معلومات القارئ المختار
        if (_selectedReciter != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'القارئ: ${_selectedReciter!.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

        // قائمة السور
        Expanded(
          child: ListView.builder(
            itemCount: filteredSurahs.length,
            itemBuilder: (context, index) {
              final surahNumber = filteredSurahs[index];
              final isCurrentSurah =
                  audioProvider.currentSurahNumber == surahNumber;
              final isPlaying = audioProvider.isPlaying && isCurrentSurah;
              final isBuffering = audioProvider.isBuffering && isCurrentSurah;

              return ListTile(
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color:
                        isPlaying || isBuffering
                            ? Colors.orange
                            : Colors.orange.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$surahNumber',
                      style: TextStyle(
                        color:
                            isPlaying || isBuffering
                                ? Colors.white
                                : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  quran.getSurahName(surahNumber),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPlaying ? Colors.orange : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  '${quran.getVerseCount(surahNumber)} آية',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing:
                    isBuffering
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.orange,
                          ),
                        )
                        : IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.orange,
                            size: 36,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              audioProvider.pause();
                            } else {
                              _playSurah(audioProvider, surahNumber);
                            }
                          },
                        ),
                onTap: () {
                  if (isPlaying) {
                    audioProvider.pause();
                  } else {
                    _playSurah(audioProvider, surahNumber);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// تشغيل سورة معينة
  void _playSurah(AudioProvider audioProvider, int surahNumber) {
    if (_selectedReciter != null) {
      // استخدام رابط القارئ المختار
      final url = _selectedReciter!.getSurahAudioUrl(surahNumber);
      audioProvider.playSurahFromUrl(surahNumber, url);
    } else {
      // استخدام الرابط الافتراضي
      audioProvider.playSurah(surahNumber);
    }
  }
}
