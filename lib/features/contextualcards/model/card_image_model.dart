class CardImage {
  final String imageType;
  final String? assetType;
  final String? imageUrl;

  CardImage({required this.imageType, this.assetType, this.imageUrl});

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      imageType: json['image_type'] ?? '',
      assetType: json['asset_type'],
      imageUrl: json['image_url'],
    );
  }
}
