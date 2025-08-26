import 'dart:math' as math;
import 'package:famapp/core/helpers/color_utils.dart';
import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';
import '../../model/contextual_card_model.dart';

class DynamicWidthCard extends StatelessWidget {
  final ContextualCard card;

  const DynamicWidthCard({required this.card, super.key});
  int _getFlexForCard() {
    String referenceText = '';

    if (card.title != null && card.title!.isNotEmpty) {
      referenceText = card.title!;
    } else if (card.description != null && card.description!.isNotEmpty) {
      referenceText = card.description!;
    } else if (card.url != null && card.url!.isNotEmpty) {
      referenceText = card.url!;
    }
    if (referenceText.length > 15) {
      return 3;
    } else if (referenceText.length > 7) {
      return 2;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    if (card.bgGradient == null || card.bgGradient!.colors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Flexible(
      flex: _getFlexForCard(),
      child: GestureDetector(
        onTap: () => UrlHandler.handleTap(card.url),
        child: Container(
          margin: const EdgeInsets.all(6),
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(
                (card.bgGradient!.angle) * math.pi / 180,
              ),
              colors: card.bgGradient!.colors.map((hex) {
                final color = ColorUtils.parseColor(hex);
                if (color == null) {
                  return Colors.blue.shade300;
                }
                return color;
              }).toList(),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: card.title != null && card.title!.isNotEmpty
                  ? Text(
                      card.title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
