class EmailVerificationModel {
  final String email;
  final String authToken;

  EmailVerificationModel({required this.email, required this.authToken});

  Map<String, dynamic> toJson() {
    return {"Email": email, "AuthToken": authToken};
  }
}
