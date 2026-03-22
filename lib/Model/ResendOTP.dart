class ResendOTPModel {
  final String email;

  ResendOTPModel({required this.email});

  Map<String, dynamic> toJson() {
    return {"Email": email};
  }
}
