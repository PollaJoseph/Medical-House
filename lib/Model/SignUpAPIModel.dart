import 'dart:io';
import 'package:dio/dio.dart';

class SignUpAPIModel {
  final String username;
  final String age;
  final String phoneNumber;
  final String password;
  final String gender;
  final String email;
  final String latitude;
  final String longitude;
  final File? imageFile;

  SignUpAPIModel({
    required this.username,
    required this.age,
    required this.phoneNumber,
    required this.password,
    required this.gender,
    required this.email,
    required this.latitude,
    required this.longitude,
    this.imageFile,
  });

  String get locationJson => '{"Latitude": $latitude, "Longitude": $longitude}';

  Future<FormData> toFormData() async {
    FormData formData = FormData.fromMap({
      "Username": username,
      "Age": age,
      "PhoneNumber": phoneNumber,
      "Password": password,
      "Gender": gender,
      "Location": locationJson,
      "Email": email,
    });

    if (imageFile != null) {
      String fileName = imageFile!.path.split('/').last;
      formData.files.add(
        MapEntry(
          "Image",
          await MultipartFile.fromFile(imageFile!.path, filename: fileName),
        ),
      );
    }

    return formData;
  }
}
