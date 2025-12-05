import 'package:flutter/material.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  // متغير لتخزين زاوية اتجاه القبلة (سيتم تحديثه لاحقاً باستخدام حساسات الجهاز)
  double _qiblaDirection = 0.0;
  bool _isCalibrating = false;

  @override
  void initState() {
    super.initState();
    // هنا سيتم إضافة كود لتحديد اتجاه القبلة باستخدام حساسات الجهاز
    // يتطلب استخدام مكتبات مثل flutter_compass
  }

  void _calibrateCompass() {
    setState(() {
      _isCalibrating = true;
    });
    
    // محاكاة عملية المعايرة
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isCalibrating = false;
        // تحديث زاوية افتراضية للعرض
        _qiblaDirection = 137.5; // قيمة افتراضية للعرض
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'القبلة',
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
          const SizedBox(height: 20),
          // بطاقة معلومات القبلة
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(76),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'اتجاه القبلة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_qiblaDirection.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'قم بتوجيه الجهاز بشكل مستوٍ وحركه بشكل أفقي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // بوصلة القبلة
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // صورة البوصلة
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(76),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // دائرة البوصلة
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.orange.withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                        ),
                        // سهم اتجاه القبلة
                        Transform.rotate(
                          angle: _qiblaDirection * (3.14159265359 / 180),
                          child: Container(
                            width: 200,
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.red],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        // نقطة المركز
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        // علامات الاتجاهات
                        Positioned(
                          top: 10,
                          child: _buildDirectionMarker('N'),
                        ),
                        Positioned(
                          bottom: 10,
                          child: _buildDirectionMarker('S'),
                        ),
                        Positioned(
                          right: 10,
                          child: _buildDirectionMarker('E'),
                        ),
                        Positioned(
                          left: 10,
                          child: _buildDirectionMarker('W'),
                        ),
                      ],
                    ),
                  ),
                  // مؤشر المعايرة
                  if (_isCalibrating)
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(179),
                        shape: BoxShape.circle,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'جاري معايرة البوصلة...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // زر المعايرة
          Container(
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calibrateCompass,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'معايرة البوصلة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionMarker(String direction) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          direction,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}