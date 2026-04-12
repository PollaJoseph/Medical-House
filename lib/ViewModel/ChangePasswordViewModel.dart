import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medical_house/Components/CustomSnackBar.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/View/LoginView.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    isConfirmVisible = !isConfirmVisible;
    notifyListeners();
  }

  Future<void> updatePassword(
    BuildContext context,
    String email,
    String newPassword,
  ) async {
    if (passwordController.text != confirmPasswordController.text) {
      CustomSnackBar.showError(
        context,
        title: 'Validation Error'.tr,
        message: 'Passwords do not match'.tr,
      );
      return;
    }

    if (newPassword.length < 8) {
      CustomSnackBar.showWarning(
        context,
        title: 'Weak Password'.tr,
        message: 'Password must be at least 8 characters long'.tr,
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.resetPassword(email, newPassword);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          CustomSnackBar.showSuccess(
            context,
            title: "Password Updated".tr,
            message:
                "Your password has been changed successfully. Please login.".tr,
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        debugPrint('Reset Password error: $e');

        String cleanMessage = e.toString().contains('error')
            ? "Could not reset password. Try again.".tr
            : e
                  .toString()
                  .split(':')
                  .last
                  .replaceAll('{', '')
                  .replaceAll('}', '')
                  .trim();

        CustomSnackBar.showError(
          context,
          title: 'Reset Failed'.tr,
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
