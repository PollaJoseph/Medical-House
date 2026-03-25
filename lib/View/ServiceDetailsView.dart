import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/OfferModel.dart';

class ServiceDetailsView extends StatelessWidget {
  final OfferModel service;

  const ServiceDetailsView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Scrollable Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      SizedBox(height: 24.h),
                      _buildDescriptionSection(),
                      SizedBox(height: 120.h), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. Bottom Sticky Booking Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 350.h,
      backgroundColor: Constants.MidnightNavy,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.r)),
          child: service.imageUrl.startsWith('http')
              ? Image.network(service.imageUrl, fit: BoxFit.cover)
              : Image.asset(service.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4B4B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            service.discountTag.toUpperCase(),
            style: TextStyle(
              color: const Color(0xFFFF4B4B),
              fontWeight: FontWeight.w900,
              fontSize: 10.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          service.title,
          style: GoogleFonts.lexend(
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: Constants.MidnightNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Service",
          style: GoogleFonts.lexend(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Constants.MidnightNavy,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          service.description,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.blueGrey[400],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 35.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  "${service.price} SAR",
                  style: TextStyle(
                    color: Constants.PrimaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.MidnightNavy,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
