import 'package:flutter/material.dart';
import 'package:medical_house/Model/OnboardingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      imageAsset: 'lib/Assets/Images/Doctors-bro 1.png',
      title: 'Book Clinics Easily',
      description:
          'Find top-rated clinics, choose your preferred doctor, and book your appointments instantly from your phone.',
    ),
    OnboardingModel(
      imageAsset: 'lib/Assets/Images/Mobile payments-pana.png',
      title: 'Pay & Earn Points',
      description:
          'Pay securely through the app and automatically collect loyalty points for every medical appointment you complete.',
    ),
    OnboardingModel(
      imageAsset: 'lib/Assets/Images/Send gift-rafiki 1.png',
      title: 'Get Free Consultations',
      description:
          'Exchange your hard-earned points for free medical consultations and exclusive healthcare benefits.',
    ),
  ];

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Save the flag so this screen never shows again
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
  }
}
