import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/OfferModel.dart';

/*class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onTap;

  const OfferCard({super.key, required this.offer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with Discount Tag
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: Image.network(
                    offer.imageUrl,
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: _buildDiscountTag(offer.discountTag),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lexend(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: Constants.MidnightNavy,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${offer.price} SAR",
                    style: TextStyle(
                      color: Constants.PrimaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
*/

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onTap;

  const OfferCard({super.key, required this.offer, required this.onTap});

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
          mainAxisSize:
              MainAxisSize.min, // Added to prevent vertical stretching
          children: [
            // 1. Image Header
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                  child: SizedBox(
                    height: 145.h, // Slightly increased for better ratio
                    width: double.infinity,
                    child: _buildImage(),
                  ),
                ),
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: _buildModernTag(offer.discountTag),
                ),
              ],
            ),

            // 2. Content Section
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
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
                    offer.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h), // Increased space for a cleaner look
                  // 3. Price & Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Modern Price Pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.PrimaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          "${offer.price} SAR",
                          style: TextStyle(
                            color: Constants.PrimaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize:
                                15.sp, // Reduced slightly to avoid overflow
                          ),
                        ),
                      ),
                      // Minimal Circle Action
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 16.sp,
                          color: Constants.MidnightNavy,
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
    if (offer.imageUrl.isEmpty) {
      return Container(
        color: Colors.blueGrey[50],
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.blueGrey[200],
        ),
      );
    }
    // Updated logic to handle ngrok or absolute URLs more safely
    return offer.imageUrl.contains('http')
        ? Image.network(
            offer.imageUrl,
            fit: BoxFit.cover,
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
        : Image.asset(offer.imageUrl, fit: BoxFit.cover);
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
