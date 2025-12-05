import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final CacheManager cacheManager = CacheManager(
    Config(
      'islamic_app_cache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'islamic_app_cache'),
      fileService: HttpFileService(),
    ),
  );

  Future<void> preloadImage(String url) async {
    await cacheManager.downloadFile(url);
  }

  Future<void> clearCache() async {
    await cacheManager.emptyCache();
  }

  Future<bool> isCached(String url) async {
    final fileInfo = await cacheManager.getFileFromCache(url);
    return fileInfo != null;
  }
}