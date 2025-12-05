/// نموذج بيانات القارئ
class Reciter {
  final String id;
  final String name;
  final String style;
  final String imageUrl;
  final String audioBaseUrl;

  const Reciter({
    required this.id,
    required this.name,
    required this.style,
    this.imageUrl = '',
    required this.audioBaseUrl,
  });

  /// قائمة القراء المشهورين
  static const List<Reciter> famousReciters = [
    Reciter(
      id: 'abdul_basit',
      name: 'عبد الباسط عبد الصمد',
      style: 'مجود',
      audioBaseUrl: 'https://server8.mp3quran.net/basit/',
    ),
    Reciter(
      id: 'mishary',
      name: 'مشاري العفاسي',
      style: 'حفص عن عاصم',
      audioBaseUrl: 'https://server8.mp3quran.net/afs/',
    ),
    Reciter(
      id: 'sudais',
      name: 'عبد الرحمن السديس',
      style: 'حفص عن عاصم',
      audioBaseUrl: 'https://server11.mp3quran.net/sds/',
    ),
    Reciter(
      id: 'shuraim',
      name: 'سعود الشريم',
      style: 'حفص عن عاصم',
      audioBaseUrl: 'https://server7.mp3quran.net/shur/',
    ),
    Reciter(
      id: 'maher',
      name: 'ماهر المعيقلي',
      style: 'حفص عن عاصم',
      audioBaseUrl: 'https://server12.mp3quran.net/maher/',
    ),
    Reciter(
      id: 'husary',
      name: 'محمود خليل الحصري',
      style: 'مجود',
      audioBaseUrl: 'https://server13.mp3quran.net/husr/',
    ),
    Reciter(
      id: 'minshawi',
      name: 'محمد صديق المنشاوي',
      style: 'مرتل',
      audioBaseUrl: 'https://server10.mp3quran.net/minsh/',
    ),
    Reciter(
      id: 'ahmed_ajamy',
      name: 'أحمد العجمي',
      style: 'حفص عن عاصم',
      audioBaseUrl: 'https://server10.mp3quran.net/ajm/',
    ),
  ];

  /// الحصول على رابط صوت سورة معينة
  String getSurahAudioUrl(int surahNumber) {
    // تنسيق رقم السورة ليكون 3 أرقام (001, 002, ... 114)
    final formattedNumber = surahNumber.toString().padLeft(3, '0');
    return '$audioBaseUrl$formattedNumber.mp3';
  }
}
