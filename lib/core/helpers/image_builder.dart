import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/contextualcards/model/card_image_model.dart';

class ImageBuilder {
  static const Map<String, String> _defaultHeaders = {
    'User-Agent':
        'Mozilla/5.0 (compatible; Flutter app; +http://www.flutter.dev/)',
    'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
    'Accept-Encoding': 'gzip, deflate, br',
    'Cache-Control': 'no-cache',
  };

  static Widget buildImage(CardImage cardImage, double width, double height) {
    if (cardImage.imageType == 'ext' && cardImage.imageUrl != null) {
      final imageUrl = cardImage.imageUrl!;

      return CachedNetworkImage(
        imageUrl: imageUrl,
        httpHeaders: _defaultHeaders,
        width: width == double.infinity ? null : width,
        height: height == double.infinity ? null : height,
        fit: BoxFit.cover,

        placeholder: (context, url) => Container(
          width: width == double.infinity ? null : width,
          height: height == double.infinity ? null : height,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ),

        errorWidget: (context, url, error) {
          return Image.network(
            url,
            headers: _defaultHeaders,
            width: width == double.infinity ? null : width,
            height: height == double.infinity ? null : height,
            fit: BoxFit.cover,

            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: width == double.infinity ? null : width,
                height: height == double.infinity ? null : height,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  ),
                ),
              );
            },

            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width == double.infinity ? null : width,
                height: height == double.infinity ? null : height,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.red[300], size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Image failed to load',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        url.length > 40 ? '${url.substring(0, 37)}...' : url,
                        style: const TextStyle(fontSize: 8, color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Tap to retry',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else if (cardImage.imageType == 'asset' && cardImage.assetType != null) {
      return Container(
        width: width == double.infinity ? null : width,
        height: height == double.infinity ? null : height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, color: Colors.grey[600]),
              const SizedBox(height: 4),
              Text(
                cardImage.assetType!,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Default fallback
    return Container(
      width: width == double.infinity ? null : width,
      height: height == double.infinity ? null : height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image, color: Colors.grey[600], size: 32),
    );
  }

  // Alternative method with retry functionality
  static Widget buildImageWithRetry(
    CardImage cardImage,
    double width,
    double height,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            // Force rebuild to retry image loading
            setState(() {});
          },
          child: buildImage(cardImage, width, height),
        );
      },
    );
  }
}
