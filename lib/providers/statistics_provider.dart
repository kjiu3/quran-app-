import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// نموذج بيانات إحصائيات القراءة
class ReadingStats {
  final int totalVersesRead;
  final int totalSurahsCompleted;
  final int totalMinutesSpent;
  final Map<String, int> dailyReading; // {date: verses}
  final Map<int, bool> surahsCompleted; // {surahNumber: completed}
  final DateTime lastReadDate;
  final int currentStreak; // أيام متتالية
  final int longestStreak;

  ReadingStats({
    this.totalVersesRead = 0,
    this.totalSurahsCompleted = 0,
    this.totalMinutesSpent = 0,
    Map<String, int>? dailyReading,
    Map<int, bool>? surahsCompleted,
    DateTime? lastReadDate,
    this.currentStreak = 0,
    this.longestStreak = 0,
  }) : dailyReading = dailyReading ?? {},
       surahsCompleted = surahsCompleted ?? {},
       lastReadDate = lastReadDate ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'totalVersesRead': totalVersesRead,
    'totalSurahsCompleted': totalSurahsCompleted,
    'totalMinutesSpent': totalMinutesSpent,
    'dailyReading': dailyReading,
    'surahsCompleted': surahsCompleted.map((k, v) => MapEntry(k.toString(), v)),
    'lastReadDate': lastReadDate.toIso8601String(),
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
  };

  factory ReadingStats.fromJson(Map<String, dynamic> json) {
    return ReadingStats(
      totalVersesRead: json['totalVersesRead'] ?? 0,
      totalSurahsCompleted: json['totalSurahsCompleted'] ?? 0,
      totalMinutesSpent: json['totalMinutesSpent'] ?? 0,
      dailyReading: Map<String, int>.from(json['dailyReading'] ?? {}),
      surahsCompleted:
          (json['surahsCompleted'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), v as bool),
          ) ??
          {},
      lastReadDate:
          json['lastReadDate'] != null
              ? DateTime.parse(json['lastReadDate'])
              : DateTime.now(),
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
    );
  }

  ReadingStats copyWith({
    int? totalVersesRead,
    int? totalSurahsCompleted,
    int? totalMinutesSpent,
    Map<String, int>? dailyReading,
    Map<int, bool>? surahsCompleted,
    DateTime? lastReadDate,
    int? currentStreak,
    int? longestStreak,
  }) {
    return ReadingStats(
      totalVersesRead: totalVersesRead ?? this.totalVersesRead,
      totalSurahsCompleted: totalSurahsCompleted ?? this.totalSurahsCompleted,
      totalMinutesSpent: totalMinutesSpent ?? this.totalMinutesSpent,
      dailyReading: dailyReading ?? Map.from(this.dailyReading),
      surahsCompleted: surahsCompleted ?? Map.from(this.surahsCompleted),
      lastReadDate: lastReadDate ?? this.lastReadDate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }
}

/// مزود إحصائيات القراءة
class StatisticsProvider extends ChangeNotifier {
  ReadingStats _stats = ReadingStats();
  bool _isLoading = false;
  DateTime? _sessionStartTime;

  ReadingStats get stats => _stats;
  bool get isLoading => _isLoading;

  StatisticsProvider() {
    _loadStats();
  }

  String get _todayKey => DateTime.now().toIso8601String().split('T')[0];

  Future<void> _loadStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString('reading_stats');
      if (statsJson != null) {
        _stats = ReadingStats.fromJson(jsonDecode(statsJson));
      }
    } catch (e) {
      debugPrint('Error loading stats: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reading_stats', jsonEncode(_stats.toJson()));
    } catch (e) {
      debugPrint('Error saving stats: $e');
    }
  }

  /// بدء جلسة قراءة
  void startReadingSession() {
    _sessionStartTime = DateTime.now();
  }

  /// إنهاء جلسة قراءة
  void endReadingSession() {
    if (_sessionStartTime != null) {
      final duration = DateTime.now().difference(_sessionStartTime!);
      final minutes = duration.inMinutes;

      _stats = _stats.copyWith(
        totalMinutesSpent: _stats.totalMinutesSpent + minutes,
      );
      _sessionStartTime = null;
      _saveStats();
      notifyListeners();
    }
  }

  /// تسجيل قراءة آية
  Future<void> recordVerseRead(int surahNumber, int verseNumber) async {
    final newDailyReading = Map<String, int>.from(_stats.dailyReading);
    newDailyReading[_todayKey] = (newDailyReading[_todayKey] ?? 0) + 1;

    // تحديث الـ streak
    int newStreak = _stats.currentStreak;
    int newLongestStreak = _stats.longestStreak;

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayKey = yesterday.toIso8601String().split('T')[0];

    if (_stats.lastReadDate.toIso8601String().split('T')[0] == yesterdayKey) {
      newStreak = _stats.currentStreak + 1;
    } else if (_stats.lastReadDate.toIso8601String().split('T')[0] !=
        _todayKey) {
      newStreak = 1;
    }

    if (newStreak > newLongestStreak) {
      newLongestStreak = newStreak;
    }

    _stats = _stats.copyWith(
      totalVersesRead: _stats.totalVersesRead + 1,
      dailyReading: newDailyReading,
      lastReadDate: DateTime.now(),
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
    );

    await _saveStats();
    notifyListeners();
  }

  /// تسجيل إتمام سورة
  Future<void> recordSurahCompleted(int surahNumber) async {
    if (_stats.surahsCompleted[surahNumber] == true) return;

    final newSurahsCompleted = Map<int, bool>.from(_stats.surahsCompleted);
    newSurahsCompleted[surahNumber] = true;

    _stats = _stats.copyWith(
      totalSurahsCompleted: _stats.totalSurahsCompleted + 1,
      surahsCompleted: newSurahsCompleted,
    );

    await _saveStats();
    notifyListeners();
  }

  /// الحصول على قراءات آخر 7 أيام
  Map<String, int> getLast7DaysReading() {
    final result = <String, int>{};
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = date.toIso8601String().split('T')[0];
      result[key] = _stats.dailyReading[key] ?? 0;
    }

    return result;
  }

  /// نسبة إتمام القرآن (114 سورة)
  double get completionPercentage {
    return (_stats.totalSurahsCompleted / 114) * 100;
  }

  /// إعادة تعيين الإحصائيات
  Future<void> resetStats() async {
    _stats = ReadingStats();
    await _saveStats();
    notifyListeners();
  }
}
