import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_house/Components/OfferSection.dart';
import 'package:medical_house/Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/ViewModel/OfferViewModel.dart';
import 'package:provider/provider.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OffersViewModel(),
      child: Consumer<OffersViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // 1. Modern Header
                      SliverAppBar(
                        expandedHeight: 120.h,
                        floating: true,
                        backgroundColor: const Color(0xFFF8FAFC),
                        elevation: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 16.h,
                          ),
                          title: Text(
                            "Exclusive Offers".tr,
                            style: GoogleFonts.lexend(
                              color: Constants.MidnightNavy,
                              fontWeight: FontWeight.w800,
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                      ),
                      // 2. Dynamic Sections from ViewModel
                      SliverPadding(
                        padding: EdgeInsets.only(top: 10.h),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            String sectionName = viewModel.groupedOffers.keys
                                .elementAt(index);
                            var sectionOffers =
                                viewModel.groupedOffers[sectionName]!;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 25.h),
                              child: OfferSection(
                                title: sectionName,
                                offers: sectionOffers,
                                onOfferTap: (offer) =>
                                    viewModel.onOfferTap(context, offer),
                              ),
                            );
                          }, childCount: viewModel.groupedOffers.length),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
