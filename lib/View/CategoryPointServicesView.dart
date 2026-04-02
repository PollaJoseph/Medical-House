import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/PointServiceModel.dart';
import 'package:medical_house/Components/PointServiceCard.dart';
import 'package:medical_house/Model/ServiceModel.dart';
import 'package:medical_house/View/ServiceDetailsView.dart';

class CategoryPointServicesView extends StatelessWidget {
  final String categoryName;
  final List<PointServiceModel> services;

  const CategoryPointServicesView({
    super.key,
    required this.categoryName,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueGrey.shade50),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Constants.MidnightNavy,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          categoryName,
          style: GoogleFonts.lexend(
            color: Constants.MidnightNavy,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: services.isEmpty
          ? Center(
              child: Text(
                "No rewards available.",
                style: TextStyle(
                  color: Colors.blueGrey[300],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 24.h),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Center(
                  child: PointServiceCard(
                    service: services[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailsView(
                            service: ServiceModel(
                              id: services[index].serviceId,
                              title: services[index].name,
                              description: services[index].description,
                              price: services[index].points,
                              imageUrl: services[index].image,
                              discountTag: services[index].tag,
                            ),
                            isPointService: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
