import 'contextual_card_model.dart';

class CardGroup {
  final String designType;
  final String name;
  final List<ContextualCard> cards;
  final int? height;
  final bool isScrollable;

  CardGroup({
    required this.designType,
    required this.name,
    required this.cards,
    this.height,
    required this.isScrollable,
  });

  factory CardGroup.fromJson(Map<String, dynamic> json) {
    return CardGroup(
      designType: json['design_type'] ?? '',
      name: json['name'] ?? '',
      cards: (json['cards'] as List<dynamic>)
          .map((e) => ContextualCard.fromJson(e))
          .toList(),
      height: json['height'],
      isScrollable: json['is_scrollable'] ?? false,
    );
  }
}
