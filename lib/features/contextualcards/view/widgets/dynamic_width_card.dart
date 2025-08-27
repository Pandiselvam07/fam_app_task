import 'dart:math' as math;
import 'package:famapp/core/helpers/color_utils.dart';
import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';
import '../../model/contextual_card_model.dart';

class DynamicWidthCard extends StatelessWidget {
  final ContextualCard card;
  final int index;

  const DynamicWidthCard({required this.card, super.key, required this.index});

  double _getWidthForCard() {
    if (index % 4 == 0) return 75;
    if (index % 3 == 0) return 125;
    if (index % 2 == 0) return 150;
    return 120;
  }

  @override
  Widget build(BuildContext context) {
    if (card.bgGradient == null || card.bgGradient!.colors.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => UrlHandler.handleTap(card.url),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: _getWidthForCard().toDouble(),
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
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: card.title != null && card.title!.isNotEmpty
                ? Text(
                    card.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
