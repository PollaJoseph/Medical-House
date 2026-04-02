import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/Components/OfferCard.dart';
import 'package:medical_house/View/ServiceDetailsView.dart';

class CategoryOffersView extends StatelessWidget {
  final String categoryName;
  final List<ServiceModel> offers;

  const CategoryOffersView({
    super.key,
    required this.categoryName,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Constants.MidnightNavy,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryName,
          style: GoogleFonts.lexend(
            color: Constants.MidnightNavy,
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20.w),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 320.h,
          mainAxisSpacing: 20.h,
        ),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return OfferCard(
            offer: offers[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsView(
                    service: offers[index],
                    isPointService: false,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
