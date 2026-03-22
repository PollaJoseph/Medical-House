import 'package:flutter/material.dart';
import 'package:medical_house/Components/MainWrapper.dart';
import 'package:medical_house/Model/LoginAPIModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> loginUser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final loginData = LoginRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await _apiService.login(loginData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Login successful: ${response.data}");
        StorageService.saveUserClientId(response.data['ClientID']);

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainWrapper(
                UserImage: response.data['Image'],
                Username: response.data['Username'],
                Points: response.data['Points'],
              ),
            ),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
