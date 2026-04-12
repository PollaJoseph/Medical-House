import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medical_house/Components/CustomSnackBar.dart';
import 'package:medical_house/Components/MainWrapper.dart';
import 'package:medical_house/Model/LoginAPIModel.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Services/StorageService.dart';
import 'package:medical_house/View/OTPView.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  final ApiService _apiService = ApiService();
  bool isForgotPassLoading = false;

  Future<void> forgotPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      CustomSnackBar.showWarning(
        context,
        title: 'Action Required'.tr,
        message: 'Please enter your email address first'.tr,
      );
      return;
    }

    isForgotPassLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.sendPassword(email);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          CustomSnackBar.showSuccess(
            context,
            title: 'Email Sent'.tr,
            message: 'Password reset instructions have been sent.'.tr,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPView(email: email, Case: 'Forget Password'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          title: 'Request Failed'.tr,
          message: 'Could not process request. Please try again.'.tr,
        );
      }
    } finally {
      // Reset the new variable
      isForgotPassLoading = false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> loginUser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      CustomSnackBar.showWarning(
        title: 'Login Failed'.tr,
        context,
        message: 'Please fill in all fields'.tr,
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
        StorageService.saveUserClientId(response.data['ClientID']);
        CustomSnackBar.showSuccess(
          context,
          title: 'Login Successful'.tr,
          message: "Welcome back to Medical House!".tr,
        );
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
        debugPrint('Login error: $e');
        String cleanMessage = 'An unexpected error occurred'.tr;
        if (e.toString().contains('Invalid email or password')) {
          cleanMessage = 'Invalid email or password'.tr;
        } else if (e.toString().contains('401')) {
          cleanMessage = 'Unauthorized: Please check your credentials'.tr;
        } else {
          cleanMessage = e
              .toString()
              .split(':')
              .last
              .replaceAll('{', '')
              .replaceAll('}', '')
              .trim();
        }

        CustomSnackBar.showError(
          context,
          title: 'Login Failed'.tr,
          message: cleanMessage,
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
