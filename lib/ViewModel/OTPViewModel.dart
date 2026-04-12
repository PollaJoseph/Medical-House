import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:medical_house/Components/CustomSnackBar.dart';
import 'package:medical_house/Model/OTPVerificationModel.dart';
import 'package:medical_house/Model/ResendOTP.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Components/MainWrapper.dart';
import 'package:medical_house/Services/StorageService.dart';
import 'package:medical_house/View/ChangePasswordView.dart';

class OTPViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isVerifying = false;
  bool isResending = false;
  Timer? _timer;
  int secondsRemaining = 60;
  bool canResend = false;

  OTPViewModel() {
    startTimer();
  }

  void startTimer() {
    secondsRemaining = 60;
    canResend = false;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
        canResend = true;
      } else {
        secondsRemaining--;
      }
      notifyListeners();
    });
  }

  Future<void> verifyEmail(
    BuildContext context,
    String email,
    String otpCode,
  ) async {
    if (otpCode.length < 6) return;

    isVerifying = true;
    notifyListeners();

    try {
      final verificationData = EmailVerificationModel(
        email: email,
        authToken: otpCode,
      );

      String? clientId = await StorageService.getUserClientId();

      if (clientId == null) {
        throw Exception("Client ID not found in storage.");
      }

      final response = await _apiService.verifyEmail(
        verificationData,
        clientId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          CustomSnackBar.showSuccess(
            context,
            title: "OTP Verified".tr,
            message: "Your email has been verified.".tr,
          );
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
          title: 'Verification Failed'.tr,
          message: cleanMessage,
        );
      }
    } finally {
      isVerifying = false;
      notifyListeners();
    }
  }

  Future<void> resendCode(BuildContext context, String email) async {
    if (!canResend) return;

    isResending = true;
    notifyListeners();

    try {
      final resendData = ResendOTPModel(email: email);
      final response = await _apiService.resendOTP(resendData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        startTimer();
        if (context.mounted) {
          CustomSnackBar.showSuccess(
            context,
            title: "OTP Resent".tr,
            message: "New code sent!".tr,
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
          title: 'Resend Code Failed'.tr,
          message: cleanMessage,
        );
      }
    } finally {
      isResending = false;
      notifyListeners();
    }
  }

  Future<void> verifyResetCode(
    BuildContext context,
    String email,
    String otpCode,
  ) async {
    if (otpCode.length < 6) return;

    isVerifying = true;
    notifyListeners();

    try {
      final response = await _apiService.verifyResetPasswordOTP(email, otpCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          CustomSnackBar.showSuccess(
            context,
            title: "Code Verified".tr,
            message: "You can now set your new password.".tr,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordView(email: email),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        String cleanMessage = e.toString().contains('Invalid code')
            ? "The code you entered is incorrect".tr
            : "Verification failed. Please try again.".tr;

        CustomSnackBar.showError(
          context,
          title: 'Verification Failed'.tr,
          message: cleanMessage,
        );
      }
    } finally {
      isVerifying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
