import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.lexend(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Constants.MidnightNavy,
                ),
              ),
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
                  "See All",
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
