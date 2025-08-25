import 'call_to_action_model.dart';
import 'card_image_model.dart';
import 'formatted_text_model.dart';
import 'gradient_model.dart';

class ContextualCard {
  final String name;
  final FormattedText? formattedTitle;
  final String? title;
  final FormattedText? formattedDescription;
  final String? description;
  final CardImage? icon;
  final String? url;
  final CardImage? bgImage;
  final String? bgColor;
  final GradientData? bgGradient;
  final List<CallToAction> cta;

  ContextualCard({
    required this.name,
    this.formattedTitle,
    this.title,
    this.formattedDescription,
    this.description,
    this.icon,
    this.url,
    this.bgImage,
    this.bgColor,
    this.bgGradient,
    required this.cta,
  });

  factory ContextualCard.fromJson(Map<String, dynamic> json) {
    return ContextualCard(
      name: json['name'] ?? '',
      formattedTitle: json['formatted_title'] != null
          ? FormattedText.fromJson(json['formatted_title'])
          : null,
      title: json['title'],
      formattedDescription: json['formatted_description'] != null
          ? FormattedText.fromJson(json['formatted_description'])
          : null,
      description: json['description'],
      icon: json['icon'] != null ? CardImage.fromJson(json['icon']) : null,
      url: json['url'],
      bgImage: json['bg_image'] != null
          ? CardImage.fromJson(json['bg_image'])
          : null,
      bgColor: json['bg_color'],
      bgGradient: json['bg_gradient'] != null
          ? GradientData.fromJson(json['bg_gradient'])
          : null,
      cta:
          (json['cta'] as List<dynamic>?)
              ?.map((e) => CallToAction.fromJson(e))
              .toList() ??
          [],
    );
  }
}
