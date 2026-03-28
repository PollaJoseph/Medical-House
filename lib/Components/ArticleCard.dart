import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleCard extends StatelessWidget {
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Constants.MidnightNavy,
                const Color(0xFF1A2E4E), // Deep medical navy
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Constants.MidnightNavy.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32.r),
            child: Stack(
              children: [
                // 1. Abstract Medical Icon Background
                Positioned(
                  right: -20.w,
                  bottom: -20.h,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 150.sp,
                    color: Colors.white.withOpacity(0.03),
                  ),
                ),

                // 2. Main Content
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Health & Wellness",
                              style: GoogleFonts.lexend(
                                color: Constants.PrimaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Discover Daily Tips &\nMedical Articles",
                              style: GoogleFonts.lexend(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 3. Modern Glassmorphism Arrow
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
