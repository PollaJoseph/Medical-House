import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Localization/LocaleController.dart';
import 'package:medical_house/Model/ServiceModel.dart';

class OfferCard extends StatelessWidget {
  final ServiceModel offer;
  final VoidCallback onTap;

  const OfferCard({super.key, required this.offer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

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
            // 1. Image Header - Wrapped in a sized container
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              child: SizedBox(
                height: 160.h, // Fixed height to prevent overflow
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand, // Ensures children fill the SizedBox
                  children: [
                    _buildImage(),
                    Positioned(
                      top: 16.h,
                      left: 16.w,
                      child: _buildModernTag(offer.discountTag),
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
                  SizedBox(height: 20.h),
                  // 3. Price & Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. First, find the LocaleController at the start of your build method

                      // 2. Replace the price Container inside the Row
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Constants.PrimaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // The Price Text
                              Text(
                                "${offer.price} ",
                                style: TextStyle(
                                  color: Constants.PrimaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.sp,
                                ),
                              ),

                              // Conditional Logic for Currency
                              localeController.isArabic.value
                                  ? Image.asset(
                                      "lib/Assets/Icons/SAR.png",
                                      height: 14.h, // Scaled to match font size
                                      color: Constants
                                          .PrimaryColor, // Optional: tinted to match theme
                                    )
                                  : Text(
                                      "SAR",
                                      style: TextStyle(
                                        color: Constants.PrimaryColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
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

    // Using BoxFit.cover ensures the image fits the container without distortion
    const BoxFit fitType = BoxFit.cover;

    return offer.imageUrl.contains('http')
        ? Image.network(
            offer.imageUrl,
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
        : Image.asset(offer.imageUrl, fit: fitType);
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
