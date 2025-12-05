# إعداد Firebase للويب

## الخطوة 1: إضافة تطبيق الويب في Firebase Console

### 1.1 الذهاب إلى Firebase Console
1. افتح [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك: **quran-app-de263**

### 1.2 إضافة تطبيق ويب
1. في صفحة نظرة عامة على المشروع (Project Overview)
2. انقر على أيقونة الويب `</>`
3. أدخل اسم التطبيق: `Quran Web App`
4. ✅ فعّل **Firebase Hosting** (اختياري ولكن موصى به)
5. انقر **Register app**

### 1.3 نسخ Web App ID
بعد التسجيل، ستظهر لك صفحة تحتوي على:
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyAYw1fm5XtH5o2OnBpL-mn2TEzpLYaylGk",
  authDomain: "quran-app-de263.firebaseapp.com",
  projectId: "quran-app-de263",
  storageBucket: "quran-app-de263.firebasestorage.app",
  messagingSenderId: "838930331802",
  appId: "1:838930331802:web:XXXXXXXXXXXXXXXX" // <-- هذا ما نحتاجه
};
```

**انسخ قيمة `appId`** من السطر الأخير.

---

## الخطوة 2: تحديث firebase_options.dart

افتح ملف `lib/firebase_options.dart` وابحث عن السطر:
```dart
appId: '1:838930331802:web:XXXXXXXXXXXXXXXX', // TODO: أضف Web App ID من Firebase Console
```

استبدل `XXXXXXXXXXXXXXXX` بالقيمة الفعلية التي نسختها من Firebase Console.

**مثال:**
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyAYw1fm5XtH5o2OnBpL-mn2TEzpLYaylGk',
  appId: '1:838930331802:web:abc123def456ghi7', // <-- القيمة الفعلية
  messagingSenderId: '838930331802',
  projectId: 'quran-app-de263',
  authDomain: 'quran-app-de263.firebaseapp.com',
  storageBucket: 'quran-app-de263.firebasestorage.app',
);
```

---

## الخطوة 3: (اختياري) إضافة تطبيق iOS

إذا كنت تريد دعم iOS:

1. في Firebase Console، انقر على أيقونة iOS
2. أدخل:
   - **iOS bundle ID**: `com.Quran.myapp`
   - **App nickname**: `Quran iOS App`
3. حمّل ملف `GoogleService-Info.plist`
4. ضعه في مجلد `ios/Runner/`
5. حدّث `appId` في firebase_options.dart للـ iOS

---

## الخطوة 4: التحقق من الإعداد

### تشغيل التطبيق على الويب:
```bash
flutter run -d chrome
```

### التحقق من الاتصال:
سيتم تهيئة Firebase تلقائياً عند تشغيل التطبيق. تحقق من Console في المتصفح (F12) للتأكد من عدم وجود أخطاء.

---

## ملخص التغييرات

✅ **تم إكمال:**
- تحديث `firebase_options.dart` بالتكوينات الصحيحة لـ Android
- إضافة تكوين الويب الأولي
- تحديث `web/index.html` بسكريبتات Firebase

⏳ **يتطلب إجراء يدوي:**
- إضافة تطبيق الويب في Firebase Console
- نسخ Web App ID الفعلي وتحديث `firebase_options.dart`

📝 **ملاحظات:**
- ملف `google-services.json` موجود بالفعل في المكان الصحيح (`android/app/`)
- تأكد من تفعيل Authentication و Firestore في Firebase Console
- راجع ملف `FIREBASE_SETUP.md` للتعليمات الكاملة
