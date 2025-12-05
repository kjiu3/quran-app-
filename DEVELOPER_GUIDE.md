# 📚 دليل المطور السريع - تطبيق القرآن الكريم

## 🚀 البدء السريع

### 1. متطلبات التشغيل
```bash
# التأكد من تثبيت Flutter
flutter --version

# يجب أن يكون الإصدار 3.7.0 أو أحدث
```

### 2. تثبيت المكتبات
```bash
cd c:\Users\nassa\Downloads\Islamic-and-quran-data-main\quran1\quran
flutter pub get
```

### 3. تشغيل التطبيق
```bash
# للأندرويد
flutter run

# للويندوز
flutter run -d windows

# للويب
flutter run -d chrome
```

---

## 📁 هيكل المشروع

```
quran/
├── lib/
│   ├── main.dart                 # نقطة البداية
│   ├── routes.dart               # تعريف المسارات
│   │
│   ├── models/                   # نماذج البيانات
│   │   └── feature.dart
│   │
│   ├── providers/                # مزودات الحالة (State Management)
│   │   ├── audio_provider.dart   # إدارة الصوتيات
│   │   └── theme_provider.dart   # إدارة الثيمات
│   │
│   ├── screens/                  # الشاشات الرئيسية
│   │   ├── home_screen.dart      # الشاشة الرئيسية
│   │   ├── quran_screen.dart     # شاشة القرآن
│   │   ├── hadith_screen.dart    # شاشة الحديث
│   │   ├── azkar_screen.dart     # شاشة الأذكار
│   │   ├── qibla_screen.dart     # شاشة القبلة
│   │   ├── radio_screen.dart     # شاشة الراديو
│   │   ├── audio_screen.dart     # شاشة الصوتيات
│   │   ├── calendar_screen.dart  # شاشة التقويم
│   │   ├── mushaf_screen.dart    # شاشة المصحف (604 صفحة)
│   ├── tafsir_screen.dart    # شاشة التفسير
│   │   ├── tasbih_screen.dart    # شاشة السبحة
│   │   ├── allah_names_screen.dart      # شاشة أسماء الله
│   │   ├── notifications_screen.dart    # شاشة الإشعارات
│   │   └── settings_screen.dart  # شاشة الإعدادات
│   │
│   └── widgets/                  # المكونات القابلة لإعادة الاستخدام
│       ├── feature_card.dart     # بطاقة الميزة
│       ├── smart_image.dart      # صورة ذكية مع fallback
│       └── error_handler_widget.dart  # معالج الأخطاء
│
├── test/                         # الاختبارات
│   ├── providers/
│   │   ├── theme_provider_test.dart
│   │   └── audio_provider_test.dart
│   └── widget_test.dart
│
├── assets/                       # الموارد (صور، خطوط، إلخ)
│   ├── icons/
│   ├── images/
│   ├── audio/
│   ├── data/
│   └── fonts/
│
├── pubspec.yaml                  # ملف التبعيات
├── README.md                     # الوثائق الأساسية
├── IMPLEMENTATION_STATUS.md      # حالة التنفيذ
└── FUTURE_IMPROVEMENTS.md        # التحسينات المستقبلية
```

---

## 🔧 المكونات الرئيسية

### 1. AudioProvider
**الموقع:** `lib/providers/audio_provider.dart`

**الوظيفة:** إدارة تشغيل الصوتيات (القرآن الكريم)

**الاستخدام:**
```dart
// في أي شاشة
Consumer<AudioProvider>(
  builder: (context, audioProvider, child) {
    return IconButton(
      icon: Icon(audioProvider.isPlaying ? Icons.pause : Icons.play_arrow),
      onPressed: () {
        if (audioProvider.isPlaying) {
          audioProvider.pause();
        } else {
          audioProvider.playSurah(surahNumber);
        }
      },
    );
  },
)
```

**الوظائف المتاحة:**
- `playSurah(int surahNumber)` - تشغيل سورة (رابط افتراضي)
- `playSurahFromUrl(int surahNumber, String url)` - تشغيل من رابط قارئ محدد
- `pause()` - إيقاف مؤقت
- `stop()` - إيقاف كامل
- `resume()` - استئناف التشغيل
- `clearError()` - مسح رسائل الخطأ

**الخصائص:**
- `isPlaying` - هل يتم التشغيل؟
- `currentSurahNumber` - رقم السورة الحالية
- `isBuffering` - هل يتم التحميل؟
- `errorMessage` - رسالة الخطأ (إن وجدت)

---

### 2. ThemeProvider
**الموقع:** `lib/providers/theme_provider.dart`

**الوظيفة:** إدارة الثيمات (فاتح/داكن)

**الاستخدام:**
```dart
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () => themeProvider.toggleTheme(),
    );
  },
)
```

**الوظائف:**
- `toggleTheme()` - التبديل بين الثيمات
- `setDarkMode(bool value)` - تعيين الثيم مباشرة

---

### 3. TafsirProvider
**الموقع:** `lib/providers/tafsir_provider.dart`

**الوظيفة:** إدارة عرض التفسير للآيات القرآنية

**الاستخدام:**
```dart
Consumer<TafsirProvider>(
  builder: (context, tafsirProvider, child) {
    return ElevatedButton(
      onPressed: () {
        tafsirProvider.getTafsir(surahNumber, verseNumber);
      },
      child: Text('عرض التفسير'),
    );
  },
)
```

**الوظائف:**
- `getTafsir(int surahNumber, int verseNumber)` - جلب تفسير آية
- `nextVerse()` - الانتقال للآية التالية
- `previousVerse()` - الرجوع للآية السابقة
- `setTafsirSource(String source)` - تغيير مصدر التفسير
- `clearError()` - مسح الأخطاء

**المصادر المتاحة:**
- مختصر (افتراضي)
- ابن كثير
- الطبري
- السعدي

**التفاسير المحلية:**
يحتوي على تفاسير مُضمنة للآيات الشهيرة:
- سورة الفاتحة كاملة
- آية الكرسي
- سورة الإخلاص
- المعوذتين

---

### 4. Reciter Model
**الموقع:** `lib/models/reciter.dart`

**الوظيفة:** نموذج بيانات القراء مع روابط التلاوات

**القراء المتاحون (8 قراء):**
1. عبد الباسط عبد الصمد (مجود)
2. مشاري العفاسي
3. عبد الرحمن السديس
4. سعود الشريم
5. ماهر المعيقلي
6. محمود خليل الحصري (مجود)
7. محمد صديق المنشاوي (مرتل)
8. أحمد العجمي

**الاستخدام:**
```dart
// الحصول على رابط تلاوة قارئ محدد
final reciter = Reciter.famousReciters[0]; // عبد الباسط
final url = reciter.getSurahAudioUrl(1); // سورة الفاتحة
audioProvider.playSurahFromUrl(1, url);
```

---

### 5. SmartImage Widget
**الموقع:** `lib/widgets/smart_image.dart`

**الوظيفة:** عرض الصور مع fallback تلقائي

**الاستخدام:**
```dart
SmartImage(
  imagePath: 'assets/icons/quran.png',
  width: 50,
  height: 50,
  fallbackIcon: Icons.menu_book,
  iconColor: Colors.orange,
)
```

**المميزات:**
- عرض الصورة إذا كانت موجودة
- عرض أيقونة بديلة إذا فشل تحميل الصورة
- تخصيص الحجم واللون

---

### 6. ErrorHandlerWidget
**الموقع:** `lib/widgets/error_handler_widget.dart`

**الوظيفة:** عرض رسائل الخطأ بشكل موحد

**الاستخدام:**
```dart
ErrorHandlerWidget(
  errorMessage: audioProvider.errorMessage,
  onDismiss: () => audioProvider.clearError(),
)

// أو استخدام SnackBar
ErrorHandlerWidget.showErrorSnackBar(
  context,
  'رسالة الخطأ',
  onRetry: () {
    // إعادة المحاولة
  },
)
```

---

## 🎨 إضافة شاشة جديدة

### الخطوات:

#### 1. إنشاء ملف الشاشة
```dart
// lib/screens/my_new_screen.dart
import 'package:flutter/material.dart';

class MyNewScreen extends StatelessWidget {
  const MyNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'شاشتي الجديدة',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('محتوى الشاشة'),
      ),
    );
  }
}
```

#### 2. إضافة المسار في routes.dart
```dart
// lib/routes.dart
import 'screens/my_new_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    // ... المسارات الموجودة
    '/my_new_screen': (context) => const MyNewScreen(),
  };
}
```

#### 3. إضافة الميزة في home_screen.dart
```dart
// lib/screens/home_screen.dart
final List<Feature> features = [
  // ... الميزات الموجودة
  Feature(
    title: 'ميزتي الجديدة',
    materialIcon: Icons.new_releases,
    route: '/my_new_screen',
  ),
];
```

---

## 🔌 إضافة Provider جديد

### الخطوات:

#### 1. إنشاء ملف Provider
```dart
// lib/providers/my_provider.dart
import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  // الحالة
  String _data = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // الوظائف
  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // جلب البيانات
      await Future.delayed(Duration(seconds: 2));
      _data = 'بيانات جديدة';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'حدث خطأ: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
```

#### 2. تسجيل Provider في main.dart
```dart
// lib/main.dart
import 'providers/my_provider.dart';

MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => AudioProvider()),
    ChangeNotifierProvider(create: (_) => MyProvider()), // جديد
  ],
  child: MyApp(),
)
```

#### 3. استخدام Provider في الشاشة
```dart
Consumer<MyProvider>(
  builder: (context, myProvider, child) {
    if (myProvider.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (myProvider.errorMessage != null) {
      return Text(myProvider.errorMessage!);
    }
    
    return Text(myProvider.data);
  },
)
```

---

## 🧪 إضافة اختبارات

### اختبار Provider:
```dart
// test/providers/my_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/providers/my_provider.dart';

void main() {
  group('MyProvider Tests', () {
    late MyProvider provider;

    setUp(() {
      provider = MyProvider();
    });

    test('Initial state should be correct', () {
      expect(provider.data, '');
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
    });

    test('fetchData should update data', () async {
      await provider.fetchData();
      expect(provider.data, isNotEmpty);
      expect(provider.isLoading, false);
    });
  });
}
```

### اختبار Widget:
```dart
// test/widgets/my_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/widgets/my_widget.dart';

void main() {
  testWidgets('MyWidget should display text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyWidget(text: 'Test'),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}
```

---

## 🎯 أفضل الممارسات

### 1. استخدام const Constructors
```dart
// ✅ جيد
const Text('مرحباً');
const SizedBox(height: 16);

// ❌ سيء
Text('مرحباً');
SizedBox(height: 16);
```

### 2. معالجة الأخطاء
```dart
// ✅ جيد
try {
  await someAsyncOperation();
} catch (e) {
  _errorMessage = 'حدث خطأ: $e';
  notifyListeners();
}

// ❌ سيء
await someAsyncOperation(); // بدون معالجة أخطاء
```

### 3. استخدام Null Safety
```dart
// ✅ جيد
String? errorMessage;
if (errorMessage != null) {
  print(errorMessage);
}

// ❌ سيء
String errorMessage;
print(errorMessage); // قد يسبب خطأ
```

### 4. تنظيف الموارد
```dart
@override
void dispose() {
  _audioPlayer.dispose();
  super.dispose();
}
```

---

## 🐛 حل المشاكل الشائعة

### 1. خطأ في تحميل الصور
**المشكلة:** الصورة لا تظهر

**الحل:**
```dart
// استخدم SmartImage بدلاً من Image.asset
SmartImage(
  imagePath: 'assets/icons/image.png',
  fallbackIcon: Icons.image,
)

// أو أضف errorBuilder
Image.asset(
  'assets/icons/image.png',
  errorBuilder: (context, error, stackTrace) => Icon(Icons.image),
)
```

### 2. Provider لا يعمل
**المشكلة:** التغييرات لا تظهر في الواجهة

**الحل:**
```dart
// تأكد من استدعاء notifyListeners()
void updateData(String newData) {
  _data = newData;
  notifyListeners(); // مهم!
}

// تأكد من استخدام Consumer أو Provider.of
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Text(provider.data);
  },
)
```

### 3. خطأ في تشغيل الصوت
**المشكلة:** الصوت لا يعمل

**الحل:**
```dart
// تحقق من الاتصال بالإنترنت
bool hasInternet = await _checkConnectivity();
if (!hasInternet) {
  _errorMessage = 'لا يوجد اتصال بالإنترنت';
  return;
}

// استخدم try-catch
try {
  await _audioPlayer.play(UrlSource(url));
} catch (e) {
  _errorMessage = 'فشل التشغيل: $e';
}
```

---

## 📝 الأوامر المفيدة

### تشغيل الاختبارات
```bash
# جميع الاختبارات
flutter test

# اختبار محدد
flutter test test/providers/audio_provider_test.dart

# مع تقرير التغطية
flutter test --coverage
```

### تنظيف المشروع
```bash
flutter clean
flutter pub get
```

### بناء التطبيق
```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# Windows
flutter build windows

# Web
flutter build web
```

### فحص الكود
```bash
# تحليل الكود
flutter analyze

# تنسيق الكود
dart format lib/
```

---

## 🔗 روابط مفيدة

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Quran Package](https://pub.dev/packages/quran)
- [Audioplayers Package](https://pub.dev/packages/audioplayers)
- [Hijri Calendar](https://pub.dev/packages/hijri)

---

## 📞 الدعم

إذا واجهت أي مشكلة:
1. راجع ملف `IMPLEMENTATION_STATUS.md` للحالة الحالية
2. راجع ملف `FUTURE_IMPROVEMENTS.md` للميزات المخطط لها
3. تحقق من الاختبارات في مجلد `test/`

---

---

## 🆕 الميزات الجديدة المُضافة

### 1. واجهة المصحف الكاملة
- **604 صفحة** من القرآن الكريم
- صور عالية الجودة من everyayah.com API
- **تكبير وتصغير** InteractiveViewer
- التنقل السريع لأي صفحة
- واجهة تشبه المصحف الورقي

**الوصول:**
```dart
Navigator.pushNamed(context, '/mushaf');
// أو مع صفحة محددة
Navigator.pushNamed(
  context,
  '/mushaf',
  arguments: {'initialPage': 300},
);
```

### 2. نظام التفسير
- تفاسير محلية للآيات الشهيرة
- التنقل بين الآيات
- واجهة جميلة مع عرض النص والتفسير
- ربط مع نتائج البحث

**الوصول:**
```dart
Navigator.pushNamed(
  context,
  '/tafsir',
  arguments: {
    'surahNumber': 1,
    'verseNumber': 1,
  },
);
```

### 3. شاشة الصوتيات المُفعّلة
- 8 قراء مشهورين
- تبويبات (القراء / السور)
- مشغل صوت مصغر
- البحث في السور
- تشغيل فعلي للتلاوات

### 4. تحسينات UI/UX
- رسوم متحركة للبطاقات (fade + scale)
- تأثيرات دخول متتابعة
- تأثيرات ضغط ديناميكية
- ظلال وألوان محسّنة

### 5. البحث المتكامل
- البحث في القرآن الكريم
- تمييز النتائج
- الانتقال المباشر للتفسير
- حفظ عمليات البحث الأخيرة

---

*آخر تحديث: 2025-12-05*
