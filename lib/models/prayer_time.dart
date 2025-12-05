enum PrayerType { fajr, sunrise, dhuhr, asr, maghrib, isha }

class PrayerTime {
  final PrayerType type;
  final DateTime time;
  final bool notificationEnabled;

  const PrayerTime({
    required this.type,
    required this.time,
    this.notificationEnabled = true,
  });

  String get name {
    switch (type) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.sunrise:
        return 'الشروق';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'time': time.toIso8601String(),
      'notificationEnabled': notificationEnabled,
    };
  }

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      type: PrayerType.values[json['type'] as int],
      time: DateTime.parse(json['time'] as String),
      notificationEnabled: json['notificationEnabled'] as bool? ?? true,
    );
  }

  PrayerTime copyWith({
    PrayerType? type,
    DateTime? time,
    bool? notificationEnabled,
  }) {
    return PrayerTime(
      type: type ?? this.type,
      time: time ?? this.time,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}
