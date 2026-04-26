import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white theme
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
                color: Constants.PrimaryColor.withOpacity(0.05),
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
                      // 2. Page Header
                      _buildHeader(),
                      SizedBox(height: 32.h),

                      // 3. Terms Content Card
                      _buildTermsCard(),

                      SizedBox(height: 40.h),
                      _buildFooter(),
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
        "Terms and Conditions".tr, //
        style: GoogleFonts.lexend(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Constants.MidnightNavy,
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          "Usage Agreement".tr,
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

  Widget _buildTermsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.blueGrey.shade50),
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
          _buildTermSection(
            "1. Acceptance".tr,
            "By downloading or using the Medical House app, you agree to be bound by these Terms and Conditions."
                .tr,
            Icons.task_alt_rounded,
          ),
          _buildDivider(),
          _buildTermSection(
            "2. Medical Disclaimer".tr,
            "App content is for informational purposes only and is not a substitute for professional medical advice."
                .tr,
            Icons.medical_information_rounded,
          ),
          _buildDivider(),
          _buildTermSection(
            "3. Appointments".tr,
            "Bookings are subject to availability. Please notify us 24 hours in advance for cancellations."
                .tr,
            Icons.event_available_rounded,
          ),
          _buildDivider(),
          _buildTermSection(
            "4. Privacy".tr,
            "All personal and medical data is handled in accordance with local regulations in Saudi Arabia."
                .tr,
            Icons.gpp_good_rounded,
          ),
          _buildDivider(),
          _buildTermSection(
            "5. Pricing".tr,
            "Pricing displayed in the app is an estimate until confirmed during your consultation at the center."
                .tr,
            Icons.payments_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildTermSection(String title, String body, IconData icon) {
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

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            "Last Updated: 2026-04-26".tr,
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
