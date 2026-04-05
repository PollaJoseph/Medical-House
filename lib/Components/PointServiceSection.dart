import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/PointServiceModel.dart';
import 'package:medical_house/Components/PointServiceCard.dart';
import 'package:medical_house/View/CategoryPointServicesView.dart';

class PointServiceSection extends StatelessWidget {
  final String title;
  final List<PointServiceModel> services;
  final Function(PointServiceModel) onServiceTap;

  const PointServiceSection({
    super.key,
    required this.title,
    required this.services,
    required this.onServiceTap,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Constants.MidnightNavy,
                    height: 1.2,
                  ),
                  softWrap: true,
                ),
              ),
              SizedBox(width: 12.w),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPointServicesView(
                        categoryName: title,
                        services: services,
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
          height: 322.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 24.w, bottom: 10.h),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return PointServiceCard(
                service: services[index],
                onTap: () => onServiceTap(services[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
