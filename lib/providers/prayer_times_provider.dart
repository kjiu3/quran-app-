import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart' as adhan;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/prayer_time.dart';
import '../services/notification_service.dart';

class PrayerTimesProvider extends ChangeNotifier {
  List<PrayerTime> _prayerTimes = [];
  Position? _currentPosition;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _updateTimer;

  final NotificationService _notificationService = NotificationService();

  List<PrayerTime> get prayerTimes => _prayerTimes;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPrayerTimes => _prayerTimes.isNotEmpty;

  PrayerTimesProvider() {
    initialize();
  }

  Future<void> initialize() async {
    await _notificationService.initialize();
    await loadSavedLocation();
    _startDailyUpdate();
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      _errorMessage = 'يرجى منح إذن الموقع لحساب أوقات الصلاة';
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Check permission
      final permission = await Permission.location.status;
      if (!permission.isGranted) {
        await requestLocationPermission();
        if (!await Permission.location.isGranted) {
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Get location
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await _saveLocation(_currentPosition!);
      await calculatePrayerTimes();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'فشل تحديد الموقع: $e';
      notifyListeners();
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> calculatePrayerTimes() async {
    if (_currentPosition == null) return;

    try {
      final coords = adhan.Coordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      final params = adhan.CalculationMethod.umm_al_qura.getParameters();
      params.madhab = adhan.Madhab.shafi;

      final prayers = adhan.PrayerTimes.today(coords, params);

      _prayerTimes = [
        PrayerTime(
          type: PrayerType.fajr,
          time: prayers.fajr,
          notificationEnabled: await _getNotificationEnabled('fajr'),
        ),
        PrayerTime(
          type: PrayerType.sunrise,
          time: prayers.sunrise,
          notificationEnabled: false,
        ),
        PrayerTime(
          type: PrayerType.dhuhr,
          time: prayers.dhuhr,
          notificationEnabled: await _getNotificationEnabled('dhuhr'),
        ),
        PrayerTime(
          type: PrayerType.asr,
          time: prayers.asr,
          notificationEnabled: await _getNotificationEnabled('asr'),
        ),
        PrayerTime(
          type: PrayerType.maghrib,
          time: prayers.maghrib,
          notificationEnabled: await _getNotificationEnabled('maghrib'),
        ),
        PrayerTime(
          type: PrayerType.isha,
          time: prayers.isha,
          notificationEnabled: await _getNotificationEnabled('isha'),
        ),
      ];

      await _scheduleNotifications();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل حساب أوقات الصلاة: $e';
      notifyListeners();
      debugPrint('Error calculating prayer times: $e');
    }
  }

  PrayerTime? getNextPrayer() {
    final now = DateTime.now();
    for (final prayer in _prayerTimes) {
      if (prayer.time.isAfter(now) && prayer.type != PrayerType.sunrise) {
        return prayer;
      }
    }
    return null;
  }

  PrayerTime? getCurrentPrayer() {
    final now = DateTime.now();
    PrayerTime? current;

    for (final prayer in _prayerTimes) {
      if (prayer.time.isBefore(now)) {
        current = prayer;
      } else {
        break;
      }
    }

    return current;
  }

  Duration? getTimeUntilNextPrayer() {
    final next = getNextPrayer();
    if (next == null) return null;
    return next.time.difference(DateTime.now());
  }

  Future<void> toggleNotification(PrayerType type) async {
    final index = _prayerTimes.indexWhere((p) => p.type == type);
    if (index == -1) return;

    _prayerTimes[index] = _prayerTimes[index].copyWith(
      notificationEnabled: !_prayerTimes[index].notificationEnabled,
    );

    await _saveNotificationEnabled(
      type.name,
      _prayerTimes[index].notificationEnabled,
    );

    await _scheduleNotifications();
    notifyListeners();
  }

  Future<void> _scheduleNotifications() async {
    final hasPermission = await _notificationService.requestPermissions();
    if (!hasPermission) {
      debugPrint('Notification permission not granted');
      return;
    }

    await _notificationService.scheduleAllPrayers(_prayerTimes);
  }

  Future<void> _saveLocation(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude', position.latitude);
      await prefs.setDouble('longitude', position.longitude);
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }

  Future<void> loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('latitude');
      final lon = prefs.getDouble('longitude');

      if (lat != null && lon != null) {
        _currentPosition = Position(
          latitude: lat,
          longitude: lon,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        await calculatePrayerTimes();
      }
    } catch (e) {
      debugPrint('Error loading saved location: $e');
    }
  }

  Future<bool> _getNotificationEnabled(String prayerName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('notification_$prayerName') ?? true;
    } catch (e) {
      return true;
    }
  }

  Future<void> _saveNotificationEnabled(String prayerName, bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notification_$prayerName', enabled);
    } catch (e) {
      debugPrint('Error saving notification setting: $e');
    }
  }

  void _startDailyUpdate() {
    // Update prayer times at midnight every day
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final duration = tomorrow.difference(now);

    _updateTimer = Timer(duration, () {
      calculatePrayerTimes();
      _startDailyUpdate(); // Schedule next update
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
