import 'package:flutter/material.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _totalCounter = 0;
  String _currentDhikr = 'سبحان الله';
  double _progress = 0.0;
  int _target = 33;

  final List<Map<String, dynamic>> _dhikrList = [
    {'name': 'سبحان الله', 'target': 33},
    {'name': 'الحمد لله', 'target': 33},
    {'name': 'الله أكبر', 'target': 33},
    {'name': 'لا إله إلا الله', 'target': 100},
    {'name': 'أستغفر الله', 'target': 100},
    {'name': 'سبحان الله وبحمده', 'target': 100},
    {'name': 'لا حول ولا قوة إلا بالله', 'target': 100},
    {'name': 'اللهم صل على محمد', 'target': 10},
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
      _totalCounter++;
      _progress = _counter / _target;

      // إذا وصلنا للهدف، نعرض رسالة
      if (_counter == _target) {
        _showCompletionDialog();
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _progress = 0.0;
    });
  }

  void _changeDhikr(Map<String, dynamic> dhikr) {
    setState(() {
      _currentDhikr = dhikr['name'];
      _target = dhikr['target'];
      _counter = 0;
      _progress = 0.0;
    });
    Navigator.pop(context);
  }

  void _showDhikrSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر الذكر', textAlign: TextAlign.center),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _dhikrList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _dhikrList[index]['name'],
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    'الهدف: ${_dhikrList[index]['target']}',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () => _changeDhikr(_dhikrList[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('أحسنت!', textAlign: TextAlign.center),
          content: Text(
            'لقد أكملت $_target من $_currentDhikr',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetCounter();
              },
              child: const Text('إعادة'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDhikrSelectionDialog();
              },
              child: const Text('ذكر آخر'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'السبحة الإلكترونية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCounter,
            tooltip: 'إعادة تعيين',
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _showDhikrSelectionDialog,
            tooltip: 'اختيار الذكر',
          ),
        ],
      ),
      body: Column(
        children: [
          // عداد التسبيح الإجمالي
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Text(
              'مجموع التسبيح: $_totalCounter',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الذكر الحالي
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _currentDhikr,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // دائرة التقدم
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 15,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      ),
                    ),
                    // عداد التسبيح
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(red: 0, green: 0, blue: 0, alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_counter',
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'من $_target',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // زر التسبيح
                GestureDetector(
                  onTap: _incrementCounter,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(red: 255, green: 165, blue: 0, alpha: 0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
