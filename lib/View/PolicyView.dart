import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';

class PolicyView extends StatelessWidget {
  const PolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.PrimaryColor.withOpacity(
                  0.05,
                ), // Very subtle accent
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroHeader(),
                      SizedBox(height: 32.h),

                      _buildPolicyCard(),

                      SizedBox(height: 40.h),
                      _buildFooterInfo(),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Constants.MidnightNavy,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        "Policy and Privacy".tr,
        style: GoogleFonts.lexend(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Constants.MidnightNavy,
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Constants.PrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            "LEGAL".tr,
            style: TextStyle(
              color: Constants.PrimaryColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          "Privacy Statement".tr,
          style: GoogleFonts.lexend(
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
            color: Constants.MidnightNavy,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.blueGrey.shade50), // Subtle border
        boxShadow: [
          BoxShadow(
            color: Constants.MidnightNavy.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPolicySection(
            "Information Collection".tr,
            "The Application collects data when you download and use it, including IP addresses and usage patterns."
                .tr,
            Icons.data_usage_rounded,
          ),
          _buildDivider(),
          _buildPolicySection(
            "Location Services".tr,
            "We use geolocation to provide personalized healthcare recommendations and improve our medical services."
                .tr,
            Icons.location_on_rounded,
          ),
          _buildDivider(),
          _buildPolicySection(
            "Data Security".tr,
            "Medical House provides physical, electronic, and procedural safeguards to protect patient confidentiality."
                .tr,
            Icons.security_rounded,
          ),
          _buildDivider(),
          _buildPolicySection(
            "User Rights".tr,
            "You can stop all data collection by uninstalling the app. For data deletion, contact info@medicalhouse.net."
                .tr,
            Icons.person_search_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(String title, String body, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Constants.PrimaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Constants.PrimaryColor, size: 22.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Constants.MidnightNavy,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: Colors.blueGrey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(color: Colors.blueGrey.shade50, thickness: 1),
    );
  }

  Widget _buildFooterInfo() {
    return Center(
      child: Column(
        children: [
          Text(
            "Effective Date: 2026-04-26".tr,
            style: TextStyle(color: Colors.blueGrey[300], fontSize: 11.sp),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Constants.MidnightNavy,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              "info@medicalhouse.net",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
