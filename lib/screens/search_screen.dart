import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../models/search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showFilterSheet(BuildContext context, SearchProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'فلاتر البحث',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.resetFilter();
                            Navigator.pop(context);
                          },
                          child: const Text('إعادة تعيين'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Scope Filter
                    const Text(
                      'نطاق البحث',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        _buildScopeChip(
                          context,
                          provider,
                          setModalState,
                          SearchScope.all,
                          'كل القرآن',
                          Icons.menu_book,
                        ),
                        _buildScopeChip(
                          context,
                          provider,
                          setModalState,
                          SearchScope.meccan,
                          'السور المكية',
                          Icons.location_city,
                        ),
                        _buildScopeChip(
                          context,
                          provider,
                          setModalState,
                          SearchScope.medinan,
                          'السور المدنية',
                          Icons.mosque,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Juz Filter
                    const Text(
                      'الجزء',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 31, // 0 = All, 1-30 = Juz numbers
                        itemBuilder: (context, index) {
                          final isSelected =
                              index == 0
                                  ? provider.filter.juzNumber == null
                                  : provider.filter.juzNumber == index;
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ChoiceChip(
                              label: Text(index == 0 ? 'الكل' : '$index'),
                              selected: isSelected,
                              selectedColor: Colors.orange,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              onSelected: (selected) {
                                setModalState(() {
                                  provider.updateFilter(
                                    provider.filter.copyWith(
                                      juzNumber: index == 0 ? null : index,
                                    ),
                                  );
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'تطبيق',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildScopeChip(
    BuildContext context,
    SearchProvider provider,
    StateSetter setModalState,
    SearchScope scope,
    String label,
    IconData icon,
  ) {
    final isSelected = provider.filter.scope == scope;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : Colors.orange,
      ),
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.orange,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (selected) {
        setModalState(() {
          provider.updateFilter(provider.filter.copyWith(scope: scope));
        });
      },
    );
  }

  bool _hasActiveFilters(SearchProvider provider) {
    return provider.filter.scope != SearchScope.all ||
        provider.filter.juzNumber != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البحث في القرآن',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Consumer<SearchProvider>(
            builder: (context, provider, child) {
              final hasFilters = _hasActiveFilters(provider);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () => _showFilterSheet(context, provider),
                    tooltip: 'فلاتر البحث',
                  ),
                  if (hasFilters)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          return Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'ابحث في القرآن الكريم...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.orange,
                        ),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    searchProvider.clearResults();
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
                      onChanged: (value) {
                        setState(() {});
                        if (value.trim().isNotEmpty) {
                          searchProvider.searchInQuran(value);
                        } else {
                          searchProvider.clearResults();
                        }
                      },
                      textDirection: TextDirection.rtl,
                    ),
                    // Active Filters Display
                    if (_hasActiveFilters(searchProvider))
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_alt,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getFilterDescription(searchProvider.filter),
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => searchProvider.resetFilter(),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Results or Loading or Empty State
              Expanded(child: _buildBody(searchProvider)),
            ],
          );
        },
      ),
    );
  }

  String _getFilterDescription(SearchFilter filter) {
    List<String> parts = [];
    if (filter.scope == SearchScope.meccan) {
      parts.add('السور المكية');
    } else if (filter.scope == SearchScope.medinan) {
      parts.add('السور المدنية');
    }
    if (filter.juzNumber != null) {
      parts.add('الجزء ${filter.juzNumber}');
    }
    return parts.join(' • ');
  }

  Widget _buildBody(SearchProvider searchProvider) {
    if (searchProvider.isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 16),
            Text('جاري البحث...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (_searchController.text.trim().isEmpty) {
      return _buildRecentSearches(searchProvider);
    }

    if (!searchProvider.hasResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لم يتم العثور على نتائج',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'جرب كلمات بحث أخرى أو غيّر الفلاتر',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'النتائج: ${searchProvider.results.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchProvider.results.length,
            itemBuilder: (context, index) {
              final result = searchProvider.results[index];
              return _buildResultItem(result, searchProvider.query);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearches(SearchProvider searchProvider) {
    if (searchProvider.recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'ابحث في القرآن الكريم',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'اكتب كلمة أو جملة للبحث عنها',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'عمليات البحث الأخيرة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () => searchProvider.clearRecentSearches(),
                child: const Text('مسح الكل'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchProvider.recentSearches.length,
            itemBuilder: (context, index) {
              final search = searchProvider.recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.orange),
                title: Text(
                  search,
                  style: const TextStyle(fontSize: 16),
                  textDirection: TextDirection.rtl,
                ),
                onTap: () {
                  _searchController.text = search;
                  searchProvider.searchInQuran(search);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(SearchResult result, String query) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to Tafsir screen with the selected verse
          Navigator.pushNamed(
            context,
            '/tafsir',
            arguments: {
              'surahNumber': result.surahNumber,
              'verseNumber': result.verseNumber,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Surah and Verse Number
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${result.surahName} - آية ${result.verseNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Verse Text with Highlighting
              RichText(
                text: _buildHighlightedText(result.text, query),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _buildHighlightedText(String text, String query) {
    if (query.trim().isEmpty) {
      return TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
          height: 1.8,
        ),
      );
    }

    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        // Add remaining text
        if (start < text.length) {
          spans.add(
            TextSpan(
              text: text.substring(start),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                height: 1.8,
              ),
            ),
          );
        }
        break;
      }

      // Add text before match
      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              height: 1.8,
            ),
          ),
        );
      }

      // Add highlighted match
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            backgroundColor: Colors.orange,
            fontWeight: FontWeight.bold,
            height: 1.8,
          ),
        ),
      );

      start = index + query.length;
    }

    return TextSpan(children: spans);
  }
}
