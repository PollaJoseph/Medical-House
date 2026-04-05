import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Components/OfferCard.dart';
import 'package:medical_house/View/CategoryOffersView.dart';

class OfferSection extends StatelessWidget {
  final String title;
  final List<ServiceModel> offers;
  final Function(ServiceModel) onOfferTap;

  const OfferSection({
    super.key,
    required this.title,
    required this.offers,
    required this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inside OfferSection.dart
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align button with multi-line text
            children: [
              // 1. Wrap Text in Expanded to allow multi-line wrapping
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Constants.MidnightNavy,
                    height:
                        1.2, // Added line height for better readability when wrapped
                  ),
                  // maxLines: 2, // Optional: limit to 2 lines if desired
                  softWrap: true, // Ensures the text wraps to a new line
                ),
              ),
              SizedBox(
                width: 12.w,
              ), // Add spacing so text doesn't touch the button

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryOffersView(
                        categoryName: title,
                        offers: offers,
                      ),
                    ),
                  );
                },
                child: Text(
                  "See All".tr,
                  style: TextStyle(
                    color: Constants.PrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 320.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 24.w, bottom: 10.h),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              return OfferCard(
                offer: offers[index],
                onTap: () => onOfferTap(offers[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
