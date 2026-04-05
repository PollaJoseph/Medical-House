import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

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
                color: Constants.PrimaryColor.withOpacity(0.08),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrandHero(),

                      SizedBox(height: 48.h),

                      _buildUnifiedConceptCard(),

                      SizedBox(height: 32.h),

                      SizedBox(height: 100.h),
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Constants.MidnightNavy,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildBrandHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pioneers of\nHealthcare.".tr,
          style: GoogleFonts.lexend(
            fontSize: 40.sp,
            fontWeight: FontWeight.w900,
            color: Constants.MidnightNavy,
            height: 1.1,
            letterSpacing: -2,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Medical House is Jubail's premier destination for advanced therapeutic and cosmetic care, driven by Saudi excellence."
              .tr,
          style: TextStyle(
            color: Colors.blueGrey[400],
            fontSize: 16.sp,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUnifiedConceptCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Constants.MidnightNavy,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Constants.MidnightNavy.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConceptRow(
            "Our Mission".tr,
            "Providing comprehensive therapeutic and cosmetic services for all family members. We are committed to keeping up with the latest medical technologies to ensure your comfort and safety at every visit."
                .tr,
            Icons.auto_awesome_rounded,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
          ),
          _buildConceptRow(
            "Our Vision".tr,
            "To be the leading and trusted destination in the region for dermatological and dental care. We aim for continuous expansion while maintaining our core values of ensuring complete privacy for all our patients."
                .tr,
            Icons.visibility_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildConceptRow(String title, String body, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Constants.PrimaryColor, size: 24.sp),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lexend(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                body,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
