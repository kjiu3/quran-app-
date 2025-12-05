# دليل إعداد Firebase للمزامنة السحابية

## نظرة عامة
سنقوم بإعداد Firebase لمزامنة بيانات المستخدم (المفضلات، الإحصائيات، الإعدادات) عبر الأجهزة.

---

## المتطلبات الأساسية

- ✅ حساب Google
- ✅ Flutter SDK مُثبّت
- ✅ Node.js مُثبّت (لـ Firebase CLI)

---

## الخطوة 1: إنشاء مشروع Firebase

### 1.1 زيارة Firebase Console
1. افتح [Firebase Console://console.firebase.google.co](httpsm/)
2. سجّل الدخول بحساب Google

### 1.2 إنشاء مشروع جديد
1. انقر على **"Add project"** أو **"إضافة مشروع"**
2. أدخل اسم المشروع: `quran-app` (أو أي اسم تريده)
3. (اختياري) فعّل Google Analytics
4. انقر **"Create project"**
5. انتظر حتى يتم إنشاء المشروع

---

## الخطوة 2: تفعيل الخدمات المطلوبة

### 2.1 Authentication (المصادقة)
1. من القائمة الجانبية، اختر **"Authentication"**
2. انقر **"Get started"**
3. اذهب إلى تبويب **"Sign-in method"**
4. فعّل **"Google"**:
   - انقر على Google
   - فعّل الزر
   - أدخل بريد دعم المشروع
   - احفظ

### 2.2 Cloud Firestore (قاعدة البيانات)
1. من القائمة الجانبية، اختر **"Firestore Database"**
2. انقر **"Create database"**
3. اختر **"Start in test mode"** (للتطوير)
4. اختر موقع الخادم (الأقرب لك، مثل `europe-west`)
5. انقر **"Enable"**

> **تحذير أمني:** وضع Test mode يسمح بالوصول الكامل!  
> **يجب** تحديث قواعد الأمان للإنتاج (سنفعل هذا لاحقاً)

---

## الخطوة 3: تثبيت Firebase CLI & FlutterFire CLI

### 3.1 تثبيت Firebase CLI
افتح PowerShell وشغّل:
```powershell
npm install -g firebase-tools
```

تحقق من التثبيت:
```powershell
firebase --version
```

### 3.2 تسجيل الدخول
```powershell
firebase login
```

ستفتح نافذة متصفح - سجّل الدخول بنفس حساب Google.

### 3.3 تثبيت FlutterFire CLI
```powershell
dart pub global activate flutterfire_cli
```

تحقق:
```powershell
flutterfire --version
```

> **ملاحظة:** إذا لم يعمل الأمر، أضف Dart global bin للـ PATH:
> `C:\Users\YourUsername\AppData\Local\Pub\Cache\bin`

---

## الخطوة 4: ربط المشروع بـ Firebase

### 4.1 في مجلد المشروع
افتح terminal في:
```
c:\Users\nassa\Downloads\Islamic-and-quran-data-main\quran1\quran
```

### 4.2 تكوين Firebase
شغّل الأمر:
```powershell
flutterfire configure
```

**سيطلب منك:**
1. اختيار مشروع Firebase (اختر المشروع الذي أنشأته)
2. اختيار المنصات (اختر Android و iOS)
3. اختيار Bundle ID/Package name

**سينشئ:**
- ملف `firebase_options.dart` في `lib/`
- ملفات تكوين لكل منصة

---

## الخطوة 5: إضافة الحزم المطلوبة

سأضيف الحزم لملف `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  google_sign_in: ^6.2.2
```

---

## الخطوة 6: تحديث قواعد Firestore (مهم!)

في Firebase Console:
1. اذهب إلى **Firestore Database**
2. تبويب **"Rules"**
3. استبدل القواعد بالتالي:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // المستخدمون المصادقون فقط يمكنهم الوصول
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // المفضلات
      match /bookmarks/{bookmarkId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // الإحصائيات
      match /statistics/{statId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // الإعدادات
      match /settings/{settingId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

4. انقر **"Publish"**

---

## الخطوة 7: تكوين Android

### 7.1 تحديث android/app/build.gradle.kts
تأكد من وجود:
```kotlin
android {
    defaultConfig {
        minSdk = 21  // Firebase يتطلب 21 على الأقل
    }
}
```

### 7.2 ملف google-services.json
- `flutterfire configure` يجب أن ينزله تلقائياً
- موقعه: `android/app/google-services.json`

---

## الخطوة 8: الاختبار الأولي

سأنشئ كود اختبار بسيط للتأكد من الاتصال.

---

## ملخص الخطوات

- [ ] إنشاء مشروع Firebase
- [ ] تفعيل Authentication (Google Sign-in)
- [ ] تفعيل Cloud Firestore
- [ ] تثبيت Firebase CLI
- [ ] تثبيت FlutterFire CLI
- [ ] تشغيل `flutterfire configure`
- [ ] تحديث قواعد Firestore
- [ ] التحقق من minSdk >= 21

---

## التالي

بعد إكمال هذه الخطوات، سأقوم بـ:
1. إضافة الحزم المطلوبة
2. إنشاء AuthService
3. إنشاء SyncService
4. تحديث الـ Providers للمزامنة
5. إنشاء واجهة تسجيل الدخول

**هل أنت مستعد للبدء؟** أخبرني متى تنتهي من الخطوات اليدوية!
