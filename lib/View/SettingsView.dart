import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // UPDATED: Changed from get/utils.dart to get/get.dart
import 'package:medical_house/Components/SettingsButton.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Localization/LocaleController.dart';
import 'package:medical_house/View/AboutView.dart';
import 'package:medical_house/View/ChangePasswordView.dart';
import 'package:medical_house/View/ContactUsView.dart';
import 'package:medical_house/View/PolicyView.dart';
import 'package:medical_house/View/ProfileView.dart';
import 'package:medical_house/View/TermsView.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _showLanguageBottomSheet(
    BuildContext context,
    LocaleController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // UPDATED: Dynamic Title wrapped in Obx
            Obx(
              () => Text(
                controller.isArabic.value ? "اختر اللغة" : "Select Language",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: Constants.MidnightNavy,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // UPDATED: Wrapped options in Obx to update selection state live
            Obx(
              () => _buildLanguageOption(
                context,
                "English",
                "en_US",
                !controller.isArabic.value,
                () => controller.changeLanguage(const Locale('en', 'US')),
              ),
            ),
            SizedBox(height: 12.h),
            Obx(
              () => _buildLanguageOption(
                context,
                "العربية",
                "ar_EG",
                controller.isArabic.value,
                () => controller.changeLanguage(const Locale('ar', 'EG')),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String code,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        onTap(); // Triggers the LocaleController update
        Navigator.pop(context); // Close bottom sheet
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected ? Constants.MidnightNavy : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? Constants.MidnightNavy
                : Colors.blueGrey.shade50,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Constants.MidnightNavy,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Colors.white)
            else
              Text(
                code.split('_')[0].toUpperCase(),
                style: TextStyle(color: Colors.blueGrey[300]),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color destructiveRed = Color(0xFFFF4B4B);

    // UPDATED: Find the active controller instance instead of creating a new one
    final LocaleController localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: Constants.WhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Settings Header
              Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 20.h,
                  bottom: 20.h,
                ),
                child: Obx(
                  () => Text(
                    // Fallback string if .tr fails
                    localeController.isArabic.value ? "الإعدادات" : "Settings",
                    style: TextStyle(
                      color: Constants.MidnightNavy,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),

              // 2. Premium Profile Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileView()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Constants.MidnightNavy,
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.MidnightNavy.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        backgroundImage: const NetworkImage(
                          "https://ui-avatars.com/api/?name=Ahmed+Hassan&background=0CACBB&color=fff",
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ahmed Hassan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "ahmed.hassan@example.com",
                              style: TextStyle(
                                color: Colors.blueGrey[300],
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 32.w, bottom: 8.h),
                child: Text(
                  "GENERAL",
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // UPDATED: Wrapped in Obx to listen to language changes
              Obx(
                () => SettingsButton(
                  text: localeController.isArabic.value
                      ? "لغة التطبيق"
                      : "App Language",
                  icon: Icons.language_rounded,
                  trailing: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.SeconadryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      localeController.isArabic.value ? "AR" : "EN",
                      style: TextStyle(
                        color: Constants.SeconadryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  onClick: () {
                    // Passed the active controller here
                    _showLanguageBottomSheet(context, localeController);
                  },
                  iconColor: Constants.SeconadryColor,
                  textColor: Constants.MidnightNavy,
                ),
              ),

              SettingsButton(
                text: "Change Password",
                icon: Icons.password,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordView(),
                    ),
                  );
                },
                iconColor: Constants.SeconadryColor,
                textColor: Constants.MidnightNavy,
              ),
              SettingsButton(
                text: "Terms and Conditions",
                icon: Icons.article_outlined,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsView()),
                  );
                },
                iconColor: Constants.SeconadryColor,
                textColor: Constants.MidnightNavy,
              ),
              SettingsButton(
                text: "Policy and Privacy",
                icon: Icons.privacy_tip_outlined,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PolicyView()),
                  );
                },
                iconColor: Constants.SeconadryColor,
                textColor: Constants.MidnightNavy,
              ),
              SettingsButton(
                text: "Contact Us",
                icon: Icons.contact_support_outlined,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsView()),
                  );
                },
                iconColor: Constants.SeconadryColor,
                textColor: Constants.MidnightNavy,
              ),

              SettingsButton(
                text: "About Us",
                icon: Icons.info_outline,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutView()),
                  );
                },
                iconColor: Constants.SeconadryColor,
                textColor: Constants.MidnightNavy,
              ),

              SizedBox(height: 30.h),

              // 5. Destructive Action (Logout)
              SettingsButton(
                text: "Log Out",
                icon: Icons.logout_rounded,
                hideArrow: true, // Arrow hidden for actions
                onClick: () {
                  debugPrint("Logging out...");
                  // TODO: Add logout logic and navigation to LoginView
                },
                iconColor: destructiveRed,
                textColor: destructiveRed,
              ),

              SizedBox(height: 120.h), // Spacing for Bottom Navigation Bar
            ],
          ),
        ),
      ),
    );
  }
}
