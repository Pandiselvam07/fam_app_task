class GradientData {
  final List<String> colors;
  final double angle;

  GradientData({required this.colors, required this.angle});

  factory GradientData.fromJson(Map<String, dynamic> json) {
    return GradientData(
      colors: List<String>.from(json['colors'] ?? []),
      angle: (json['angle'] ?? 0).toDouble(),
    );
  }
}
