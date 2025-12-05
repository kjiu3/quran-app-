import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];
  bool _isLoading = false;

  List<Bookmark> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  bool get hasBookmarks => _bookmarks.isNotEmpty;

  BookmarkProvider() {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = prefs.getString('bookmarks');

      if (bookmarksJson != null) {
        final List<dynamic> decoded = jsonDecode(bookmarksJson);
        _bookmarks = decoded.map((json) => Bookmark.fromJson(json)).toList();

        // Sort by timestamp (newest first)
        _bookmarks.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Error loading bookmarks: $e');
      notifyListeners();
    }
  }

  Future<void> addBookmark({
    required int surahNumber,
    required int verseNumber,
    String? note,
  }) async {
    try {
      // Check if bookmark already exists
      final exists = _bookmarks.any(
        (b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber,
      );

      if (exists) {
        debugPrint('Bookmark already exists');
        return;
      }

      final bookmark = Bookmark(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        note: note,
        timestamp: DateTime.now(),
      );

      _bookmarks.insert(0, bookmark); // Add to beginning
      await _saveBookmarks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding bookmark: $e');
    }
  }

  Future<void> removeBookmark(String id) async {
    try {
      _bookmarks.removeWhere((b) => b.id == id);
      await _saveBookmarks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing bookmark: $e');
    }
  }

  Future<void> updateBookmarkNote(String id, String? note) async {
    try {
      final index = _bookmarks.indexWhere((b) => b.id == id);
      if (index != -1) {
        final bookmark = _bookmarks[index];
        _bookmarks[index] = Bookmark(
          id: bookmark.id,
          surahNumber: bookmark.surahNumber,
          verseNumber: bookmark.verseNumber,
          note: note,
          timestamp: bookmark.timestamp,
        );
        await _saveBookmarks();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating bookmark note: $e');
    }
  }

  bool isBookmarked(int surahNumber, int verseNumber) {
    return _bookmarks.any(
      (b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber,
    );
  }

  List<Bookmark> searchBookmarks(String query) {
    if (query.trim().isEmpty) return _bookmarks;

    final lowerQuery = query.toLowerCase();
    return _bookmarks.where((bookmark) {
      return bookmark.surahName.toLowerCase().contains(lowerQuery) ||
          bookmark.verseText.toLowerCase().contains(lowerQuery) ||
          (bookmark.note?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  void sortByDate() {
    _bookmarks.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  void sortBySurah() {
    _bookmarks.sort((a, b) {
      final surahCompare = a.surahNumber.compareTo(b.surahNumber);
      if (surahCompare != 0) return surahCompare;
      return a.verseNumber.compareTo(b.verseNumber);
    });
    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = jsonEncode(
        _bookmarks.map((b) => b.toJson()).toList(),
      );
      await prefs.setString('bookmarks', bookmarksJson);
    } catch (e) {
      debugPrint('Error saving bookmarks: $e');
    }
  }

  Future<void> clearAllBookmarks() async {
    try {
      _bookmarks.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('bookmarks');
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing bookmarks: $e');
    }
  }
}
