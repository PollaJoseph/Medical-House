import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/HomeModel.dart';
import 'package:medical_house/View/ServiceDetailsView.dart';

class SectionDetailView extends StatelessWidget {
  final HospitalSection section;

  const SectionDetailView({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundWhite = Color(0xFFF5F7FA);
    const Color midnightNavy = Color(0xFF0A1325);
    const Color surgicalTeal = Color(0xFF0CACBB);

    return Scaffold(
      backgroundColor: backgroundWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 350.h,
            pinned: true,
            backgroundColor: midnightNavy,
            elevation: 0,
            stretch: true,
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
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double collapsedHeight =
                    kToolbarHeight + MediaQuery.of(context).padding.top;
                final bool isCollapsed =
                    constraints.biggest.height <= collapsedHeight + 40;

                return FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  centerTitle: true,
                  expandedTitleScale: 1.0,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isCollapsed ? 1.0 : 0.0,
                    child: Text(
                      section.mainTitle.replaceAll('\n', ' '),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(section.imageUrl, fit: BoxFit.cover),
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
                      Positioned(
                        bottom: 24.h,
                        left: 24.w,
                        right: 24.w,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isCollapsed ? 0.0 : 1.0,
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 1. Section Title "Our Services"
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

          // 2. Airbnb-Style Magazine Cards (Duplicates removed & Image handling fixed)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final service = section.subSections[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailsView(
                          service: service,
                          isPointService: false,
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32.r),
                          ),
                          // SAFELY HANDLE NETWORK OR ASSET IMAGES
                          child: service.imageUrl.startsWith('http')
                              ? Image.network(
                                  service.imageUrl,
                                  height: 160.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 160.h,
                                        color: Colors.blueGrey[50],
                                        child: const Icon(
                                          Icons.broken_image_outlined,
                                        ),
                                      ),
                                )
                              : Image.asset(
                                  service.imageUrl,
                                  height: 160.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: section.subSections.length),
            ),
          ),

          // Extra bottom padding
          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
    );
  }
}
