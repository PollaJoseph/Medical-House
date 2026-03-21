import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:medical_house/Components/MainWrapper.dart';
import 'package:medical_house/Model/SignUpAPIModel.dart';
import 'package:medical_house/Services/ApiService.dart';

class SignUpViewModel extends ChangeNotifier {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();

  String selectedGender = "Male";
  File? profileImage;
  bool isPasswordVisible = false;

  bool isFetchingLocation = false;
  bool isLoading = false;

  String latitude = "0.0";
  String longitude = "0.0";

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    isFetchingLocation = true;
    locationController.text = "Locating...";
    notifyListeners();

    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          locationController.text = "GPS Disabled";
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          locationController.text = "Permission Denied";
          return;
        }
      }

      locationData = await location.getLocation();

      latitude = locationData.latitude.toString();
      longitude = locationData.longitude.toString();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String subLocality = place.subLocality ?? "";
        String adminArea = place.administrativeArea ?? "";

        if (subLocality.isNotEmpty && adminArea.isNotEmpty) {
          locationController.text = "$subLocality, $adminArea";
        } else {
          locationController.text = place.locality ?? "Location Found";
        }
      } else {
        locationController.text = "$latitude, $longitude";
      }
    } catch (e) {
      debugPrint("Location Error: $e");
      locationController.text = "Failed to get location";
    } finally {
      isFetchingLocation = false;
      notifyListeners();
    }
  }

  void updateLocationString(
    String address, {
    String lat = "0.0",
    String lng = "0.0",
  }) {
    locationController.text = address;
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  Future<void> registerUser(BuildContext context) async {
    if (firstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      String fullName =
          "${firstNameController.text.trim()} ${lastNameController.text.trim()}";

      final newUser = SignUpAPIModel(
        username: fullName,
        age: ageController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        password: passwordController.text,
        gender: selectedGender,
        email: emailController.text.trim(),
        latitude: latitude,
        longitude: longitude,
        imageFile: profileImage,
      );

      final response = await _apiService.signUp(newUser);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account Created Successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          /* Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainWrapper()),
            (route) => false,
          );*/
        }
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      // Handle Failure
      debugPrint("Registration Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registration Failed: ${e.toString().replaceAll('Exception: ', '')}",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // 7. Stop Loading
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    ageController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
