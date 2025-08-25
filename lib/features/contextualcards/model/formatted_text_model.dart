class FormattedText {
  final String text;
  final List<Entity> entities;

  FormattedText({required this.text, required this.entities});

  factory FormattedText.fromJson(Map<String, dynamic> json) {
    return FormattedText(
      text: json['text'] ?? '',
      entities:
          (json['entities'] as List<dynamic>?)
              ?.map((e) => Entity.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Entity {
  final String text;
  final String? color;
  final String? url;
  final String? fontStyle;

  Entity({required this.text, this.color, this.url, this.fontStyle});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      text: json['text'] ?? '',
      color: json['color'],
      url: json['url'],
      fontStyle: json['font_style'],
    );
  }
}
