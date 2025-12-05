import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/bookmark.dart';

/// خدمة مزامنة البيانات مع Firebase Firestore
class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// مرجع مستند المستخدم
  DocumentReference _userDoc(String userId) {
    return _firestore.collection('users').doc(userId);
  }

  // ============================================
  // مزامنة المفضلات
  // ============================================

  /// رفع المفضلات إلى السحابة
  Future<void> uploadBookmarks(String userId, List<Bookmark> bookmarks) async {
    try {
      final batch = _firestore.batch();

      for (final bookmark in bookmarks) {
        final docRef = _userDoc(
          userId,
        ).collection('bookmarks').doc(bookmark.id);

        batch.set(docRef, {
          'surahNumber': bookmark.surahNumber,
          'verseNumber': bookmark.verseNumber,
          'surahName': bookmark.surahName,
          'verseText': bookmark.verseText,
          'note': bookmark.note,
          'timestamp': Timestamp.fromDate(bookmark.timestamp),
        });
      }

      await batch.commit();
      debugPrint('تم رفع ${bookmarks.length} مفضلة');
    } catch (e) {
      debugPrint('خطأ في رفع المفضلات: $e');
      rethrow;
    }
  }

  /// تنزيل المفضلات من السحابة
  Future<List<Bookmark>> downloadBookmarks(String userId) async {
    try {
      final snapshot =
          await _userDoc(userId)
              .collection('bookmarks')
              .orderBy('timestamp', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Bookmark(
          id: doc.id,
          surahNumber: data['surahNumber'] as int,
          verseNumber: data['verseNumber'] as int,
          note: data['note'] as String?,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      debugPrint('خطأ في تنزيل المفضلات: $e');
      rethrow;
    }
  }

  /// حذف مفضلة من السحابة
  Future<void> deleteBookmark(String userId, String bookmarkId) async {
    try {
      await _userDoc(userId).collection('bookmarks').doc(bookmarkId).delete();
      debugPrint('تم حذف المفضلة: $bookmarkId');
    } catch (e) {
      debugPrint('خطأ في حذف المفضلة: $e');
      rethrow;
    }
  }

  // ============================================
  // مزامنة الإحصائيات
  // ============================================

  /// رفع الإحصائيات إلى السحابة
  Future<void> uploadStatistics(
    String userId,
    Map<String, dynamic> stats,
  ) async {
    try {
      await _userDoc(userId).collection('statistics').doc('main').set(stats);
      debugPrint('تم رفع الإحصائيات');
    } catch (e) {
      debugPrint('خطأ في رفع الإحصائيات: $e');
      rethrow;
    }
  }

  /// تنزيل الإحصائيات من السحابة
  Future<Map<String, dynamic>?> downloadStatistics(String userId) async {
    try {
      final doc =
          await _userDoc(userId).collection('statistics').doc('main').get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      debugPrint('خطأ في تنزيل الإحصائيات: $e');
      rethrow;
    }
  }

  // ============================================
  // مزامنة الإعدادات
  // ============================================

  /// رفع الإعدادات إلى السحابة
  Future<void> uploadSettings(
    String userId,
    Map<String, dynamic> settings,
  ) async {
    try {
      await _userDoc(userId).collection('settings').doc('main').set(settings);
      debugPrint('تم رفع الإعدادات');
    } catch (e) {
      debugPrint('خطأ في رفع الإعدادات: $e');
      rethrow;
    }
  }

  /// تنزيل الإعدادات من السحابة
  Future<Map<String, dynamic>?> downloadSettings(String userId) async {
    try {
      final doc =
          await _userDoc(userId).collection('settings').doc('main').get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      debugPrint('خطأ في تنزيل الإعدادات: $e');
      rethrow;
    }
  }

  // ============================================
  // معلومات المستخدم
  // ============================================

  /// تحديث آخر وقت مزامنة
  Future<void> updateLastSync(String userId) async {
    try {
      await _userDoc(userId).set({
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('خطأ في تحديث وقت المزامنة: $e');
    }
  }

  /// الحصول على معلومات ملف المستخدم
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _userDoc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('خطأ في الحصول على معلومات المستخدم: $e');
      return null;
    }
  }

  /// Stream للاستماع للتغييرات في المفضلات
  Stream<List<Bookmark>> watchBookmarks(String userId) {
    return _userDoc(userId)
        .collection('bookmarks')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Bookmark(
              id: doc.id,
              surahNumber: data['surahNumber'] as int,
              verseNumber: data['verseNumber'] as int,
              note: data['note'] as String?,
              timestamp: (data['timestamp'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }
}
