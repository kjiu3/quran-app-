import 'package:flutter/material.dart';

class Feature {
  final String title;
  final String route;
  final String? icon; // asset / network path
  final IconData? materialIcon; // optional material icon

  Feature({
    required this.title,
    required this.route,
    this.icon,
    this.materialIcon,
  }) : assert(icon != null || materialIcon != null,
            'Either icon path or materialIcon must be provided');
}