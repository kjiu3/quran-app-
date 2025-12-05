import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MushafScreen extends StatefulWidget {
  final int? initialPage;

  const MushafScreen({super.key, this.initialPage});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  // القرآن الكريم يحتوي على 604 صفحة
  static const int totalPages = 604;

  late PageController _controller;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? 1;
    _controller = PageController(initialPage: _currentPage - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // الحصول على رابط صورة الصفحة من API
  String _getPageImageUrl(int pageNumber) {
    // استخدام everyayah.com للصور - مصحف المدينة
    final paddedPage = pageNumber.toString().padLeft(3, '0');
    return 'https://www.everyayah.com/data/quranpages/png/$paddedPage.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المصحف الشريف',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // زر الانتقال إلى صفحة
          IconButton(
            icon: const Icon(Icons.dialpad, color: Colors.white),
            tooltip: 'الانتقال إلى صفحة',
            onPressed: () => _showGoToPageDialog(),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5E6D3), // لون بيج يشبه الورق
      body: Column(
        children: [
          // معلومات الصفحة الحالية في الأعلى
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.withAlpha(30),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book, color: Colors.teal, size: 20),
                const SizedBox(width: 8),
                Text(
                  'الصفحة $_currentPage من $totalPages',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
          ),

          // عرض صفحات المصحف
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: totalPages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index + 1;
                });
              },
              itemBuilder: (context, index) {
                final pageNumber = index + 1;
                final imageUrl = _getPageImageUrl(pageNumber);

                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder:
                            (context, url) => const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: Colors.teal),
                                  SizedBox(height: 16),
                                  Text(
                                    'جاري تحميل الصفحة...',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontFamily: 'Amiri',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'حدث خطأ في تحميل الصفحة',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Amiri',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => setState(() {}),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('إعادة المحاولة'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // أزرار التنقل في الأسفل
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // الصفحة السابقة
                ElevatedButton.icon(
                  onPressed:
                      _currentPage > 1
                          ? () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                          : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('السابقة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),

                // رقم الصفحة
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_currentPage',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                      fontFamily: 'Amiri',
                    ),
                  ),
                ),

                // الصفحة التالية
                ElevatedButton.icon(
                  onPressed:
                      _currentPage < totalPages
                          ? () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                          : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('التالية'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
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

  // حوار الانتقال إلى صفحة
  void _showGoToPageDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'الانتقال إلى صفحة',
              style: TextStyle(fontFamily: 'Amiri'),
              textAlign: TextAlign.center,
            ),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'رقم الصفحة (1 - $totalPages)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  final pageNumber = int.tryParse(controller.text);
                  if (pageNumber != null &&
                      pageNumber >= 1 &&
                      pageNumber <= totalPages) {
                    Navigator.pop(context);
                    _controller.jumpToPage(pageNumber - 1);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('الرجاء إدخال رقم من 1 إلى $totalPages'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('انتقال'),
              ),
            ],
          ),
    );
  }
}
