import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/PointServiceModel.dart';

class PointServiceCard extends StatelessWidget {
  final PointServiceModel service;
  final VoidCallback onTap;

  const PointServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 20.w, bottom: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Constants.MidnightNavy.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Image Header - Fixed height matching OfferCard
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              child: SizedBox(
                height: 160.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(),
                    if (service.tag.isNotEmpty)
                      Positioned(
                        top: 16.h,
                        left: 16.w,
                        child: _buildModernTag(service.tag),
                      ),
                  ],
                ),
              ),
            ),

            // 2. Content Section
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lexend(
                      fontWeight: FontWeight.w800,
                      fontSize: 17.sp,
                      color: Constants.MidnightNavy,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    service.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // 3. Points & Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Points Container
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.stars_rounded,
                              color: const Color(0xFFFFB800),
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "${service.points} Pts",
                              style: TextStyle(
                                color: Constants.MidnightNavy,
                                fontWeight: FontWeight.w900,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Redeem Circular Button
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Constants.MidnightNavy,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.card_giftcard_rounded,
                          size: 16.sp,
                          color: Colors.white,
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
    );
  }

  Widget _buildImage() {
    if (service.image.isEmpty) {
      return Container(
        color: Colors.blueGrey[50],
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.blueGrey[200],
        ),
      );
    }

    const BoxFit fitType = BoxFit.cover;

    return service.image.contains('http')
        ? Image.network(
            service.image,
            fit: fitType,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.blueGrey[50],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.blueGrey[50],
              child: const Icon(Icons.broken_image_outlined),
            ),
          )
        : Image.asset(service.image, fit: fitType);
  }

  Widget _buildModernTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4B4B),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4B4B).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        tag.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 10.sp,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
