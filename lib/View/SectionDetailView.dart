import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/HomeModel.dart'; // Adjust path if needed

class SectionDetailView extends StatelessWidget {
  final HospitalSection section;

  const SectionDetailView({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundWhite = Color(0xFFF5F7FA); // Modern, airy off-white
    const Color midnightNavy = Color(0xFF0A1325); // Deep, luxurious navy
    const Color surgicalTeal = Color(0xFF0CACBB); // Your primary medical teal

    return Scaffold(
      backgroundColor: backgroundWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 2. Cinematic Hero Header
          SliverAppBar(
            expandedHeight: 350.h,
            pinned: true,
            backgroundColor: midnightNavy,
            elevation: 0,
            stretch: true,

            // Glassmorphic Back Button
            leading: Padding(
              padding: EdgeInsets.all(8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(section.imageUrl, fit: BoxFit.cover),
                  // Gradient to make the white text pop perfectly
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          midnightNavy.withOpacity(0.4),
                          Colors.transparent,
                          midnightNavy.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  // Title overlay at the bottom of the image
                  Positioned(
                    bottom: 24.h,
                    left: 24.w,
                    right: 24.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: surgicalTeal.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "VIP CLINIC",
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
                          section.mainTitle.replaceAll('\n', ' '),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Section Title "Available Services"
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 30.h,
                bottom: 20.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Our Services",
                    style: TextStyle(
                      color: midnightNavy,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "${section.subSections.length} Available",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Airbnb-Style Magazine Cards
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final service = section.subSections[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: midnightNavy.withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Massive, beautiful image block
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32.r),
                        ),
                        child: Image.asset(
                          service.imageUrl,
                          height: 160
                              .h, // Large height to show off the clinic/results
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Service Info & Explicit Book Button
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.title,
                                    style: TextStyle(
                                      color: midnightNavy,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.health_and_safety_rounded,
                                        color: surgicalTeal,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "Premium Care",
                                        style: TextStyle(
                                          color: Colors.blueGrey[400],
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 15.w),

                            // Highly explicit "Book" button
                            GestureDetector(
                              onTap: () {
                                debugPrint(
                                  "Booking Specific Service: ${service.title}",
                                );
                                // TODO: Navigate to Service Booking
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  color: midnightNavy,
                                  borderRadius: BorderRadius.circular(100.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: midnightNavy.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "Book",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: section.subSections.length),
            ),
          ),

          // Extra bottom padding so the floating "Book Consultation" bar doesn't cover the last card
          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
    );
  }
}
