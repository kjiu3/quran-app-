import 'package:flutter/material.dart';

class AllahNamesScreen extends StatefulWidget {
  const AllahNamesScreen({super.key});

  @override
  State<AllahNamesScreen> createState() => _AllahNamesScreenState();
}

class _AllahNamesScreenState extends State<AllahNamesScreen> {
  final List<Map<String, dynamic>> allahNames = [
    {
      'name': 'الله',
      'meaning': 'الذات الإلهية المستحقة للعبادة',
      'number': '1',
    },
    {
      'name': 'الرحمن',
      'meaning': 'ذو الرحمة الواسعة التي وسعت كل شيء',
      'number': '2',
    },
    {
      'name': 'الرحيم',
      'meaning': 'الذي يرحم المؤمنين في الآخرة',
      'number': '3',
    },
    {'name': 'الملك', 'meaning': 'المتصرف في جميع الأمور', 'number': '4'},
    {'name': 'القدوس', 'meaning': 'المنزه عن العيوب والنقائص', 'number': '5'},
    {'name': 'السلام', 'meaning': 'السالم من النقص والعيب', 'number': '6'},
    {'name': 'المؤمن', 'meaning': 'الذي يؤمن أولياءه من عذابه', 'number': '7'},
    {'name': 'المهيمن', 'meaning': 'الرقيب الحافظ لكل شيء', 'number': '8'},
    {'name': 'العزيز', 'meaning': 'الغالب الذي لا يُغلب', 'number': '9'},
    {'name': 'الجبار', 'meaning': 'القاهر لخلقه على ما أراد', 'number': '10'},
    // يمكن إضافة باقي الأسماء الحسنى هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'أسماء الله الحسنى',
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
                hintText: 'ابحث في أسماء الله الحسنى...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.orange),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // عرض أسماء الله الحسنى
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: allahNames.length,
              itemBuilder: (context, index) {
                final name = allahNames[index];
                return Container(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            name['number'],
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          name['meaning'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
