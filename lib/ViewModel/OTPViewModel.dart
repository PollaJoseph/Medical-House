import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medical_house/Model/OTPVerificationModel.dart';
import 'package:medical_house/Model/ResendOTP.dart';
import 'package:medical_house/Services/ApiService.dart';
import 'package:medical_house/Components/MainWrapper.dart';
import 'package:medical_house/Services/StorageService.dart';

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
            backgroundColor: Colors.red,
          ),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("New code sent!"),
              backgroundColor: Color(0xFF1A73E8),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      isResending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
