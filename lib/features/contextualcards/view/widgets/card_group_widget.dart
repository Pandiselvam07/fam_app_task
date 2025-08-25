import 'package:famapp/features/contextualcards/view/widgets/small_card_with_arrow.dart';
import 'package:famapp/features/contextualcards/view/widgets/small_display_card.dart';
import 'package:flutter/material.dart';

import '../../model/card_group_model.dart';
import '../../model/contextual_card_model.dart';
import 'big_display_card.dart';
import 'dynamic_width_card.dart';
import 'image_card_widget.dart';

class CardGroupWidget extends StatelessWidget {
  final CardGroup cardGroup;
  final Function(String, bool) onDismissCard;

  const CardGroupWidget({required this.cardGroup, required this.onDismissCard});

  @override
  Widget build(BuildContext context) {
    if (cardGroup.isScrollable && cardGroup.designType != 'HC9') {
      return Container(
        height: _getCardHeight(cardGroup.designType),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cardGroup.cards.length,
          itemBuilder: (context, index) {
            return Container(
              width: _getCardWidth(cardGroup.designType),
              margin: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == cardGroup.cards.length - 1 ? 16 : 8,
              ),
              child: _buildCard(cardGroup.cards[index], cardGroup.designType),
            );
          },
        ),
      );
    } else if (cardGroup.designType == 'HC9') {
      return Container(
        height: cardGroup.height?.toDouble() ?? 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cardGroup.cards.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == cardGroup.cards.length - 1 ? 16 : 8,
                top: 16,
                bottom: 16,
              ),
              child: _buildCard(cardGroup.cards[index], cardGroup.designType),
            );
          },
        ),
      );
    } else {
      return Row(
        children: cardGroup.cards
            .asMap()
            .entries
            .map(
              (entry) => Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: _buildCard(entry.value, cardGroup.designType),
                ),
              ),
            )
            .toList(),
      );
    }
  }

  double _getCardHeight(String designType) {
    switch (designType) {
      case 'HC1':
        return 60;
      case 'HC3':
        return 350;
      case 'HC5':
        return 120;
      case 'HC6':
        return 60;
      default:
        return 100;
    }
  }

  double _getCardWidth(String designType) {
    switch (designType) {
      case 'HC1':
        return 175;
      case 'HC3':
        return 300;
      case 'HC5':
        return 120;
      case 'HC6':
        return 150;
      default:
        return 150;
    }
  }

  Widget _buildCard(ContextualCard card, String designType) {
    switch (designType) {
      case 'HC1':
        return SmallDisplayCard(card: card);
      case 'HC3':
        return BigDisplayCard(card: card, onDismiss: onDismissCard);
      case 'HC5':
        return ImageCard(card: card);
      case 'HC6':
        return SmallCardWithArrow(card: card);
      case 'HC9':
        return DynamicWidthCard(card: card);
      default:
        return Container();
    }
  }
}
