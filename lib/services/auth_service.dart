import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// خدمة المصادقة باستخدام Firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  /// Stream لحالة المستخدم
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// تسجيل الدخول باستخدام Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // بدء عملية تسجيل الدخول
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // المستخدم ألغى تسجيل الدخول
        return null;
      }

      // الحصول على بيانات المصادقة
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // إنشاء OAuth credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول إلى Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      debugPrint('تم تسجيل الدخول: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      debugPrint('خطأ في تسجيل الدخول بـ Google: $e');
      rethrow;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      debugPrint('تم تسجيل الخروج');
    } catch (e) {
      debugPrint('خطأ في تسجيل الخروج: $e');
      rethrow;
    }
  }

  /// حذف الحساب
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
      await _googleSignIn.signOut();
      debugPrint('تم حذف الحساب');
    } catch (e) {
      debugPrint('خطأ في حذف الحساب: $e');
      rethrow;
    }
  }

  /// التحقق من تسجيل الدخول
  bool get isSignedIn => currentUser != null;

  /// معرف المستخدم
  String? get userId => currentUser?.uid;

  /// بريد المستخدم
  String? get userEmail => currentUser?.email;

  /// اسم المستخدم
  String? get userName => currentUser?.displayName;

  /// صورة المستخدم
  String? get userPhotoUrl => currentUser?.photoURL;
}
