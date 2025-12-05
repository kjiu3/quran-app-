import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';

/// Provider لإدارة حالة المصادقة والمزامنة
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SyncService _syncService = SyncService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  AuthProvider() {
    // الاستماع لتغييرات حالة المصادقة
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();

      // مزامنة تلقائية عند تسجيل الدخول
      if (user != null) {
        syncData();
      }
    });
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _user != null;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;

  String? get userId => _user?.uid;
  String? get userEmail => _user?.email;
  String? get userName => _user?.displayName;
  String? get userPhotoUrl => _user?.photoURL;

  /// تسجيل الدخول باستخدام Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) {
        // المستخدم ألغى
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = userCredential.user;
      _isLoading = false;
      notifyListeners();

      // مزامنة البيانات
      await syncData();

      return true;
    } catch (e) {
      _errorMessage = 'فشل تسجيل الدخول: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      debugPrint(_errorMessage);
      return false;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();

      _user = null;
      _lastSyncTime = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تسجيل الخروج: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      debugPrint(_errorMessage);
    }
  }

  /// مزامنة البيانات
  Future<void> syncData() async {
    if (_user == null || _isSyncing) return;

    try {
      _isSyncing = true;
      _errorMessage = null;
      notifyListeners();

      // هنا سيتم استدعاء مزامنة البيانات من الـ Providers الأخرى
      // (سيتم تنفيذه عند تحديث BookmarkProvider و StatisticsProvider)

      await _syncService.updateLastSync(_user!.uid);
      _lastSyncTime = DateTime.now();

      _isSyncing = false;
      notifyListeners();

      debugPrint('تمت المزامنة بنجاح');
    } catch (e) {
      _errorMessage = 'فشلت المزامنة: ${e.toString()}';
      _isSyncing = false;
      notifyListeners();
      debugPrint(_errorMessage);
    }
  }

  /// مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
