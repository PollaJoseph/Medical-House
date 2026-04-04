import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/OnboardingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      imageAsset: Constants.Onboarding1ImagePath,
      title: 'Book Clinics Easily'.tr,
      description:
          'Find top-rated clinics, choose your preferred doctor, and book your appointments instantly from your phone.'
              .tr,
    ),
    OnboardingModel(
      imageAsset: Constants.Onboarding2ImagePath,
      title: 'Pay & Earn Points'.tr,
      description:
          'Pay securely through the app and automatically collect loyalty points for every medical appointment you complete.'
              .tr,
    ),
    OnboardingModel(
      imageAsset: Constants.Onboarding3ImagePath,
      title: 'Get Free Consultations'.tr,
      description:
          'Exchange your hard-earned points for free medical consultations and exclusive healthcare benefits.'
              .tr,
    ),
  ];

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
  }
}
