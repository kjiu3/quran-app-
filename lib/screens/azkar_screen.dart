import 'package:flutter/material.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  final List<Map<String, dynamic>> azkarCategories = [
    {
      'name': 'أذكار الصباح',
      'description': 'الأذكار المستحبة في الصباح',
      'count': '22 ذكر',
      'image': 'assets/icons/quran.png',
    },
    {
      'name': 'أذكار المساء',
      'description': 'الأذكار المستحبة في المساء',
      'count': '21 ذكر',
      'image': 'assets/icons/quran.png',
    },
    {
      'name': 'أذكار بعد الصلاة',
      'description': 'الأذكار المستحبة بعد الصلوات الخمس',
      'count': '15 ذكر',
      'image': 'assets/icons/quran.png',
    },
    {
      'name': 'أذكار النوم',
      'description': 'الأذكار المستحبة عند النوم',
      'count': '12 ذكر',
      'image': 'assets/icons/quran.png',
    },
    {
      'name': 'أذكار الاستيقاظ',
      'description': 'الأذكار المستحبة عند الاستيقاظ من النوم',
      'count': '8 ذكر',
      'image': 'assets/icons/quran.png',
    },
    {
      'name': 'أدعية قرآنية',
      'description': 'أدعية مختارة من القرآن الكريم',
      'count': '20 دعاء',
      'image': 'assets/icons/quran.png',
    },
    {
      'name': 'أدعية نبوية',
      'description': 'أدعية مأثورة عن النبي صلى الله عليه وسلم',
      'count': '25 دعاء',
      'image': 'assets/icons/quran.png',
    },
    {
      'name': 'أدعية متنوعة',
      'description': 'أدعية لمختلف المناسبات والأحوال',
      'count': '30 دعاء',
      'image': 'assets/icons/quran.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'الأذكار والأدعية',
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
                hintText: 'ابحث عن ذكر أو دعاء...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.orange),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // قائمة الأذكار والأدعية
          Expanded(
            child: ListView.builder(
              itemCount: azkarCategories.length,
              itemBuilder: (context, index) {
                final category = azkarCategories[index];
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
                      category['image'],
                      width: 50,
                      height: 50,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                    ),
                    title: Text(
                      category['name'],
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
                          category['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          category['count'],
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
                      // الانتقال إلى صفحة تفاصيل الأذكار أو الأدعية
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
