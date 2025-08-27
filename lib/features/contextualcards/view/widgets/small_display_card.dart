import 'package:famapp/core/helpers/formatted_text_builder.dart';
import 'package:famapp/core/helpers/image_builder.dart';
import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_utils.dart';
import '../../model/contextual_card_model.dart';

class SmallDisplayCard extends StatelessWidget {
  final ContextualCard card;

  const SmallDisplayCard({super.key, required this.card});

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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    )
                  else if (card.title != null && card.title!.trim().isNotEmpty)
                    Text(
                      card.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (card.formattedDescription != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: FormattedTextBuilder.buildFormattedText(
                        card.formattedDescription!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.1,
                        ),
                      ),
                    )
                  else if (card.description != null &&
                      card.description!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        card.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
