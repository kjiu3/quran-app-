import 'package:flutter/material.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final List<Map<String, dynamic>> hadithBooks = [
    {
      'name': 'صحيح البخاري',
      'author': 'محمد بن إسماعيل البخاري',
      'count': '7563 حديث',
      'image': 'assets/icons/hadith.png',
    },
    {
      'name': 'صحيح مسلم',
      'author': 'مسلم بن الحجاج النيسابوري',
      'count': '7500 حديث',
      'image': 'assets/icons/hadith.png',
    },
    {
      'name': 'سنن أبي داود',
      'author': 'أبو داود سليمان بن الأشعث',
      'count': '5274 حديث',
      'image': 'assets/icons/hadith.png',
    },
    {
      'name': 'جامع الترمذي',
      'author': 'محمد بن عيسى الترمذي',
      'count': '3956 حديث',
      'image': 'assets/icons/hadith.png',
    },
    {
      'name': 'سنن النسائي',
      'author': 'أحمد بن شعيب النسائي',
      'count': '5761 حديث',
      'image': 'assets/icons/hadith.png',
    },
    {
      'name': 'سنن ابن ماجه',
      'author': 'محمد بن يزيد ابن ماجه',
      'count': '4341 حديث',
      'image': 'assets/icons/hadith.png',
    },
    {
      'name': 'موطأ مالك',
      'author': 'مالك بن أنس',
      'count': '1720 حديث',
      'image': 'assets/icons/hadith.png',
    },
    {
      'name': 'مسند أحمد',
      'author': 'أحمد بن حنبل',
      'count': '28000 حديث',
      'image': 'assets/icons/hadith.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'مكتبة الحديث',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // بطاقة البحث
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(77),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن حديث...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.orange),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // قائمة كتب الحديث
          Expanded(
            child: ListView.builder(
              itemCount: hadithBooks.length,
              itemBuilder: (context, index) {
                final book = hadithBooks[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(51),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Image.asset(
                      book['image'],
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                    title: Text(
                      book['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['author'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          book['count'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.orange,
                      size: 16,
                    ),
                    onTap: () {
                      // الانتقال إلى صفحة تفاصيل كتاب الحديث
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
