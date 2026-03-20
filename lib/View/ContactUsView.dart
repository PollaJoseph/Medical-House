import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
/*
class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Premium Palette
    const Color backgroundWhite = Color(0xFFF5F7FA);
    const Color midnightNavy = Color(0xFF0A1325);
    const Color surgicalTeal = Color(0xFF0CACBB);
    const Color whatsappGreen = Color(0xFF25D366);

    return Scaffold(
      backgroundColor: backgroundWhite,
      // Modern Floating Action Row for quick contact
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: "WhatsApp",
                icon: Icons.chat_bubble_rounded,
                color: whatsappGreen,
                onTap: () => debugPrint("Open WhatsApp"),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildActionButton(
                title: "Call Clinic",
                icon: Icons.phone_in_talk_rounded,
                color: midnightNavy,
                onTap: () => debugPrint("Call Standard Number"),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Transparent Header with Glass Back Button
          SliverAppBar(
            backgroundColor: backgroundWhite,
            elevation: 0,
            pinned: true,
            leading: Padding(
              padding: EdgeInsets.all(8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: midnightNavy,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Page Title & Intro Text
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How can we\nhelp you?",
                    style: TextStyle(
                      color: midnightNavy,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Whether you want a medical consultation regarding laser hair removal, or cosmetic dental services, do not hesitate to write to us or visit us at our headquarters.",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. The 24/7 Emergency Hero Card
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 30.h,
                bottom: 20.h,
              ),
              child: Container(
                padding: EdgeInsets.all(28.w),
                decoration: BoxDecoration(
                  color: midnightNavy,
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: midnightNavy.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  // Subtle medical background pattern
                  image: DecorationImage(
                    image: const NetworkImage(
                      "https://www.transparenttextures.com/patterns/cubes.png",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      midnightNavy.withOpacity(0.8),
                      BlendMode.dstIn,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "EMERGENCY?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Available 24 Hours",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Call us in case of emergencies",
                              style: TextStyle(
                                color: Colors.blueGrey[300],
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // 24/7 Icon
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: surgicalTeal.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.support_agent_rounded,
                            color: surgicalTeal,
                            size: 32.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),

                    // The Massive Phone Number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "+920014897",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Text(
                            "(Toll Free)",
                            style: TextStyle(
                              color: surgicalTeal,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Working Hours Card
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: midnightNavy,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Working Hours",
                          style: TextStyle(
                            color: midnightNavy,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Directly translated from your web image
                    _buildTimeRow(
                      "Sat - Thu",
                      "07:00 AM - 05:00 PM",
                      surgicalTeal,
                    ),
                    _buildTimeRow(
                      "Sat - Thu",
                      "07:00 AM - 03:00 PM",
                      surgicalTeal,
                    ), // Second shift from image
                    _buildTimeRow(
                      "Friday",
                      "Closed",
                      Colors.blueGrey.shade300,
                      isClosed: true,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Spacing for Floating Buttons
          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildTimeRow(
    String days,
    String hours,
    Color dotColor, {
    bool isClosed = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Glowing Dot Indicator
          Container(
            margin: EdgeInsets.only(top: 4.h),
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                days,
                style: TextStyle(
                  color: const Color(0xFF0A1325),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                hours,
                style: TextStyle(
                  color: isClosed ? Colors.redAccent : Colors.blueGrey[400],
                  fontSize: 13.sp,
                  fontWeight: isClosed ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100.r), // Stadium pill
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ultra-Premium Palette
    const Color backgroundWhite = Color(0xFFF9FAFC);
    const Color midnightNavy = Color(0xFF070D18); // Almost black, very deep
    const Color surgicalTeal = Color(0xFF0CACBB);
    const Color whatsappGreen = Color(0xFF25D366);

    return Scaffold(
      backgroundColor: backgroundWhite,
      extendBody: true, // Allows the list to scroll behind the floating dock
      // 1. THE DARK GLASS DOCK
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: midnightNavy.withOpacity(0.85),
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: midnightNavy.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDockButton(
                      title: "WhatsApp",
                      icon: Icons.chat_bubble_rounded,
                      color: whatsappGreen,
                      onTap: () => debugPrint("WhatsApp"),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildDockButton(
                      title: "Call Clinic",
                      icon: Icons.phone_in_talk_rounded,
                      color: surgicalTeal,
                      onTap: () => debugPrint("Call"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // 2. AMBIENT BACKGROUND GLOW
          Positioned(
            top: -100.h,
            right: -50.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: surgicalTeal.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Scroll Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Minimal Header
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: midnightNavy,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Massive Modern Typography
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    top: 10.h,
                    bottom: 30.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get in\nTouch.",
                        style: TextStyle(
                          color: midnightNavy,
                          fontSize: 48.sp, // Massive font size
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          letterSpacing: -2, // Tight modern tracking
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Whether it is a laser consultation or a cosmetic dental service, our medical experts are ready to assist you.",
                        style: TextStyle(
                          color: Colors.blueGrey[400],
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. The VIP "Digital Pass" Emergency Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [midnightNavy, const Color(0xFF13223B)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: midnightNavy.withOpacity(0.25),
                          blurRadius: 25,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.r),
                      child: Stack(
                        children: [
                          // Massive Watermark Icon
                          Positioned(
                            right: -30.w,
                            bottom: -30.h,
                            child: Icon(
                              Icons.support_agent_rounded,
                              color: Colors.white.withOpacity(0.03),
                              size: 180.sp,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(28.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Glass Pill
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          100.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6.w,
                                            height: 6.w,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFF4B4B),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            "24/7 EMERGENCY",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_outward_rounded,
                                      color: Colors.white54,
                                      size: 24.sp,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Toll Free Line",
                                      style: TextStyle(
                                        color: Colors.blueGrey[300],
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "+920014897",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 34.sp,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 5. Sleek Timeline Working Hours
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    top: 30.h,
                    bottom: 120.h,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(28.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(
                        color: Colors.blueGrey.shade50,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Working Hours",
                              style: TextStyle(
                                color: midnightNavy,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            // Live Status Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "Cairo Time",
                                style: TextStyle(
                                  color: Colors.blueGrey[500],
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        _buildModernTimeRow(
                          "Sat - Thu",
                          "07:00 AM - 05:00 PM",
                          true,
                        ),
                        _buildDivider(),
                        _buildModernTimeRow(
                          "Sat - Thu",
                          "07:00 AM - 03:00 PM",
                          true,
                        ),
                        _buildDivider(),
                        _buildModernTimeRow("Friday", "Closed", false),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildDockButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTimeRow(String day, String time, bool isOpen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            color: const Color(0xFF070D18),
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: isOpen ? Colors.blueGrey[400] : const Color(0xFFFF4B4B),
            fontSize: 14.sp,
            fontWeight: isOpen ? FontWeight.w600 : FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Divider(color: Colors.blueGrey[50], thickness: 1.5, height: 1),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Immaculate Healthcare Palette
    const Color backgroundWhite = Color(0xFFF8F9FA); // Crisp, clean off-white
    const Color pureWhite = Colors.white;
    const Color midnightNavy = Color(0xFF0F172A); // Very sharp, dark slate/navy
    const Color surgicalTeal = Color(0xFF0CACBB);
    const Color emergencyRed = Color(0xFFE11D48);

    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: midnightNavy,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Contact & Support",
          style: TextStyle(
            color: midnightNavy,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // 1. Clean Intro Header
              Text(
                "How can we\nhelp you today?",
                style: TextStyle(
                  color: midnightNavy,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Whether you need a laser consultation or cosmetic dental services, our medical experts are ready to assist.",
                style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30.h),

              // 2. Quick Action Grid (Call, WhatsApp, Email)
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.phone_in_talk_rounded,
                      title: "Call Us",
                      color: midnightNavy,
                      onTap: () => debugPrint("Call Tapped"),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.chat_bubble_rounded,
                      title: "WhatsApp",
                      color: const Color(0xFF25D366), // WhatsApp Green
                      onTap: () => debugPrint("WhatsApp Tapped"),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.email_rounded,
                      title: "Email",
                      color: surgicalTeal,
                      onTap: () => debugPrint("Email Tapped"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // 3. High-Contrast Emergency Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: surgicalTeal, // Solid medical teal commands trust
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: surgicalTeal.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: pureWhite,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: emergencyRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "24/7 EMERGENCY",
                                style: TextStyle(
                                  color: midnightNavy,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.support_agent_rounded,
                          color: pureWhite.withOpacity(0.8),
                          size: 32.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Toll Free Line",
                      style: TextStyle(
                        color: pureWhite.withOpacity(0.8),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "+920014897",
                      style: TextStyle(
                        color: pureWhite,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // 4. Working Hours Schedule
              Text(
                "Clinic Schedule",
                style: TextStyle(
                  color: midnightNavy,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: pureWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.blueGrey.shade50),
                ),
                child: Column(
                  children: [
                    _buildScheduleRow(
                      "Saturday - Thursday",
                      "07:00 AM - 05:00 PM",
                      true,
                    ),
                    Divider(color: Colors.blueGrey.shade50, height: 24.h),
                    _buildScheduleRow(
                      "Saturday - Thursday",
                      "07:00 AM - 03:00 PM",
                      true,
                    ),
                    Divider(color: Colors.blueGrey.shade50, height: 24.h),
                    _buildScheduleRow("Friday", "Closed", false),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // 5. Clinic Headquarters Map/Location
              Text(
                "Visit Headquarters",
                style: TextStyle(
                  color: midnightNavy,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: pureWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.blueGrey.shade50),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fake Map Image Placeholder
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=800&auto=format&fit=crop", // Abstract map/city texture
                        height: 120.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: surgicalTeal.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: surgicalTeal,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Medical House Main Branch",
                                  style: TextStyle(
                                    color: midnightNavy,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "123 Health Avenue, Medical District",
                                  style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.directions_rounded,
                            color: Colors.blueGrey[300],
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.blueGrey.shade50),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleRow(String day, String time, bool isOpen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            color: Colors.blueGrey[600],
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isOpen
                ? const Color(0xFF0CACBB).withOpacity(0.1)
                : const Color(0xFFE11D48).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            time,
            style: TextStyle(
              color: isOpen ? const Color(0xFF0CACBB) : const Color(0xFFE11D48),
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
