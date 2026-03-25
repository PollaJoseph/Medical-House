import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/ViewModel/ContactUsViewModel.dart';
import 'package:provider/provider.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color whatsappGreen = Color(0xFF25D366);

    return ChangeNotifierProvider(
      create: (_) => ContactUsViewModel(),
      child: Consumer<ContactUsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Constants.WhiteColor,
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Constants.MidnightNavy.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: Constants.WhiteColor.withOpacity(0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Constants.MidnightNavy.withOpacity(0.3),
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
                            onTap: () => viewModel.launchWhatsApp(),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildDockButton(
                            title: "Call Clinic",
                            icon: Icons.phone_in_talk_rounded,
                            color: Constants.PrimaryColor,
                            onTap: () => viewModel.makePhoneCall(),
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
                // Background Decorative Circle
                Positioned(
                  top: -100.h,
                  right: -50.w,
                  child: Container(
                    width: 300.w,
                    height: 300.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Constants.PrimaryColor.withOpacity(0.15),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),

                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: true,
                      leading: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Constants.WhiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Constants.MidnightNavy,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Get in\nTouch.",
                              style: TextStyle(
                                color: Constants.MidnightNavy,
                                fontSize: 48.sp,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                letterSpacing: -2,
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

                    // Toll Free Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: _buildTollFreeCard(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 24.w,
                          right: 24.w,
                          top: 20.h,
                        ),
                        child: _buildLocationCard(viewModel),
                      ),
                    ),

                    // Working Hours Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 120.h),
                        child: _buildWorkingHoursCard(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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

  Widget _buildTollFreeCard() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Constants.MidnightNavy, Color(0xFF13223B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30.w,
            bottom: -30.h,
            child: Icon(
              Icons.support_agent_rounded,
              color: Constants.WhiteColor.withOpacity(0.03),
              size: 180.sp,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(28.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "24/7 EMERGENCY",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Toll Free Line",
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      "+920014897",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursCard() {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Constants.WhiteColor,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.blueGrey.shade50, width: 2),
      ),
      child: Column(
        children: [
          _buildModernTimeRow("Sat - Thu", "01:00 PM - 09:00 PM", true),
          _buildDivider(),
          _buildModernTimeRow("Friday", "Closed", false),
        ],
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

  Widget _buildDivider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    child: Divider(color: Colors.blueGrey[50], thickness: 1.5),
  );

  // --- UPDATED LOCATION MAP CARD ---
  Widget _buildLocationCard(ContactUsViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.openMap(),
      child: Container(
        height: 200.h, // Fixed height to show the map
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(color: Colors.blueGrey.shade50, width: 2),
          boxShadow: [
            BoxShadow(
              color: Constants.MidnightNavy.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Map Background Image
              Image.asset(
                "lib/Assets/Images/MapImage.jpeg",
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.modulate,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Constants.MidnightNavy.withOpacity(0.9),
                      Constants.MidnightNavy.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.6],
                  ),
                ),
              ),
              // 4. Hospital Info and "Open" Button
              Positioned(
                bottom: 16.h,
                left: 20.w,
                right: 20.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Medical House Hospital",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lexend(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Riyadh, Saudi Arabia",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Open Maps",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.open_in_new_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
