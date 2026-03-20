import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  static const PrimaryColor = Color(0xFF3393F0);
  static const SeconadryColor = Color(0xFF0CACBB);
  static const MidnightNavy = Color(0xFF1A1A2E);
  static const Gold = Color(0xFFD4AF37);
  static const WhiteColor = Colors.white;

  static const String LogoImagePath = 'lib/Assets/Images/logo.png';
  static const String Onboarding1ImagePath =
      'lib/Assets/Images/Onboarding-1.png';
  static const String Onboarding2ImagePath =
      'lib/Assets/Images/Onboarding-2.png';
  static const String Onboarding3ImagePath =
      'lib/Assets/Images/Onboarding-3.png';

  static const String AppleIconPath = 'lib/Assets/Icons/apple.png';
  static const String FacebookIconPath = 'lib/Assets/Icons/facebook.png';
  static const String GoogleIconPath = 'lib/Assets/Icons/google.png';
  static const String HomeSelectedIconPath =
      'lib/Assets/Icons/Home-Selected.png';
  static const String HomeUnSelectedIconPath =
      'lib/Assets/Icons/Home-Unselected.png';
  static const String OfferSelectedIconPath =
      'lib/Assets/Icons/Offer-Selected.png';
  static const String OfferUnSelectedIconPath =
      'lib/Assets/Icons/Offer-Unselected.png';
  static const String ArticleSelectedIconPath =
      'lib/Assets/Icons/Artical-Selected.png';
  static const String ArticleUnSelectedIconPath =
      'lib/Assets/Icons/Artical-Unselected.png';
  static const String ProfileSelectedIconPath =
      'lib/Assets/Icons/Profile-Selected.png';
  static const String ProfileUnSelectedIconPath =
      'lib/Assets/Icons/Profile-Unselected.png';

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
