import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/ViewModel/PointServicesViewModel.dart';
import 'package:provider/provider.dart';
import 'package:medical_house/Components/PointServiceSection.dart';

class PointServicesView extends StatelessWidget {
  const PointServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PointServicesViewModel()..loadServices(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Consumer<PointServicesViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Constants.PrimaryColor),
              );
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Text(
                  viewModel.errorMessage ?? "Failed to load rewards.".tr,
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.h,
                  floating: true,
                  backgroundColor: const Color(0xFFF8FAFC).withOpacity(0.9),
                  elevation: 0,
                  stretch: true,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        title: Text(
                          "Redeem Rewards".tr,
                          style: GoogleFonts.lexend(
                            color: Constants.MidnightNavy,
                            fontWeight: FontWeight.w800,
                            fontSize: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 10.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      String sectionName = viewModel.groupedServices.keys
                          .elementAt(index);
                      var sectionServices =
                          viewModel.groupedServices[sectionName]!;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 25.h),
                        child: PointServiceSection(
                          title: sectionName,
                          services: sectionServices,
                          onServiceTap: (service) =>
                              viewModel.onServiceTap(context, service),
                        ),
                      );
                    }, childCount: viewModel.groupedServices.length),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}
