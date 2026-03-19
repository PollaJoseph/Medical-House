import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:medical_house/View/HomeView.dart';

class SignUpViewModel extends ChangeNotifier {
  // Form Controllers
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

  // NEW: Loading state for GPS
  bool isFetchingLocation = false;

  final ImagePicker _picker = ImagePicker();

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
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
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Clean formatting, avoiding nulls
        String subLocality = place.subLocality ?? "";
        String adminArea = place.administrativeArea ?? "";

        if (subLocality.isNotEmpty && adminArea.isNotEmpty) {
          locationController.text = "$subLocality, $adminArea";
        } else {
          locationController.text = place.locality ?? "Location Found";
        }
      } else {
        locationController.text =
            "${locationData.latitude}, ${locationData.longitude}";
      }
    } catch (e) {
      debugPrint("Location Error: $e");
      locationController.text = "Failed to get location";
    } finally {
      isFetchingLocation = false;
      notifyListeners();
    }
  }

  void updateLocationString(String address) {
    locationController.text = address;
    notifyListeners();
  }

  void registerUser(BuildContext context) {
    debugPrint("Registering: ${firstNameController.text}");
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (route) => false,
      );
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
