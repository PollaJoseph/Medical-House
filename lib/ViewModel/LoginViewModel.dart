import 'package:flutter/material.dart';
import 'package:medical_house/Components/MainWrapper.dart';

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
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
