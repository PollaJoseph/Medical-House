class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final String discountTag;
  final String imageUrl;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountTag,
    required this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['ServiceID']?.toString() ?? '',
      title: json['Name'] ?? 'Unnamed Service',
      description: json['Description'] ?? '',
      price: json['Price']?.toString() ?? '0.00',
      discountTag: json['Tag'] ?? 'Standard',
      imageUrl: json['Image'] ?? '',
    );
  }
}
