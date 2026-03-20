import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Components/SettingsButton.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/View/ContactUsView.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium Palette
    const Color destructiveRed = Color(0xFFFF4B4B);

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
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: Constants.MidnightNavy,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ),

              // 2. Premium Profile Card
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
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
                      // Replace with real user image network URL
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

              SizedBox(height: 20.h),

              // 3. Section Label
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

              // 4. Settings Options
              SettingsButton(
                text: "Account & Profile",
                icon: Icons.person_rounded,
                onClick: () {
                  debugPrint("Navigate to Profile");
                },
                iconColor: Constants.SeconadryColor,
                textColor: Constants.MidnightNavy,
              ),

              SettingsButton(
                text: "Contact Us",
                icon: Icons.info_outline_rounded,
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
                text: "About Medical House",
                icon: Icons.info_outline_rounded,
                onClick: () {
                  debugPrint("Navigate to About");
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
