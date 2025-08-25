import 'package:famapp/core/helpers/color_utils.dart';
import 'package:famapp/core/helpers/image_builder.dart';
import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';

import '../../model/contextual_card_model.dart';

class ImageCard extends StatelessWidget {
  final ContextualCard card;

  ImageCard({required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHandler.handleTap(card.url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: card.bgImage != null
              ? ImageBuilder.buildImage(card.bgImage!, double.infinity, 120)
              : Container(
                  height: 120,
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
