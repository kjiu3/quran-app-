import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/feature.dart';
import '../theme/styles.dart';

class FeatureCard extends StatefulWidget {
  final Feature feature;
  final int animationDelay;

  const FeatureCard({
    super.key,
    required this.feature,
    this.animationDelay = 0,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // تأخير بدء الرسوم المتحركة حسب ترتيب البطاقة
    Future.delayed(Duration(milliseconds: 50 * widget.animationDelay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget leadingWidget =
        widget.feature.materialIcon != null
            ? Icon(
              widget.feature.materialIcon,
              size: 52,
              color: Theme.of(context).primaryColor,
            )
            : (widget.feature.icon != null &&
                widget.feature.icon!.startsWith('http'))
            ? CachedNetworkImage(
              imageUrl: widget.feature.icon!,
              height: 52,
              width: 52,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
            : widget.feature.icon != null
            ? Image.asset(
              widget.feature.icon!,
              height: 52,
              width: 52,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
            )
            : const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
            boxShadow: [
              BoxShadow(
                color:
                    _isPressed
                        ? Colors.orange.withAlpha(80)
                        : Colors.grey.withAlpha(50),
                spreadRadius: _isPressed ? 2 : 1,
                blurRadius: _isPressed ? 12 : 6,
                offset: Offset(0, _isPressed ? 6 : 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, widget.feature.route),
              borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
              splashColor: Colors.orange.withAlpha(50),
              highlightColor: Colors.orange.withAlpha(30),
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // حاوية الأيقونة مع تأثير الخلفية
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: leadingWidget,
                    ),
                    const SizedBox(height: AppStyles.smallPadding),
                    Text(
                      widget.feature.title,
                      style: AppStyles.subtitleStyle(context),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
