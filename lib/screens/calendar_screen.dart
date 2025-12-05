// cSpell:words Hijri hijri
import 'package:flutter/material.dart';

// cSpell:disable
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // قائمة بأسماء الأشهر الهجرية
  final List<String> hijriMonths = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الثاني',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];
  // cSpell:disable
  // قائمة بأيام الأسبوع
  final List<String> weekDays = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  // بيانات افتراضية للعرض (سيتم استبدالها بحساب فعلي للتاريخ الهجري)
  int currentHijriDay = 15;
  int currentHijriMonth = 8; // رمضان
  int currentHijriYear = 1445;
  int currentWeekDay = 3; // الثلاثاء
  // cSpell:enable

  @override
  void initState() {
    super.initState();
    // cSpell:disable
    // هنا يمكن إضافة كود لحساب التاريخ الهجري الحالي باستخدام مكتبة مناسبة
    // cSpell:enable
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'التقويم الهجري',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // cSpell:disable
            // عرض التاريخ الهجري الحالي
            // cSpell:enable
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    weekDays[currentWeekDay],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$currentHijriDay ${hijriMonths[currentHijriMonth - 1]} $currentHijriYear هـ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // عرض تقويم الشهر الحالي
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'شهر ${hijriMonths[currentHijriMonth - 1]} $currentHijriYear هـ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // أيام الأسبوع
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        weekDays.map((day) {
                          return SizedBox(
                            width: 40,
                            child: Text(
                              day.substring(0, 1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    day == 'الجمعة'
                                        ? Colors.orange
                                        : Colors.black54,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // عرض أيام الشهر (مثال بسيط)
                  _buildCalendarGrid(),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // معلومات عن الشهر الحالي
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    // cSpell:disable
                    'مناسبات الشهر',
                    // cSpell:enable
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // cSpell:disable
                  _buildEventItem('1 رمضان', 'بداية شهر رمضان المبارك'),
                  _buildEventItem('17 رمضان', 'غزوة بدر الكبرى'),
                  _buildEventItem('21 رمضان', 'فتح مكة'),
                  _buildEventItem('27 رمضان', 'ليلة القدر (على الأرجح)'),
                  // cSpell:enable
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء شبكة التقويم
  Widget _buildCalendarGrid() {
    // هذا مثال بسيط لعرض أيام الشهر
    // في التطبيق الحقيقي، يجب حساب عدد أيام الشهر وموقع اليوم الأول
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 30, // افتراض أن الشهر 30 يوم
      itemBuilder: (context, index) {
        final day = index + 1;
        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: day == currentHijriDay ? Colors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                color: day == currentHijriDay ? Colors.white : Colors.black,
                fontWeight:
                    day == currentHijriDay
                        ? FontWeight.bold
                        : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  // بناء عنصر حدث
  Widget _buildEventItem(String date, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }
}

// cSpell:enable
