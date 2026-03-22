import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/HomeModel.dart';
import 'package:provider/provider.dart';
import 'package:medical_house/ViewModel/HomeViewModel.dart';

class HomeView extends StatelessWidget {
  final String? Username;
  final String? UserImage;
  final int? Points;
  const HomeView({super.key, this.Username, this.UserImage, this.Points});

  @override
  Widget build(BuildContext context) {
    const Color backgroundGrey = Color(0xFFF8FAFC);

    return ChangeNotifierProvider(
      create: (_) =>
          HomeViewModel(name: Username, imageUrl: UserImage, points: Points),
      child: Scaffold(
        backgroundColor: backgroundGrey,
        body: Consumer<HomeViewModel>(
          builder: (context, model, _) {
            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Minimal Header
                          _buildMinimalHeader(model, Constants.MidnightNavy),
                          SizedBox(height: 30.h),
                          // 2. NEW: VIP Points Wallet
                          _buildPointsWallet(
                            model,
                            Constants.MidnightNavy,
                            Constants.SeconadryColor,
                          ),
                          SizedBox(height: 35.h),
                          // 3. Section Title
                          Text(
                            "Our Premium Centers",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              color: Constants.MidnightNavy,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                  ),
                  // 4. The 2-Column Portrait Grid
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final section = model.hospitalSections[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: _buildImageCard(context, model, section),
                        );
                      }, childCount: model.hospitalSections.length),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 70.h)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMinimalHeader(HomeViewModel model, Color navy) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 26.r,
              backgroundImage: (model.currentUser.imageUrl.startsWith('http'))
                  ? NetworkImage(model.currentUser.imageUrl) as ImageProvider
                  : AssetImage(model.currentUser.imageUrl),
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint("Image Load Error: $exception");
              },
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back,",
                  style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  model.currentUser.name,
                  style: TextStyle(
                    color: navy,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPointsWallet(HomeViewModel model, Color navy, Color teal) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white, // Sterile clinical white
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: teal.withOpacity(0.2),
          width: 1.5,
        ), // Subtle medical outline
        boxShadow: [
          BoxShadow(
            color: teal.withOpacity(0.08), // Soft teal glow
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Health & Wellness Badge
              Row(
                children: [
                  Icon(Icons.spa_rounded, color: teal, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    "Wellness Care Points",
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 12.sp,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Points Value
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "${model.currentUser.points}",
                    style: TextStyle(
                      color: navy,
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Pts",
                    style: TextStyle(
                      color: teal,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Medical Shield Icon
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              color: teal,
              size: 36.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    HomeViewModel model,
    HospitalSection section,
  ) {
    return GestureDetector(
      onTap: () => model.openSection(context, section),
      child: Container(
        height: 220.h, // NEW: Fixed height for the banner
        width: double.infinity, // NEW: Stretch to full width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image?.asset(section.imageUrl, fit: BoxFit.cover),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      const Color(0xFF0D1B34).withOpacity(0.95),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              // 3. Section Title & Subtitle
              Positioned(
                bottom: 24.h,
                left: 20.w,
                right: 20.w,
                child: Row(
                  children: [
                    Text(
                      section.mainTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
