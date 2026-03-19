import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Constants.dart';

// 1. Create a custom item class that accepts image paths
class CustomNavItem {
  final String selectedImage;
  final String unselectedImage;

  CustomNavItem({required this.selectedImage, required this.unselectedImage});
}

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final List<CustomNavItem> items;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ), // The "Crystal" Blur Effect
        child: Container(
          height: Constants.screenHeight(context) * 0.08,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2), // Transparent floating look
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: Constants.screenWidth(context) * 0.002,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              final item = items[index];

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    isSelected ? item.selectedImage : item.unselectedImage,
                    width: 30.w,
                    height: 30.h,
                    color: isSelected ? Constants.PrimaryColor : Colors.white70,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
