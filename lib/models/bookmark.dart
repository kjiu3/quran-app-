import 'package:quran/quran.dart' as quran;

class Bookmark {
  final String id;
  final int surahNumber;
  final int verseNumber;
  final String? note;
  final DateTime timestamp;

  const Bookmark({
    required this.id,
    required this.surahNumber,
    required this.verseNumber,
    this.note,
    required this.timestamp,
  });

  String get surahName => quran.getSurahName(surahNumber);
  String get verseText => quran.getVerse(surahNumber, verseNumber);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'verseNumber': verseNumber,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      surahNumber: json['surahNumber'] as int,
      verseNumber: json['verseNumber'] as int,
      note: json['note'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() {
    return 'Bookmark(id: $id, surah: $surahNumber, verse: $verseNumber)';
  }
}
