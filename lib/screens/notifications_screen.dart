import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // قائمة بالإشعارات المتاحة
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'مواقيت الصلاة',
      'description': 'تنبيهات لمواقيت الصلوات الخمس',
      'isEnabled': true,
      'icon': Icons.access_time,
    },
    {
      'title': 'أذكار الصباح',
      'description': 'تذكير بأذكار الصباح الساعة 6:00 صباحاً',
      'isEnabled': true,
      'icon': Icons.wb_sunny,
    },
    {
      'title': 'أذكار المساء',
      'description': 'تذكير بأذكار المساء الساعة 5:00 مساءً',
      'isEnabled': true,
      'icon': Icons.nights_stay,
    },
    {
      'title': 'ورد يومي من القرآن',
      'description': 'تذكير بقراءة ورد القرآن اليومي',
      'isEnabled': false,
      'icon': Icons.menu_book,
    },
    {
      'title': 'حديث اليوم',
      'description': 'حديث نبوي يومي للتذكرة',
      'isEnabled': false,
      'icon': Icons.format_quote,
    },
    {
      'title': 'فضل الأعمال',
      'description': 'تذكير بفضائل الأعمال حسب اليوم',
      'isEnabled': false,
      'icon': Icons.star,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // رأس الصفحة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إعدادات الإشعارات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'يمكنك تفعيل أو إلغاء الإشعارات التي ترغب في استلامها',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // قائمة الإشعارات
          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      notification['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notification['description']),
                    value: notification['isEnabled'],
                    onChanged: (value) {
                      setState(() {
                        _notifications[index]['isEnabled'] = value;
                      });
                      // هنا يمكن إضافة كود لحفظ إعدادات الإشعارات
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? 'تم تفعيل ${notification["title"]}'
                                : 'تم إلغاء ${notification["title"]}',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    secondary: Icon(
                      notification['icon'],
                      color: Colors.orange,
                      size: 30,
                    ),
                    activeColor: Colors.orange,
                  ),
                );
              },
            ),
          ),
          // زر حفظ الإعدادات
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // هنا يمكن إضافة كود لحفظ جميع إعدادات الإشعارات
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حفظ إعدادات الإشعارات'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'حفظ الإعدادات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
