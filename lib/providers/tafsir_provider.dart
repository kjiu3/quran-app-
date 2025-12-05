import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

/// نموذج بيانات التفسير
class TafsirData {
  final int surahNumber;
  final int verseNumber;
  final String verseText;
  final String tafsirText;
  final String tafsirSource;

  const TafsirData({
    required this.surahNumber,
    required this.verseNumber,
    required this.verseText,
    required this.tafsirText,
    required this.tafsirSource,
  });
}

/// مزود التفسير - يوفر تفاسير مختصرة للآيات
class TafsirProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  TafsirData? _currentTafsir;
  String _selectedTafsirSource = 'مختصر';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TafsirData? get currentTafsir => _currentTafsir;
  String get selectedTafsirSource => _selectedTafsirSource;

  // قائمة مصادر التفسير المتاحة
  final List<String> availableTafsirSources = [
    'مختصر',
    'ابن كثير',
    'الطبري',
    'السعدي',
  ];

  /// تغيير مصدر التفسير
  void setTafsirSource(String source) {
    if (availableTafsirSources.contains(source)) {
      _selectedTafsirSource = source;
      notifyListeners();
    }
  }

  /// جلب تفسير آية معينة
  Future<void> getTafsir(int surahNumber, int verseNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // التحقق من صحة رقم السورة والآية
      if (surahNumber < 1 || surahNumber > 114) {
        throw Exception('رقم السورة غير صحيح');
      }

      final verseCount = quran.getVerseCount(surahNumber);
      if (verseNumber < 1 || verseNumber > verseCount) {
        throw Exception('رقم الآية غير صحيح');
      }

      // جلب نص الآية
      final verseText = quran.getVerse(surahNumber, verseNumber);

      // جلب التفسير (محلي)
      final tafsirText = _getLocalTafsir(surahNumber, verseNumber);

      _currentTafsir = TafsirData(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        verseText: verseText,
        tafsirText: tafsirText,
        tafsirSource: _selectedTafsirSource,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'حدث خطأ أثناء جلب التفسير: $e';
      notifyListeners();
    }
  }

  /// تفسير محلي مبسط للآيات الشهيرة
  String _getLocalTafsir(int surahNumber, int verseNumber) {
    // تفاسير بعض الآيات الشهيرة
    final key = '$surahNumber:$verseNumber';

    final tafsirMap = {
      // الفاتحة
      '1:1':
          'بِسْمِ اللَّهِ: أي أبتدئ قراءتي باسم الله. الرَّحْمَنِ الرَّحِيمِ: اسمان مشتقان من الرحمة، والرحمن أشد مبالغة من الرحيم.',
      '1:2':
          'الْحَمْدُ لِلَّهِ: الثناء على الله بصفات الكمال والجلال. رَبِّ الْعَالَمِينَ: المربي لجميع المخلوقات بنعمه.',
      '1:3': 'الرَّحْمَنِ الرَّحِيمِ: تكرار للتأكيد على سعة رحمة الله بعباده.',
      '1:4': 'مَالِكِ يَوْمِ الدِّينِ: أي يوم الحساب والجزاء، وهو يوم القيامة.',
      '1:5':
          'إِيَّاكَ نَعْبُدُ: نخصك وحدك بالعبادة. وَإِيَّاكَ نَسْتَعِينُ: نطلب منك المعونة في جميع أمورنا.',
      '1:6':
          'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ: دلنا وأرشدنا إلى الطريق الواضح الموصل إلى الله وجنته.',
      '1:7':
          'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ: طريق الأنبياء والصالحين. غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ: اليهود. وَلَا الضَّالِّينَ: النصارى.',

      // آية الكرسي
      '2:255':
          'هذه أعظم آية في كتاب الله، فيها إثبات صفات الله: الحياة والقيومية، ونفي السِّنة والنوم عنه، وإثبات ملكه لكل شيء، وعلمه الواسع، وعظمة كرسيه.',

      // الإخلاص
      '112:1':
          'قُلْ هُوَ اللَّهُ أَحَدٌ: أي الله واحد في ذاته وصفاته وأفعاله، لا شريك له.',
      '112:2':
          'اللَّهُ الصَّمَدُ: السيد الذي يُقصد في الحوائج، الكامل في صفاته.',
      '112:3': 'لَمْ يَلِدْ وَلَمْ يُولَدْ: ليس له ولد ولا والد، منزه عن ذلك.',
      '112:4':
          'وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ: لا مثيل له ولا شبيه ولا نظير.',

      // الفلق
      '113:1': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ: أستجير وألتجئ برب الصبح.',
      '113:2': 'مِنْ شَرِّ مَا خَلَقَ: من شر جميع المخلوقات.',
      '113:3': 'وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ: من شر الليل إذا أظلم.',
      '113:4': 'وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ: من شر الساحرات.',
      '113:5': 'وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ: من شر الحاسد.',

      // الناس
      '114:1': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ: أستجير بمالك أمور الناس.',
      '114:2': 'مَلِكِ النَّاسِ: المتصرف في شؤونهم.',
      '114:3': 'إِلَهِ النَّاسِ: معبودهم الحق.',
      '114:4':
          'مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ: الشيطان الذي يوسوس ثم يختفي.',
      '114:5': 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ: يلقي الشر في القلوب.',
      '114:6': 'مِنَ الْجِنَّةِ وَالنَّاسِ: الوسواس يكون من الجن والإنس.',
    };

    if (tafsirMap.containsKey(key)) {
      return tafsirMap[key]!;
    }

    // تفسير افتراضي
    final surahName = quran.getSurahName(surahNumber);
    return 'هذه الآية $verseNumber من سورة $surahName. '
        'للاطلاع على التفسير الكامل، يُرجى مراجعة كتب التفسير المعتمدة مثل تفسير ابن كثير أو الطبري أو السعدي.';
  }

  /// الانتقال للآية التالية
  Future<void> nextVerse() async {
    if (_currentTafsir == null) return;

    final surah = _currentTafsir!.surahNumber;
    final verse = _currentTafsir!.verseNumber;
    final verseCount = quran.getVerseCount(surah);

    if (verse < verseCount) {
      await getTafsir(surah, verse + 1);
    } else if (surah < 114) {
      await getTafsir(surah + 1, 1);
    }
  }

  /// الرجوع للآية السابقة
  Future<void> previousVerse() async {
    if (_currentTafsir == null) return;

    final surah = _currentTafsir!.surahNumber;
    final verse = _currentTafsir!.verseNumber;

    if (verse > 1) {
      await getTafsir(surah, verse - 1);
    } else if (surah > 1) {
      final prevVerseCount = quran.getVerseCount(surah - 1);
      await getTafsir(surah - 1, prevVerseCount);
    }
  }

  /// مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
