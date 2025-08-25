import 'package:flutter/material.dart';

import '../../features/contextualcards/model/card_image_model.dart';

class ImageBuilder {
  static Widget buildImage(CardImage cardImage, double width, double height) {
    if (cardImage.imageType == 'external' && cardImage.imageUrl != null) {
      return Image.network(
        cardImage.imageUrl!,
        width: width == double.infinity ? null : width,
        height: height == double.infinity ? null : height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width == double.infinity ? null : width,
            height: height == double.infinity ? null : height,
            color: Colors.grey,
            child: const Icon(Icons.error),
          );
        },
      );
    } else if (cardImage.imageType == 'asset' && cardImage.assetType != null) {
      return Container(
        width: width == double.infinity ? null : width,
        height: height == double.infinity ? null : height,
        color: Colors.grey,
        child: Center(child: Text(cardImage.assetType!)),
      );
    }
    return Container(
      width: width == double.infinity ? null : width,
      height: height == double.infinity ? null : height,
      color: Colors.grey,
      child: const Icon(Icons.image),
    );
  }
}
