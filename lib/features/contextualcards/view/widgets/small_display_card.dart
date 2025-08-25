import 'package:famapp/core/helpers/formatted_text_builder.dart';
import 'package:famapp/core/helpers/image_builder.dart';
import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_utils.dart';
import '../../model/contextual_card_model.dart';

class SmallDisplayCard extends StatelessWidget {
  final ContextualCard card;

  SmallDisplayCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHandler.handleTap(card.url),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorUtils.parseColor(card.bgColor) ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            if (card.icon != null) ...[
              ImageBuilder.buildImage(card.icon!, 24, 24),
              SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (card.formattedTitle != null)
                    FormattedTextBuilder.buildFormattedText(
                      card.formattedTitle!,
                    )
                  else if (card.title != null)
                    Text(
                      card.title!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
