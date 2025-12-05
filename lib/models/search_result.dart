class SearchResult {
  final int surahNumber;
  final int verseNumber;
  final String text;
  final String surahName;

  const SearchResult({
    required this.surahNumber,
    required this.verseNumber,
    required this.text,
    required this.surahName,
  });

  @override
  String toString() {
    return 'SearchResult(surah: $surahNumber, verse: $verseNumber, surahName: $surahName)';
  }
}
