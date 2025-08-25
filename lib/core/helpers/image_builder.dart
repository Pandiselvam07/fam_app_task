import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/contextualcards/model/card_image_model.dart';

class ImageBuilder {
  static Widget buildImage(CardImage cardImage, double width, double height) {
    if (cardImage.imageType == 'external' && cardImage.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: cardImage.imageUrl!,
        width: width == double.infinity ? null : width,
        height: height == double.infinity ? null : height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width == double.infinity ? null : width,
          height: height == double.infinity ? null : height,
          color: Colors.grey[300],
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) {
          print('CachedNetworkImage error: $error');
          print('Failed URL: $url');
          return Container(
            width: width == double.infinity ? null : width,
            height: height == double.infinity ? null : height,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red),
                Text(
                  'Failed to load image',
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
