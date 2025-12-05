import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';
import '../models/bookmark.dart';
import '../services/share_service.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المفضلات',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (value) {
              final provider = context.read<BookmarkProvider>();
              if (value == 'date') {
                provider.sortByDate();
              } else if (value == 'surah') {
                provider.sortBySurah();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'date',
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 8),
                        Text('ترتيب حسب التاريخ'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'surah',
                    child: Row(
                      children: [
                        Icon(Icons.menu_book),
                        SizedBox(width: 8),
                        Text('ترتيب حسب السورة'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!provider.hasBookmarks) {
            return _buildEmptyState();
          }

          final bookmarks =
              _searchController.text.isEmpty
                  ? provider.bookmarks
                  : provider.searchBookmarks(_searchController.text);

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث في المفضلات...',
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                  textDirection: TextDirection.rtl,
                ),
              ),

              // Bookmarks Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الإجمالي: ${bookmarks.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (provider.bookmarks.length > 1)
                      TextButton.icon(
                        onPressed: () => _showClearDialog(context, provider),
                        icon: const Icon(Icons.delete_sweep, size: 18),
                        label: const Text('مسح الكل'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),

              // Bookmarks List
              Expanded(
                child:
                    bookmarks.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد نتائج',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: bookmarks.length,
                          itemBuilder: (context, index) {
                            final bookmark = bookmarks[index];
                            return _buildBookmarkCard(
                              context,
                              bookmark,
                              provider,
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            'لا توجد إشارات مرجعية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة آيات إلى المفضلات',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    Bookmark bookmark,
    BookmarkProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Surah info and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${bookmark.surahName} - آية ${bookmark.verseNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.green),
                      onPressed:
                          () => ShareService.showShareOptions(
                            context: context,
                            surahNumber: bookmark.surahNumber,
                            verseNumber: bookmark.verseNumber,
                            verseText: bookmark.verseText,
                          ),
                      tooltip: 'مشاركة',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Colors.blue),
                      onPressed:
                          () => _showNoteDialog(context, bookmark, provider),
                      tooltip: 'إضافة ملاحظة',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed:
                          () => _showDeleteDialog(context, bookmark, provider),
                      tooltip: 'حذف',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Verse Text
            Text(
              bookmark.verseText,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                height: 1.8,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),

            // Note if exists
            if (bookmark.note != null && bookmark.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.note, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bookmark.note!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Timestamp
            const SizedBox(height: 8),
            Text(
              'تم الحفظ: ${_formatDate(bookmark.timestamp)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showNoteDialog(
    BuildContext context,
    Bookmark bookmark,
    BookmarkProvider provider,
  ) {
    final controller = TextEditingController(text: bookmark.note);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ملاحظة'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'أضف ملاحظة...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              textDirection: TextDirection.rtl,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.updateBookmarkNote(
                    bookmark.id,
                    controller.text.trim(),
                  );
                  Navigator.pop(context);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Bookmark bookmark,
    BookmarkProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حذف الإشارة'),
            content: const Text('هل أنت متأكد من حذف هذه الإشارة المرجعية؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.removeBookmark(bookmark.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('حذف'),
              ),
            ],
          ),
    );
  }

  void _showClearDialog(BuildContext context, BookmarkProvider provider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('مسح جميع الإشارات'),
            content: const Text(
              'هل أنت متأكد من حذف جميع الإشارات المرجعية؟ لا يمكن التراجع عن هذا الإجراء.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.clearAllBookmarks();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('مسح الكل'),
              ),
            ],
          ),
    );
  }
}
