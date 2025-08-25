class CallToAction {
  final String text;
  final String? bgColor;
  final String? url;
  final String? textColor;

  CallToAction({required this.text, this.bgColor, this.url, this.textColor});

  factory CallToAction.fromJson(Map<String, dynamic> json) {
    return CallToAction(
      text: json['text'] ?? '',
      bgColor: json['bg_color'],
      url: json['url'],
      textColor: json['text_color'],
    );
  }
}
