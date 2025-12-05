import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/search_result.dart';

/// نوع نطاق البحث
enum SearchScope {
  all, // كل القرآن
  meccan, // السور المكية
  medinan, // السور المدنية
}

/// فلتر البحث
class SearchFilter {
  final SearchScope scope;
  final int? juzNumber;
  final bool diacriticInsensitive;

  const SearchFilter({
    this.scope = SearchScope.all,
    this.juzNumber,
    this.diacriticInsensitive = true,
  });

  SearchFilter copyWith({
    SearchScope? scope,
    int? juzNumber,
    bool? diacriticInsensitive,
  }) {
    return SearchFilter(
      scope: scope ?? this.scope,
      juzNumber: juzNumber ?? this.juzNumber,
      diacriticInsensitive: diacriticInsensitive ?? this.diacriticInsensitive,
    );
  }
}

class SearchProvider extends ChangeNotifier {
  List<SearchResult> _results = [];
  bool _isSearching = false;
  String _query = '';
  List<String> _recentSearches = [];
  SearchFilter _filter = const SearchFilter();

  List<SearchResult> get results => _results;
  bool get isSearching => _isSearching;
  String get query => _query;
  List<String> get recentSearches => _recentSearches;
  bool get hasResults => _results.isNotEmpty;
  SearchFilter get filter => _filter;

  SearchProvider() {
    _loadRecentSearches();
  }

  /// إزالة التشكيل من النص العربي
  String removeDiacritics(String text) {
    // Arabic diacritics (Tashkeel) Unicode range
    const diacritics = [
      '\u064B', // Fathatan
      '\u064C', // Dammatan
      '\u064D', // Kasratan
      '\u064E', // Fatha
      '\u064F', // Damma
      '\u0650', // Kasra
      '\u0651', // Shadda
      '\u0652', // Sukun
      '\u0653', // Maddah
      '\u0654', // Hamza Above
      '\u0655', // Hamza Below
      '\u0656', // Subscript Alef
      '\u0670', // Superscript Alef
    ];

    String result = text;
    for (final diacritic in diacritics) {
      result = result.replaceAll(diacritic, '');
    }
    return result;
  }

  /// تحديث الفلتر
  void updateFilter(SearchFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
    // إعادة البحث إذا كان هناك نص بحث
    if (_query.isNotEmpty) {
      searchInQuran(_query);
    }
  }

  /// التحقق من نوع السورة (مكية/مدنية)
  bool _isMeccanSurah(int surahNumber) {
    // السور المدنية
    const medinanSurahs = [
      2,
      3,
      4,
      5,
      8,
      9,
      22,
      24,
      33,
      47,
      48,
      49,
      55,
      57,
      58,
      59,
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      76,
      98,
      110,
    ];
    return !medinanSurahs.contains(surahNumber);
  }

  /// التحقق من الجزء
  bool _isInJuz(int surahNumber, int verseNumber, int juzNumber) {
    final actualJuz = quran.getJuzNumber(surahNumber, verseNumber);
    return actualJuz == juzNumber;
  }

  Future<void> searchInQuran(String query) async {
    if (query.trim().isEmpty) {
      _results = [];
      _query = '';
      notifyListeners();
      return;
    }

    _isSearching = true;
    _query = query;
    notifyListeners();

    // Simulate async search for better UX
    await Future.delayed(const Duration(milliseconds: 100));

    _results = [];
    final searchTerm = query.trim();
    final normalizedQuery =
        _filter.diacriticInsensitive
            ? removeDiacritics(searchTerm)
            : searchTerm;

    for (int i = 1; i <= 114; i++) {
      // تطبيق فلتر نوع السورة
      if (_filter.scope == SearchScope.meccan && !_isMeccanSurah(i)) continue;
      if (_filter.scope == SearchScope.medinan && _isMeccanSurah(i)) continue;

      final verseCount = quran.getVerseCount(i);
      for (int j = 1; j <= verseCount; j++) {
        // تطبيق فلتر الجزء
        if (_filter.juzNumber != null && !_isInJuz(i, j, _filter.juzNumber!)) {
          continue;
        }

        final verse = quran.getVerse(i, j);
        final normalizedVerse =
            _filter.diacriticInsensitive ? removeDiacritics(verse) : verse;

        if (normalizedVerse.contains(normalizedQuery)) {
          _results.add(
            SearchResult(
              surahNumber: i,
              verseNumber: j,
              text: verse,
              surahName: quran.getSurahName(i),
            ),
          );
        }
      }
    }

    _isSearching = false;
    notifyListeners();

    // Save to recent searches
    await _saveToRecentSearches(query);
  }

  void clearResults() {
    _results = [];
    _query = '';
    notifyListeners();
  }

  void resetFilter() {
    _filter = const SearchFilter();
    notifyListeners();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList('recent_searches') ?? [];
      _recentSearches = searches;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _saveToRecentSearches(String query) async {
    try {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) return;

      // Remove if already exists
      _recentSearches.remove(trimmedQuery);

      // Add to beginning
      _recentSearches.insert(0, trimmedQuery);

      // Keep only last 10 searches
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.sublist(0, 10);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', _recentSearches);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving recent searches: $e');
    }
  }

  Future<void> clearRecentSearches() async {
    try {
      _recentSearches = [];
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recent_searches');
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing recent searches: $e');
    }
  }
}
