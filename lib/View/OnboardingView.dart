import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    // Listen for changes in the ViewModel to refresh the UI
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
    final bool isLastPage =
        _viewModel.currentIndex == _viewModel.pages.length - 1;

    return Scaffold(
      backgroundColor: surfaceWhite,
      body: Stack(
        children: [
          // 1. Background Accent (Lowest layer)
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

          // 2. Main Content Layer (Middle layer)
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
              Expanded(
                flex: 9,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constants.MidnightNavy,
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

          // 3. Skip Button (TOP LAYER - Critical Fix)
          Positioned(
            top: 50.h,
            right: 20.w,
            child: AnimatedOpacity(
              opacity: isLastPage ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: isLastPage, // Disables clicking when hidden
                child: TextButton(
                  onPressed: _jumpToLastPage,
                  style: TextButton.styleFrom(
                    foregroundColor: Constants.MidnightNavy.withOpacity(0.5),
                  ),
                  child: Text(
                    "Skip".tr,
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

        // Action Button
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
              color: Constants.MidnightNavy,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }
}
