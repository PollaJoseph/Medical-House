/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/View/HomeView.dart';
import 'package:medical_house/ViewModel/OnboardingViewModel.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late OnboardingViewModel _viewModel;
  final PageController _pageController = PageController();

  // Define a Medical Color Palette
  final Color primaryBlue = const Color(0xFF007BFF);
  final Color softBlueBg = const Color(0xFFF0F7FF);
  final Color medicalTeal = const Color(0xFF00A8A8);

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() async {
    if (_viewModel.currentIndex == _viewModel.pages.length - 1) {
      await _viewModel.completeOnboarding();
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Homeview()));
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlueBg,
      body: Stack(
        children: [
          // Background Decorative Circle for a "Medical" feel
          Positioned(
            top: -100.h,
            right: -50.w,
            child: CircleAvatar(
              radius: 150.r,
              backgroundColor: primaryBlue.withOpacity(0.05),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Modern Skip Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => _onNextPressed(), // Or direct to Home
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _viewModel.updateIndex,
                    itemCount: _viewModel.pages.length,
                    itemBuilder: (context, index) {
                      final page = _viewModel.pages[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Illustration Container
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: 320.h,
                            padding: EdgeInsets.all(20.w),
                            child: Image.asset(page.imageAsset),
                          ),

                          SizedBox(height: 20.h),

                          // Content Card
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30.w),
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 20.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  page.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A1C1E),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  page.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.black54,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Footer Section
                Padding(
                  padding: EdgeInsets.all(30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Smooth Dot Indicators
                      Row(
                        children: List.generate(
                          _viewModel.pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6),
                            height: 6,
                            width: _viewModel.currentIndex == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: _viewModel.currentIndex == index
                                  ? primaryBlue
                                  : primaryBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      // Circular Progress/Next Button
                      GestureDetector(
                        onTap: _onNextPressed,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 70.w,
                              height: 70.w,
                              child: CircularProgressIndicator(
                                value:
                                    (_viewModel.currentIndex + 1) /
                                    _viewModel.pages.length,
                                strokeWidth: 3,
                                backgroundColor: primaryBlue.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryBlue,
                                ),
                              ),
                            ),
                            Container(
                              width: 54.w,
                              height: 54.w,
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryBlue.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _viewModel.currentIndex ==
                                        _viewModel.pages.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/View/HomeView.dart';
import 'package:medical_house/ViewModel/OnboardingViewModel.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late OnboardingViewModel _viewModel;
  final PageController _pageController = PageController();

  // Modern Medical Palette
  final Color primaryColor = const Color(0xFF2D62ED);
  final Color accentColor = const Color(0xFF00D2B4);

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  primaryColor.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _viewModel.updateIndex,
                    itemCount: _viewModel.pages.length,
                    itemBuilder: (context, index) {
                      final page = _viewModel.pages[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Floating Image with shadow
                          Container(
                            height: 280.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  blurRadius: 30,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: Image.asset(page.imageAsset),
                          ),
                          SizedBox(height: 40.h),
                          _buildGlassCard(page),
                        ],
                      );
                    },
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Branding Logo Placeholder
          CircleAvatar(
            backgroundColor: primaryColor.withOpacity(0.1),
            radius: 20.r,
            child: Icon(
              Icons.health_and_safety,
              color: primaryColor,
              size: 20.sp,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Homeview()),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(page) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // AnimatedSwitcher makes text change smoothly
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              page.title,
              key: ValueKey(page.title),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0D1B34),
                letterSpacing: -1,
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.blueGrey[400],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Modern Pagination Dots
          Row(
            children: List.generate(
              _viewModel.pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.only(right: 8),
                height: 5,
                width: _viewModel.currentIndex == index ? 25 : 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: _viewModel.currentIndex == index
                      ? LinearGradient(colors: [primaryColor, accentColor])
                      : LinearGradient(
                          colors: [Colors.grey.shade300, Colors.grey.shade300],
                        ),
                ),
              ),
            ),
          ),

          // Action Button
          ElevatedButton(
            onPressed: () {
              if (_viewModel.currentIndex == _viewModel.pages.length - 1) {
                _viewModel.completeOnboarding();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const Homeview()),
                );
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 18.h),
              elevation: 5,
              shadowColor: primaryColor.withOpacity(0.4),
            ),
            child: Text(
              _viewModel.currentIndex == _viewModel.pages.length - 1
                  ? 'Start Journey'
                  : 'Next',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/View/SignUpView.dart';
import 'package:medical_house/ViewModel/OnboardingViewModel.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late OnboardingViewModel _viewModel;
  final PageController _pageController = PageController();

  final Color surfaceWhite = const Color(0xFFFDFDFD);

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Moves the controller smoothly to the final index
  void _jumpToLastPage() {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _viewModel.pages.length - 1,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutExpo,
      );
    }
  }

  void _finishOnboarding() async {
    await _viewModel.completeOnboarding();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SignUpView()));
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _viewModel.pages[_viewModel.currentIndex];

    return Scaffold(
      backgroundColor: surfaceWhite,
      body: Stack(
        children: [
          // 1. Background UI Accent (Decorative Circle)
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 400.r,
              height: 400.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.SeconadryColor.withOpacity(0.08),
              ),
            ),
          ),

          // 2. FIXED SKIP BUTTON (Top Right Position)
          Positioned(
            top: 50.h,
            right: 20.w,
            child: AnimatedOpacity(
              // Fades out on the last page to keep the UI clean
              opacity: _viewModel.currentIndex == _viewModel.pages.length - 1
                  ? 0.0
                  : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring:
                    _viewModel.currentIndex == _viewModel.pages.length - 1,
                child: TextButton(
                  onPressed: _jumpToLastPage,
                  style: TextButton.styleFrom(
                    foregroundColor: Constants.midnightNavy.withOpacity(0.5),
                  ),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Main Content Layer
          Column(
            children: [
              Expanded(
                flex: 11,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _viewModel.updateIndex,
                  itemCount: _viewModel.pages.length,
                  itemBuilder: (context, index) {
                    return AnimatedScale(
                      duration: const Duration(milliseconds: 800),
                      scale: _viewModel.currentIndex == index ? 1.0 : 0.85,
                      curve: Curves.easeOutExpo,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 80.h,
                          left: 40.w,
                          right: 40.w,
                        ),
                        child: Image.asset(
                          _viewModel.pages[index].imageAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section: Navy Content Portal
              Expanded(
                flex: 9,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constants.midnightNavy,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                      topRight: Radius.circular(50.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            currentPage.title,
                            key: ValueKey(currentPage.title),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          currentPage.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14.sp,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        _buildFooterActions(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions() {
    final bool isLastPage =
        _viewModel.currentIndex == _viewModel.pages.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // DNA-Helix Indicators
        Row(
          children: List.generate(
            _viewModel.pages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: EdgeInsets.only(right: 6.w),
              height: 4.h,
              width: _viewModel.currentIndex == index ? 22.w : 8.w,
              decoration: BoxDecoration(
                color: _viewModel.currentIndex == index
                    ? Constants.SeconadryColor
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        // Concierge Action Button (Next/Check)
        GestureDetector(
          onTap: () {
            if (isLastPage) {
              _finishOnboarding();
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutExpo,
              );
            }
          },
          child: Container(
            height: 64.h,
            width: 64.w,
            decoration: BoxDecoration(
              color: Constants.SeconadryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Constants.SeconadryColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              isLastPage
                  ? Icons.check_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: Constants.midnightNavy,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }
}

/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/View/HomeView.dart';
import 'package:medical_house/ViewModel/OnboardingViewModel.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late OnboardingViewModel _viewModel;
  final PageController _pageController = PageController();
  late AnimationController _pulseController;

  // Hospital Theme Palette
  final Color hospitalBlue = const Color(0xFF0B4CBB); // Trustworthy Deep Blue
  final Color surgicalTeal = const Color(0xFF00BFA5); // Medical Clean Teal
  final Color medicalWhite = const Color(0xFFF8FAFC); // Sterilized White

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _viewModel.addListener(() => setState(() {}));

    // Heartbeat Pulse Animation for the button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: medicalWhite,
      body: Stack(
        children: [
          // 1. Medical Grid Background Pattern (Subtle)
          Positioned.fill(
            child: CustomPaint(
              painter: MedicalGridPainter(hospitalBlue.withOpacity(0.03)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHospitalHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _viewModel.updateIndex,
                    itemCount: _viewModel.pages.length,
                    itemBuilder: (context, index) {
                      final page = _viewModel.pages[index];
                      return _buildPageContent(page);
                    },
                  ),
                ),
                _buildMedicalFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(Icons.local_hospital_rounded, color: hospitalBlue, size: 28.sp),
          SizedBox(width: 8.w),
          Text(
            "MEDICAL HOUSE",
            style: TextStyle(
              color: hospitalBlue,
              fontWeight: FontWeight.w900,
              fontSize: 16.sp,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Homeview()),
            ),
            child: Text(
              'SKIP',
              style: TextStyle(color: Colors.blueGrey[300], fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with a "Medical Scan" Glow
          Container(
            height: 260.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: surgicalTeal.withOpacity(0.15),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.asset(page.imageAsset),
          ),
          SizedBox(height: 50.h),

          // Modern Minimalist Text
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.blueGrey[600],
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalFooter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // DNA-style Page Indicators
          Row(
            children: List.generate(
              _viewModel.pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.only(right: 6),
                height: _viewModel.currentIndex == index ? 12 : 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _viewModel.currentIndex == index
                      ? surgicalTeal
                      : hospitalBlue.withOpacity(0.1),
                ),
              ),
            ),
          ),

          // Heartbeat Pulse Button
          ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.05).animate(_pulseController),
            child: ElevatedButton(
              onPressed: () {
                if (_viewModel.currentIndex == _viewModel.pages.length - 1) {
                  _viewModel.completeOnboarding();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const Homeview()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.fastOutSlowIn,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hospitalBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 18.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 8,
                shadowColor: hospitalBlue.withOpacity(0.4),
              ),
              child: Text(
                _viewModel.currentIndex == _viewModel.pages.length - 1
                    ? "ENTER CLINIC"
                    : "NEXT STEP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Background Grid (Scientific Look)
class MedicalGridPainter extends CustomPainter {
  final Color gridColor;
  MedicalGridPainter(this.gridColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;
    const spacing = 30.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}*/
