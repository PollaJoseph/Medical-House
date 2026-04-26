class UserProfileModel {
  final String clientId;
  final String username;
  final String email;
  final String phoneNumber;
  final int age;
  final String gender;
  final String location;
  final String points;
  final bool authenticated;
  final String image;
  final String qrCode;
  final bool isActive;
  final bool isStaff;
  final String createdAt;
  final String updatedAt;
  final String lastLogin;

  UserProfileModel({
    required this.clientId,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.location,
    required this.points,
    required this.authenticated,
    required this.image,
    required this.qrCode,
    required this.isActive,
    required this.isStaff,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLogin,
  });

  Map<String, double> parseLocation(String locationStr) {
    try {
      String clean = locationStr
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll("'", "");
      List<String> parts = clean.split(',');

      double lat = double.parse(parts[0].split(':')[1].trim());
      double lng = double.parse(parts[1].split(':')[1].trim());

      return {'lat': lat, 'lng': lng};
    } catch (e) {
      return {'lat': 30.0444, 'lng': 31.2357};
    }
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      clientId: json['ClientID'] ?? '',
      username: json['Username'] ?? 'Unknown User',
      email: json['Email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      age: json['Age'] ?? 0,
      gender: json['Gender'] ?? '',
      location: json['Location'] ?? '',
      points: json['Points'] ?? "0",
      authenticated: json['Authenticated'] ?? false,
      image: json['Image'] ?? '',
      qrCode: json['QrCode'] ?? '',
      isActive: json['IsActive'] ?? true,
      isStaff: json['IsStaff'] ?? false,
      createdAt: json['CreatedAt'] ?? '',
      updatedAt: json['UpdatedAt'] ?? '',
      lastLogin: json['LastLogin'] ?? '',
    );
  }
}
