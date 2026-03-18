import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> loginUser(BuildContext context) async {
    // Start loading animation
    isLoading = true;
    notifyListeners();

    // TODO: Add your Firebase/API login logic here
    debugPrint("Logging in with: ${emailController.text}");

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    // TODO: Navigate to HomeView
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
