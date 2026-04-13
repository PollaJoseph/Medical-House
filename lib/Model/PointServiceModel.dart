class PointServiceModel {
  final String serviceId;
  final String name;
  final String description;
  final String points;
  final String image;
  final String tag;

  PointServiceModel({
    required this.serviceId,
    required this.name,
    required this.description,
    required this.points,
    required this.image,
    required this.tag,
  });

  factory PointServiceModel.fromJson(Map<String, dynamic> json) {
    return PointServiceModel(
      serviceId: json['ServiceID'] ?? '',
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
      points: json['Points']?.toString() ?? '0',
      image: json['Image'] ?? '',
      tag: json['Tag'] ?? '',
    );
  }
}
