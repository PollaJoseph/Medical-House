import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:medical_house/Components/CustomSnackBar.dart';
import 'package:medical_house/Components/MainWrapper.dart';
import 'package:medical_house/Model/SignUpAPIModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';
import 'package:medical_house/View/OTPView.dart';

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
  bool isGoogleLoading = false;

  String latitude = "0.0";
  String longitude = "0.0";

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

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
    locationController.text = "Locating...".tr;
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
          locationController.text = "GPS Disabled".tr;
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          locationController.text = "Permission Denied".tr;
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
          locationController.text = place.locality ?? "Location Found".tr;
        }
      } else {
        locationController.text = "$latitude, $longitude";
      }
    } catch (e) {
      debugPrint("Location Error: $e");
      locationController.text = "Failed to get location".tr;
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
      CustomSnackBar.showWarning(
        context,
        title: 'Sign Up Failed'.tr,
        message: "Please fill in all required fields".tr,
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
          CustomSnackBar.showSuccess(
            context,
            title: 'Sign Up Successful'.tr,
            message:
                "Welcome to Medical House! Your health journey starts here.".tr,
          );

          StorageService.saveUserClientId(response.data['ClientID'].toString());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPView(email: emailController.text.trim(), Case: 'SignUp'),
            ),
            (route) => false,
          );
        }
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Registration Error: $e");

      if (context.mounted) {
        String errorMessage =
            "Could not create account. Please check your information and try again."
                .tr;

        if (e.toString().contains("Email already registered")) {
          errorMessage = "Email already registered".tr;
        } else if (e.toString().contains("400")) {
          errorMessage =
              "Invalid registration data. Please verify your details.".tr;
        }

        CustomSnackBar.showError(
          context,
          title: 'Sign Up Failed'.tr,
          message: errorMessage,
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    isGoogleLoading = true;
    notifyListeners();

    try {
      await _googleSignIn.initialize(
        serverClientId:
            "501409575553-lcqkolshqackgc1cpb70sbc8436sbbr1.apps.googleusercontent.com",
      );
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      if (googleUser == null) {
        isGoogleLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      String? accessToken;
      try {
        final authorization = await googleUser.authorizationClient
            .authorizeScopes(['email', 'profile']);
        accessToken = authorization.accessToken;
      } catch (e) {
        debugPrint("Explicit authorization failed: $e");
      }

      final String tokenToSend = accessToken ?? idToken ?? "";

      if (tokenToSend.isEmpty) {
        throw Exception("Could not retrieve tokens from Google.");
      }

      final response = await _apiService.googleLogin(tokenToSend);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String djangoToken = response.data['key'];
        debugPrint('Success! Django Token: $djangoToken');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Google Login Successful!"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainWrapper()),
            (route) => false,
          );
        }
      } else {
        throw Exception("Django rejected the token.");
      }
    } catch (e) {
      debugPrint("Google Auth Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Google Login Failed: ${e.toString().replaceAll('Exception: ', '')}",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      await _googleSignIn.signOut();
    } finally {
      isGoogleLoading = false;
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
