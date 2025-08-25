import 'package:flutter/material.dart';
import '../../features/contextualcards/model/gradient_model.dart';
import 'color_utils.dart';

class GradientBuilder {
  static LinearGradient buildGradient(GradientData gradient) {
    return LinearGradient(
      colors: gradient.colors
          .map((color) => ColorUtils.parseColor(color)!)
          .toList(),
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      transform: GradientRotation(gradient.angle * (3.14159 / 180)),
    );
  }
}
