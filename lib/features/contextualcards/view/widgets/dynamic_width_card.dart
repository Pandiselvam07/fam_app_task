import 'package:famapp/core/helpers/color_utils.dart';
import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';

import '../../model/contextual_card_model.dart';

class DynamicWidthCard extends StatelessWidget {
  final ContextualCard card;

  const DynamicWidthCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHandler.handleTap(card.url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: card.bgImage != null
              ? Image.network(
                  card.bgImage!.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 150,
                      color: Colors.grey,
                      child: Center(child: Icon(Icons.error)),
                    );
                  },
                )
              : Container(
                  width: 150,
                  color: ColorUtils.parseColor(card.bgColor) ?? Colors.grey,
                  child: Center(
                    child: card.title != null
                        ? Text(card.title!)
                        : Icon(Icons.image),
                  ),
                ),
        ),
      ),
    );
  }
}
