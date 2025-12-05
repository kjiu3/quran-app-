import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

/// مزود خدمة الصوت (AudioProvider)
///
/// يدير هذا الكلاس حالة تشغيل القرآن الكريم، بما في ذلك:
/// - تشغيل وإيقاف السور
/// - التحقق من الاتصال بالإنترنت
/// - إدارة حالة التحميل (Buffering)
/// - معالجة الأخطاء وعرض رسائل للمستخدم
class AudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer;
  final Connectivity _connectivity;

  /// هل يتم تشغيل صوت حالياً؟
  bool _isPlaying = false;

  /// رقم السورة الحالية (1-114)
  int? _currentSurahNumber;

  /// هل يتم تحميل الصوت حالياً؟
  bool _isBuffering = false;

  /// رسالة خطأ لعرضها للمستخدم (null إذا لم يوجد خطأ)
  String? _errorMessage;

  // Getters
  bool get isPlaying => _isPlaying;
  int? get currentSurahNumber => _currentSurahNumber;
  bool get isBuffering => _isBuffering;
  String? get errorMessage => _errorMessage;

  AudioProvider({AudioPlayer? audioPlayer, Connectivity? connectivity})
    : _audioPlayer = audioPlayer ?? AudioPlayer(),
      _connectivity = connectivity ?? Connectivity() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        _isPlaying = false;
        _currentSurahNumber = null;
        notifyListeners();
      }
    });

    // Listen to errors (if supported by the platform/plugin version in a specific way,
    // but try-catch is primary for play calls)
  }

  /// Checks for internet connectivity.
  /// Returns true if connected (mobile or wifi), false otherwise.
  Future<bool> _checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (_connectivity.checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }

  /// Plays the Surah with the given [surahNumber].
  /// Checks for connectivity first.
  Future<void> playSurah(int surahNumber) async {
    _errorMessage = null;
    notifyListeners();

    // 1. Check Connectivity
    bool hasInternet = await _checkConnectivity();
    if (!hasInternet) {
      _errorMessage = 'لا يوجد اتصال بالإنترنت';
      notifyListeners();
      return;
    }

    try {
      _isBuffering = true;
      notifyListeners();

      // Stop current if playing
      if (_isPlaying) {
        await _audioPlayer.stop();
      }

      // 2. Play Audio
      final url = quran.getAudioURLBySurah(surahNumber);
      await _audioPlayer.play(UrlSource(url));

      _isPlaying = true;
      _currentSurahNumber = surahNumber;
      _isBuffering = false;
      notifyListeners();
    } catch (e) {
      _isBuffering = false;
      _isPlaying = false;
      _errorMessage = 'حدث خطأ أثناء تشغيل الصوت: $e';
      notifyListeners();
    }
  }

  /// Plays the Surah from a custom URL (for specific reciters).
  Future<void> playSurahFromUrl(int surahNumber, String url) async {
    _errorMessage = null;
    notifyListeners();

    // 1. Check Connectivity
    bool hasInternet = await _checkConnectivity();
    if (!hasInternet) {
      _errorMessage = 'لا يوجد اتصال بالإنترنت';
      notifyListeners();
      return;
    }

    try {
      _isBuffering = true;
      notifyListeners();

      // Stop current if playing
      if (_isPlaying) {
        await _audioPlayer.stop();
      }

      // 2. Play Audio from custom URL
      await _audioPlayer.play(UrlSource(url));

      _isPlaying = true;
      _currentSurahNumber = surahNumber;
      _isBuffering = false;
      notifyListeners();
    } catch (e) {
      _isBuffering = false;
      _isPlaying = false;
      _errorMessage = 'حدث خطأ أثناء تشغيل الصوت: $e';
      notifyListeners();
    }
  }

  /// Pauses the current audio.
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل الإيقاف المؤقت: $e';
      notifyListeners();
    }
  }

  /// Stops the audio completely.
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentSurahNumber = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل الإيقاف: $e';
      notifyListeners();
    }
  }

  /// Resumes the audio if paused.
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل الاستئناف: $e';
      notifyListeners();
    }
  }

  /// Clears any error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
