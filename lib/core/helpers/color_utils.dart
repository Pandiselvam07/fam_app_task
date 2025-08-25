import 'package:flutter/material.dart';

class ColorUtils {
  static Color? parseColor(String? colorString) {
    if (colorString == null) return null;
    String hexColor = colorString.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
