import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/radio_station.dart';

class RadioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isLoading = false;
  int _currentStationIndex = 0;
  String? _errorMessage;

  // قائمة المحطات الإذاعية
  final List<RadioStation> _stations = [
    const RadioStation(
      name: 'إذاعة القرآن الكريم - القاهرة',
      url:
          'https://n0e.radiojar.com/8s5u5tpdtwzuv?rj-ttl=5&rj-tok=AAABjF_2b4EA2g0g0g0g0g0g0g',
      image: 'assets/icons/quran.png',
    ),
    const RadioStation(
      name: 'إذاعة القرآن الكريم - السعودية',
      url: 'https://stream.radiojar.com/4wqre23fytzuv',
      image: 'assets/icons/quran.png',
    ),
    const RadioStation(
      name: 'إذاعة السنة النبوية',
      url: 'https://stream.radiojar.com/0tpy1h0kxtzuv',
      image: 'assets/icons/hadith.png',
    ),
    const RadioStation(
      name: 'إذاعة الشيخ عبد الباسط',
      url: 'https://backup.qurango.net/radio/abdulbasit_abdulsamad_mojawwad',
      image: 'assets/icons/quran.png',
    ),
    const RadioStation(
      name: 'إذاعة الشيخ مشاري العفاسي',
      url: 'https://backup.qurango.net/radio/mishary_alafasi',
      image: 'assets/icons/quran.png',
    ),
  ];

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  int get currentStationIndex => _currentStationIndex;
  String? get errorMessage => _errorMessage;
  List<RadioStation> get stations => _stations;
  RadioStation get currentStation => _stations[_currentStationIndex];

  RadioProvider() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      if (state == PlayerState.playing || state == PlayerState.paused) {
        _isLoading = false;
      }
      notifyListeners();
    });

    // Handle errors (if supported by the specific platform implementation or try-catch)
  }

  Future<void> play() async {
    await playStation(_currentStationIndex);
  }

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

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل الإيقاف: $e';
      notifyListeners();
    }
  }

  Future<void> nextStation() async {
    int nextIndex = _currentStationIndex + 1;
    if (nextIndex >= _stations.length) {
      nextIndex = 0;
    }
    await playStation(nextIndex);
  }

  Future<void> previousStation() async {
    int prevIndex = _currentStationIndex - 1;
    if (prevIndex < 0) {
      prevIndex = _stations.length - 1;
    }
    await playStation(prevIndex);
  }

  Future<void> playStation(int index) async {
    if (index < 0 || index >= _stations.length) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      _currentStationIndex = index;
      notifyListeners();

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(_stations[index].url));

      _isPlaying = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      _errorMessage = 'فشل تشغيل المحطة: تأكد من الاتصال بالإنترنت';
      notifyListeners();
      debugPrint('Error playing radio: $e');
    }
  }

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
