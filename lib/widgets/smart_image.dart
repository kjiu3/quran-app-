import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Widget لعرض الصور مع معالجة احترافية للأخطاء والتحميل
class SmartImage extends StatelessWidget {
  final String? imagePath;
  final String? imageUrl;
  final IconData? fallbackIcon;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? iconColor;
  final double iconSize;

  const SmartImage({
    super.key,
    this.imagePath,
    this.imageUrl,
    this.fallbackIcon,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.iconColor,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    // إذا كان هناك مسار صورة محلية
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    // إذا كان هناك رابط صورة من الإنترنت
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    }

    // إذا لم يكن هناك صورة، عرض الأيقونة البديلة
    return _buildFallback();
  }

  /// بناء widget بديل عند فشل تحميل الصورة
  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        fallbackIcon ?? Icons.image_not_supported,
        size: iconSize,
        color: iconColor ?? Colors.grey.shade400,
      ),
    );
  }

  /// بناء widget للتحميل
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(iconColor ?? Colors.orange),
          strokeWidth: 2,
        ),
      ),
    );
  }
}

/// Widget لعرض أيقونة مع خلفية دائرية
class CircularIconWidget extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  const CircularIconWidget({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 60,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.orange.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: iconSize, color: iconColor ?? Colors.orange),
    );
  }
}
