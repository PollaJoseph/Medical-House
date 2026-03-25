class OfferModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final String discountTag;
  final String imageUrl;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountTag,
    required this.imageUrl,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['service_id']?.toString() ?? '',
      title: json['name'] ?? 'Unnamed Service',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0.00',
      discountTag: json['tag'] ?? 'Standard',
      imageUrl: json['image'] ?? '',
    );
  }
}
